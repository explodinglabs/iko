#!/bin/bash

# Only fail fast in scripts, not interactive shell
if [[ $- != *i* ]]; then
  set -euo pipefail
fi

# Alias sqitch commands

function init {
  # sqitch-init fails if SQITCH_TARGET is set.
  unset SQITCH_TARGET
  sqitch init "$@"
}

sqitch_commands=(
  config
  engine
  target
  help
  add
  bundle
  checkout
  check
  plan
  rebase
  rework
  show
  tag
  deploy
  log
  revert
  status
  uograde
  verify
)

for cmd in "${sqitch_commands[@]}"; do
  eval "
  function $cmd {
    sqitch $cmd \"\$@\"
  }"
done

# Shell command

# Set prompt if running interactively
if [[ $- == *i* ]]; then
  export PS1="✨\e[96mikō>\[\e[0m\] "
fi

function shell {
  exec bash --rcfile /etc/bash_aliases -i
}

# Utility functions

get_options() {
  local -n _result=$1
  shift
  _result=()
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --*=*|-?=*) _result+=("$1") ;;
      --*|-?)    _result+=("$1") ;;
    esac
    shift
  done
}


get_positionals() {
  local -n _out=$1
  shift

  local arg
  local seen_double_dash=0
  _out=()

  for arg in "$@"; do
    if [[ "$arg" == -- ]]; then
      seen_double_dash=1
      continue
    fi
    if [[ $seen_double_dash == 1 || "$arg" != -* ]]; then
      _out+=("$arg")
    fi
  done
}

