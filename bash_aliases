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
    echo "❌ get_positionals_as error: expected '--' to separate args and variable names." >&2
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
  # Extract the schema from a dot-delimited string, defaulting to "public".
  # e.g. login -> public
  # e.g. api.login -> api
  local schema="${1%%.*}"
  [[ "$1" == "$schema" ]] && schema="public" # Default to "public" if no dot
  echo "$schema"
}

function extract_object {
  # Extract the schema from a dot-delimited string, defaulting to "public".
  # e.g. login -> login
  # e.g. api.login -> login
  echo "$1" | cut -d . -f2
}

function show_files {
  cat deploy/${1}.sql
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

  # Get the object - all args except the last, stripping non-alphanum chars
  local object="${positionals[@]:0:${#positionals[@]}-1}"
  # Get the change name
  local underscores="comment_${object// /_}"
  local change=${underscores//[^a-zA-Z0-9_]}
  # Get the comment (the last param)
  local comment_="${positionals[-1]}"  # Get the last arg (the comment)

  sqitch add $options $change \
    --template comment \
    --set object="$object" \
    --set comment="$comment_" \
    --note \'"Comment on $object"\' \
    && show_files $change
}

# Extensions

function create_extension {
  get_options "$@"
  get_positionals_as "$@" -- extension change

  sqitch add $options \
    --change ${change:-create_extension_$extension}
    --template create_extension \
    --set extension=$extension \
    --note \'"Create $extension extension"\' \
    && show_files $change
}

# Functions

function create_function {
  get_options "$@"
  get_positionals_as "$@" -- function change
  local schema=$(extract-schema $function)
  local function=$(extract-object $function)

  sqitch add $options \
    --change ${change:-create_function_${schema}_${function}} \
    --template create_function \
    --set schema=$schema \
    --set function=$function \
    --note \'"Add ${schema}.${function} function"\' \
    && show_files $change
}

function create_function_as {
  get_options "$@"
  get_positionals_as "$@" -- function change
  local schema=$(extract-schema $function)
  local function=$(extract-object $function)
  local change=${change:-create_function_${schema}_${function}}
  local sql=$(cat)

  sqitch add $options \
    --change $change \
    --template create_function_as \
    --set schema=$schema \
    --set function=$function \
    --set sql="$sql" \
    --note \'"Add ${schema}.${function} function"\' \
    && show_files $change
}

# Grants

function grant_execute {
  get_options "$@"
  get_positionals_as "$@" -- function params role change
  local schema=$(extract-schema $function)
  local function=$(extract-object $function)
  local change=${5:-grant_execute_${schema}_${function}_to_${role}}

  sqitch add $options \
    --change $change \
    --template grant_execute \
    --set schema=$schema \
    --set function=$function \
    --set params=$params \
    --set role=$role \
    --note \'"Grant execute on ${schema}.${function} to ${role}"\' \
    && show_files $change
}

function grant_schema_usage {
  local options=$(getoptions)
  local schema=$1
  local role=$2
  local change=${3:-grant_schema_usage_${schema}_to_${role}}

  sqitch add $change \
    --template grant_schema_usage \
    --set role=$role \
    --set schema=$schema \
    --note \'"Grant ${schema} to ${role}"\' \
    && show_files $change
}

function grant_role_membership {
  local options=$(getoptions)
  local role=$1
  local role_specification=$2
  local change=${3:-grant_role_membership_${role}_to_${role_specification}}

  sqitch add $change \
    --template grant_role_membership \
    --set role=$role \
    --set role_specification=$role_specification \
    --note \'"Grant ${role} to ${role_specification}"\' \
    && show_files $change
}

function grant_privilege {
  local options=$(getoptions)
  local type=$1
  local schema=$2
  local table=$3
  local role=$4
  local change=${5:-grant_privilege_${type}_on_${schema}_${table}_to_${role}}

  sqitch add $change \
    --template grant_privilege \
    --set role=$role \
    --set type=$type \
    --set schema=$schema \
    --set table=$table \
    --note \'"Grant ${type} on ${schema}.${table} to ${role}"\' \
    && show_files $change
}

# Roles

function create_role {
  local options=$(getoptions)
  local role=$1
  local change=${2:-create_role_${role}}

  sqitch add $change \
    --template create_role \
    --set role=$role \
    --note \'"Create ${role} role"\' \
    && show_files $change
}

function create_login_role {
  local options=$(getoptions)
  local role=$1
  local password=$2
  local change=${3:-create_role_${role}}

  sqitch add $change \
    --template create_login_role
    --set role=$role \
    --set password=$password \
    --note \'"Create ${role} role"\' \
    && show_files $change
}

# Schema

function create_schema {
  local options=$(getoptions)
  local schema=$1
  local change=${2:-create_schema_$schema}

  sqitch add $change \
    --template create_schema \
    --set schema=$schema \
    --note \'"Create $schema schema"\' \
    && show_files $change
}

# Tables

function create_table {
  local options=$(getoptions)
  local schema=$1
  local table=$2
  local change=${3:-create_table_${schema}_${table}}

  sqitch add $change \
    --template create_table \
    --set schema=$schema \
    --set table=$table \
    --note \'"Create ${schema}.${table} table"\' \
    && show_files $change
}

function create_table_as {
  local options=$(getoptions)
  local schema=$1
  local table=$2
  local sql=$(cat)
  local change=${4:-create_table_${schema}_${table}}

  sqitch add $change \
    --template create_table_as \
    --set schema=$schema \
    --set table=$table \
    --set sql="$sql" \
    --note \'"Add ${schema}.${table} table"\' \
    && show_files $change
}

# Triggers

function create_trigger {
  local options=$(getoptions)
  local trigger=$1
  local when=$2
  local event=$3
  local schema=$4
  local table=$5
  local function=$6
  local change=${7:-create_trigger_${schema}_${table}_${trigger}}

  sqitch add $options
    --change $change \
    --template create_trigger \
    --set trigger=$trigger \
    --set when=$when \
    --set event=$event \
    --set schema=$schema \
    --set table=$table \
    --set function=$function \
    --note \'"Add trigger $trigger on ${schema}.${table}"\' \
    && show_files $change
}
