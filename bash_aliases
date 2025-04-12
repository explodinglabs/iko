set -e

# Utility functions

get_options() {
  options=()
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --*=*|-?=*)  # --key=value or -k=value
        options+=("$1")
        ;;
      --*|-?)  # --flag or -f (no value)
        options+=("$1")
        ;;
    esac
    shift
  done
}

get_positionals() {
  local arg
  local seen_double_dash=0
  positionals=()

  for arg in "$@"; do
    if [[ "$arg" == -- ]]; then
      seen_double_dash=1
      continue
    fi
    if [[ $seen_double_dash == 1 || "$arg" != -* ]]; then
      positionals+=("$arg")
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
    local val="${values[$i]}"
    printf -v "$var" %s "$val"
  done
}

function extract_schema {
  # Extract the schema from a db object. Give the empty string if it's not
  # schema-qualified.
  #
  # Examples:
  #   "api.login" -> "api"
  #   "login" -> ""
  local schema="${1%%.*}"
  echo "$schema"
}

function extract_schema_plus_dot {
  # Extract the schema from a db object - including the dot. Give the empty
  # string if it's not schema-qualified.
  #
  # Examples:
  #   "api.login" -> "api."
  #   "login" -> ""
  local schema="${1%%.*}"
  echo "$schema"
}

function strip_schema {
  # Strip the schema from a db object.
  #
  # Examples:
  #   "api.login" -> "login"
  #   "login" -> "login"
  echo "$1" | cut -d . -f2
}

function show_files {
  # batcat adds ^M chars to the output unless --paging=never is used
  batcat --style=plain --paging=never deploy/${1}.sql
}

# Alias some common sqitch commands

function init {
  sqitch init "$@"
}

function add {
  sqitch add "$@"
}

function deploy {
  sqitch deploy "$@"
}

function verify {
  sqitch verify "$@"
}

function revert {
  sqitch revert "$@"
}

# Comment