get_positionals_as() {
  local -a args=()
  local -a names=()
  local -a values=()
  local found_separator=0

  while [[ $# -gt 0 ]]; do
    if [[ "$1" == "--" ]]; then
      found_separator=1
      shift
      break
    fi
    args+=("$1")
    shift
  done

  if [[ $found_separator -eq 0 ]]; then
    echo "❌ error: expected '--' to separate args and variable names." >&2
    return 1
  fi

  # Remaining arguments are the variable names
  while [[ $# -gt 0 ]]; do
    names+=("$1")
    shift
  done

  # Filter only positional arguments (not starting with '-') from args
  local seen_double_dash=0
  for arg in "${args[@]}"; do
    if [[ "$arg" == "--" ]]; then
      seen_double_dash=1
      continue
    fi
    if [[ "$arg" != -* || $seen_double_dash -eq 1 ]]; then
      values+=("$arg")
    fi
  done

  # Assign positionals to the provided variable names (globally)
  for i in "${!names[@]}"; do
    local var="${names[$i]}"
    if [[ $i -lt ${#values[@]} ]]; then
      val="${values[$i]}"
    else
      val=""
    fi
    printf -v "$var" %s "$val"
  done
}

extract_schema() {
  # Extract the schema from a db object. Give the empty string if it's not
  # schema-qualified.
  #
  # Examples:
  #   "api.login" -> "api"
  #   "login" -> ""
  local input="${1:-}"
  if [[ "$input" == *.* ]]; then
    echo "${input%%.*}"
  else
    echo ""
  fi
}

strip_schema() {
  # Strip the schema from a db object.
  #
  # Examples:
  #   "api.login" -> "login"
  #   "login" -> "login"
  echo "${1:-}" | cut -d . -f2
}

show_files() {
  # batcat adds ^M chars to the output unless --paging=never is used
  batcat --style=plain --paging=never deploy/${1}.sql
}

#string_to_change() {
#  # Sanitize a string to an identifier
#  # Usage: string_to_change "Some Note Here"
#  # Output: some_note_here
#
#  local s="$1"
#  local change
#
#  change=$(echo "$s" | tr '[:upper:]' '[:lower:]' | tr -cs 'a-z0-9' '_' | sed 's/^_//;s/_$//')
#  echo "$change"
#}

version() {
  echo "iko $(cat /iko_version.txt)"
  sqitch --version
}

#create() {
#  local -a options
#  local note change
#  get_options options "$@"
#  get_positionals_as "$@" -- note
#  # Generate change name by sanitising note
#  change=$(string_to_change "$note")
#
#  sqitch add "${options[@]}" \
#    --change "$change" \
#    --note "$note"
#
#  show_files $change
#}

# Comment

comment() {
  local -a options
  local object underscores change comment_
  declare -a positionals
  get_options options "$@"
  get_positionals positionals "$@"

  # Get the object - all args except the last
  object="${positionals[@]:0:${#positionals[@]}-1}"
  # Get the change name, stripping non alphanumeric chars
  underscores="comment_${object//[ .]/_}"
  change=${underscores//[^a-zA-Z0-9_]}
  # Get the comment (the last param)
  comment_="${positionals[-1]}"

  sqitch add "${options[@]}" \
    --change $change \
    --template comment \
    --set object="$object" \
    --set comment="$comment_" \
    --note \'"Comment on $object"\'

  show_files $change
}

# Extensions

create_extension() {
  local -a options
  local extension change
  get_options options "$@"
  get_positionals_as "$@" -- extension change
  change=${change:-create_extension_${extension}}

  sqitch add "${options[@]}" \
    --change $change \
    --template create_extension \
    --set extension=$extension \
    --note \'"Create $extension extension"\'

  show_files $change
}

# Functions

create_function() {
  local -a options
  local optionally_schema_qualified_function change schema function
  get_options options "$@"
  get_positionals_as "$@" -- optionally_schema_qualified_function change
  change=${change:-create_function_${optionally_schema_qualified_function//\./_}}

  sqitch add "${options[@]}" \
    --change $change \
    --template create_function \
    --set schema=$(extract_schema $optionally_schema_qualified_function) \
    --set function=$(strip_schema $optionally_schema_qualified_function) \
    --note \'"Add $optionally_schema_qualified_function function"\'

  show_files $change
}

create_function_as() {
  local -a options
  local optionally_schema_qualified_function change schema function change sql
  get_options options "$@"
  get_positionals_as "$@" -- optionally_schema_qualified_function change
  change=${change:-create_function_${optionally_schema_qualified_function//\./_}}
  sql=$(cat)

  sqitch add "${options[@]}" \
    --change $change \
    --template create_function_as \
    --set schema=$(extract_schema $optionally_schema_qualified_function) \
    --set function=$(strip_schema $optionally_schema_qualified_function) \
    --set sql="$sql" \
    --note \'"Add $optionally_schema_qualified_function function"\'

  show_files $change
}

# Grants

grant_execute() {
  local -a options
  local optionally_schema_qualified_function params role change schema function
  get_options options "$@"
  get_positionals_as "$@" -- optionally_schema_qualified_function params role change
  change=${change:-grant_execute_${optionally_schema_qualified_function//\./_}_to_${role}}

  sqitch add "${options[@]}" \
    --change $change \
    --template grant_execute \
    --set schema=$(extract_schema $optionally_schema_qualified_function) \
    --set function=$(strip_schema $optionally_schema_qualified_function) \
    --set params=$params \
    --set role=$role \
    --note \'"Grant execute $optionally_schema_qualified_function to $role"\'

  show_files $change
}

grant_schema_usage() {
  local -a options
  local schema role change
  get_options options "$@"
  get_positionals_as "$@" -- schema role change
  change=${change:-grant_schema_${schema}_usage_to_${role}}

  sqitch add "${options[@]}" \
    --change $change \
    --template grant_schema_usage \
    --set role=$role \
    --set schema=$schema \
    --note \'"Grant $schema schema usage to $role"\'

  show_files $change
}

grant_role_membership() {
  local -a options role role_specification change
  get_options options "$@"
  get_positionals_as "$@" -- role role_specification change
  change=${change:-grant_membership_${role}_to_${role_specification}}

  sqitch add "${options[@]}" \
    --change $change \
    --template grant_role_membership \
    --set role_specification=$role_specification \
    --set role=$role \
    --note \'"Grant $role membership to $role_specification"\'

  show_files $change
}

grant_table_privilege() {
  local -a options
  local type optionally_schema_qualified_table role change
  get_options options "$@"
  get_positionals_as "$@" -- type optionally_schema_qualified_table role change
  change=${change:-grant_table_privileges_${type}_on_${optionally_schema_qualified_table//\./_}_to_${role}}

  sqitch add "${options[@]}" \
    --change $change \
    --template grant_table_privilege \
    --set role=$role \
    --set type=$type \
    --set schema=$(extract_schema $optionally_schema_qualified_table) \
    --set table=$(strip_schema $optionally_schema_qualified_table) \
    --note \'"Grant $type on $optionally_schema_qualified_table table to $role"\'

  show_files $change
}

# Roles

create_role() {
  local -a options
  local role change
  get_options options "$@"
  get_positionals_as "$@" -- role change
  change=${change:-create_role_${role}}

  sqitch add "${options[@]}" \
    --change $change \
    --template create_role \
    --set role=$role \
    --note \'"Create $role role"\'

  show_files $change
}

create_login_role() {
  local -a options
  local role password change
  get_options options "$@"
  get_positionals_as "$@" -- role password change
  change=${change:-create_role_${role}}

  sqitch add "${options[@]}" \
    --change $change \
    --template create_login_role \
    --set role=$role \
    --set password=$password \
    --note \'"Create $role role"\'

  show_files $change
}

# Schema

create_schema() {
  local -a options
  local schema change
  get_options options "$@"
  get_positionals_as "$@" -- schema change
  change=${change:-create_schema_${schema}}

  sqitch add "${options[@]}" \
    --change $change \
    --template create_schema \
    --set schema=$schema \
    --note \'"Create $schema schema"\'

  show_files $change
}

# Tables

create_table() {
  local -a options
  local optionally_schema_qualified_table change
  get_options options "$@"
  get_positionals_as "$@" -- optionally_schema_qualified_table change
  change=${change:-create_table_${optionally_schema_qualified_table//\./_}}

  sqitch add "${options[@]}" \
    --change $change \
    --template create_table \
    --set schema=$(extract_schema $optionally_schema_qualified_table) \
    --set table=$(strip_schema $optionally_schema_qualified_table) \
    --note \'"Create $optionally_schema_qualified_table table"\'

  show_files $change
}

create_table_as() {
  local -a options
  local optionally_schema_qualified_table change sql
  get_options options "$@"
  get_positionals_as "$@" -- optionally_schema_qualified_table change
  change=${change:-create_table_${optionally_schema_qualified_table//\./_}}
  sql=$(cat)

  sqitch add "${options[@]}" \
    --change $change \
    --template create_table_as \
    --set schema=$(extract_schema $optionally_schema_qualified_table) \
    --set table=$(strip_schema $optionally_schema_qualified_table) \
    --set sql="$sql" \
    --note \'"Add $optionally_schema_qualified_table table"\'

  show_files $change
}

# Triggers

create_trigger() {
  local -a options
  local trigger optionally_schema_qualified_table optionally_schema_qualified_function change
  get_options options "$@"
  get_positionals_as "$@" -- trigger optionally_schema_qualified_table optionally_schema_qualified_function change
  change=${change:-create_trigger_${trigger}_on_${optionally_schema_qualified_table//\./_}}

  sqitch add "${options[@]}" \
    --change $change \
    --template create_trigger \
    --set trigger=$trigger \
    --set function_schema=$(extract_schema $optionally_schema_qualified_function) \
    --set function=$(strip_schema $optionally_schema_qualified_function) \
    --set table_schema=$(extract_schema $optionally_schema_qualified_table) \
    --set table=$(strip_schema $optionally_schema_qualified_table) \
    --note \'"Add $trigger trigger on $optionally_schema_qualified_table"\'

  show_files $change
}

create_trigger_as() {
  local -a options
  local trigger optionally_schema_qualified_table optionally_schema_qualified_function change sql
  get_options options "$@"
  get_positionals_as "$@" -- trigger optionally_schema_qualified_table optionally_schema_qualified_function change
  change=${change:-create_trigger_${trigger}_on_${optionally_schema_qualified_table//\./_}}
  sql=$(cat)

  sqitch add "${options[@]}" \
    --change $change \
    --template create_trigger_as \
    --set trigger=$trigger \
    --set function_schema=$(extract_schema $optionally_schema_qualified_function) \
    --set function=$(strip_schema $optionally_schema_qualified_function) \
    --set table_schema=$(extract_schema $optionally_schema_qualified_table) \
    --set table=$(strip_schema $optionally_schema_qualified_table) \
    --set sql="$sql" \
    --note \'"Add $trigger trigger on $optionally_schema_qualified_table"\'

  show_files $change
}