function comment {
  get_options "$@"
  get_positionals "$@"

  # Get the object - all args except the last
  local object="${positionals[@]:0:${#positionals[@]}-1}"
  # Get the change name, stripping non alphanum chars
  local underscores="comment_${object// /_}"
  local change=${underscores//[^a-zA-Z0-9_]}
  # Get the comment (the last param)
  local comment_="${positionals[-1]}"

  sqitch add $options \
    --change $change \
    --template comment \
    --set object="$object" \
    --set comment="$comment_" \
    --note \'"Comment on $object"\'

  show_files $change
}

# Extensions

function create_extension {
  get_options "$@"
  get_positionals_as "$@" -- extension change
  local change=${change:-create_extension_$extension}

  sqitch add $options \
    --change $change \
    --template create_extension \
    --set extension=$extension \
    --note \'"Create $extension extension"\'

  show_files $change
}

# Functions

function create_function {
  get_options "$@"
  get_positionals_as "$@" -- schema_qualified_function change
  local schema=$(extract_schema $schema_qualified_function)
  local function=$(strip_schema $schema_qualified_function)
  local change=${change:-create_function_${schema_qualified_function//\./_}}

  sqitch add $options \
    --change $change \
    --template create_function \
    --set schema_qualified_function=$schema_qualified_function \
    --set schema=$schema \
    --set function=$function \
    --note \'"Add $schema_qualified_function function"\'

  show_files $change
}

function create_function_as {
  get_options "$@"
  get_positionals_as "$@" -- schema_qualified_function change
  local schema=$(extract_schema $schema_qualified_function)
  local function=$(strip_schema $schema_qualified_function)
  local change=${change:-create_function_${schema_qualified_function//\./_}}
  local sql=$(cat)

  sqitch add $options \
    --change $change \
    --template create_function_as \
    --set schema_qualified_function=$schema_qualified_function \
    --set schema=$schema \
    --set function=$function \
    --set sql="$sql" \
    --note \'"Add $schema_qualified_function function"\'

  show_files $change
}

# Grants

function grant_execute {
  get_options "$@"
  get_positionals_as "$@" -- schema_qualified_function params role change
  local schema=$(extract_schema $schema_qualified_function)
  local function=$(strip_schema $schema_qualified_function)
  local change=${change:-grant_execute_${schema_qualified_function//\./_}_to_${role}}

  sqitch add $options \
    --change $change \
    --template grant_execute \
    --set schema_qualified_function=$schema_qualified_function \
    --set schema=$schema \
    --set function=$function \
    --set params=$params \
    --set role=$role \
    --note \'"Grant execute on $schema_qualified_function to $role"\'

  show_files $change
}

function grant_schema_usage {
  get_options "$@"
  get_positionals_as "$@" -- schema role change
  local change=${change:-grant_schema_usage_${schema}_to_${role}}

  sqitch add $options \
    --change $change \
    --template grant_schema_usage \
    --set role=$role \
    --set schema=$schema \
    --note \'"Grant $schema to $role"\'

  show_files $change
}

function grant_role_membership {
  get_options "$@"
  get_positionals_as "$@" -- role role_specification change
  local change=${change:-grant_role_membership_${role}_to_${role_specification}}

  sqitch add $options \
    --change $change \
    --template grant_role_membership \
    --set role=$role \
    --set role_specification=$role_specification \
    --note \'"Grant $role to $role_specification"\'

  show_files $change
}

function grant_table_privilege {
  get_options "$@"
  get_positionals_as "$@" -- type schema_qualified_table role change
  local change=${change:-grant_table_privilege_${type}_on_${schema_qualified_table//\./_}_to_${role}_to_${role}}

  sqitch add $options \
    --change $change \
    --template grant_table_privilege \
    --set role=$role \
    --set type=$type \
    --set schema_qualified_table=$schema_qualified_table \
    --set schema=$schema \
    --set table=$table \
    --note \'"Grant $type on $schema_qualified_table to $role"\'

  show_files $change
}

# Roles

function create_role {
  get_options "$@"
  get_positionals_as "$@" -- role change
  local change=${change:-create_role_${role}}

  sqitch add $options \
    --change $change \
    --template create_role \
    --set role=$role \
    --note \'"Create $role role"\'

  show_files $change
}

function create_login_role {
  get_options "$@"
  get_positionals_as "$@" -- role password change
  local change=${change:-create_role_${role}}

  sqitch add $options \
    --change $change \
    --template create_login_role
    --set role=$role \
    --set password=$password \
    --note \'"Create $role role"\'

  show_files $change
}

# Schema

function create_schema {
  get_options "$@"
  get_positionals_as "$@" -- schema change
  local change=${change:-create_schema_$schema}

  sqitch add $options \
    --change $change \
    --template create_schema \
    --set schema=$schema \
    --note \'"Create $schema schema"\'

  show_files $change
}

# Tables

function create_table {
  get_options "$@"
  get_positionals_as "$@" -- schema_qualified_table change
  local change=${change:-create_table_${schema_qualified_table//\./_}}

  sqitch add $options \
    --change $change \
    --template create_table \
    --set schema_qualified_table=$schema_qualified_table \
    --set schema=$(extract_schema $schema_qualified_table) \
    --set table=$(strip_schema $schema_qualified_table) \
    --note \'"Create $schema_qualified_table table"\'

  show_files $change
}

function create_table_as {
  get_options "$@"
  get_positionals_as "$@" -- schema_qualified_table change
  local change=${change:-create_table_${schema_qualified_table//\./_}}
  local sql=$(cat)

  sqitch add $options \
    --change $change \
    --template create_table_as \
    --set schema_qualified_table=$schema_qualified_table \
    --set schema=$(extract_schema $schema_qualified_table) \
    --set table=$(strip_schema $schema_qualified_table) \
    --set sql="$sql" \
    --note \'"Add $schema_qualified_table table"\'

  show_files $change
}

# Triggers

function create_trigger {
  get_options "$@"
  get_positionals_as "$@" -- trigger schema_qualified_table schema_qualified_function change
  local change=${change:-create_trigger_$trigger_on_${schema_qualified_table//\./_}}

  sqitch add $options \
    --change $change \
    --template create_trigger \
    --set trigger=$trigger \
    --set schema_qualified_table=$schema_qualified_table \
    --set schema=$(extract_schema $schema_qualified_table) \
    --set table=$(strip_schema $schema_qualified_table) \
    --set schema_qualified_function=$schema_qualified_function \
    --note \'"Add trigger $trigger on $schema_qualified_table"\'

  show_files $change
}

function create_trigger_as {
  get_options "$@"
  get_positionals_as "$@" -- trigger schema_qualified_table schema_qualified_function change
  local change=${change:-create_trigger_$trigger_on_${schema_qualified_table//\./_}}
  local sql=$(cat)

  sqitch add $options \
    --change $change \
    --template create_trigger \
    --set trigger=$trigger \
    --set schema_qualified_table=$schema_qualified_table \
    --set schema=$(extract_schema $schema_qualified_table) \
    --set table=$(strip_schema $schema_qualified_table) \
    --set schema_qualified_function=$schema_qualified_function \
    --set sql=$sql \
    --note \'"Add trigger $trigger on $schema_qualified_table"\'

  show_files $change
}
