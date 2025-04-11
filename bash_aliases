# Utility functions

function extract-schema {
  # Extract the schema from a dot-delimited string, defaulting to "public".
  # e.g. login -> public
  # e.g. api.login -> api
  local schema="${1%%.*}"
  [[ "$1" == "$schema" ]] && schema="public" # Default to "public" if no dot
  echo "$schema"
}

function extract-object {
  # Extract the schema from a dot-delimited string, defaulting to "public".
  # e.g. login -> login
  # e.g. api.login -> login
  echo "$1" | cut -d . -f2
}

function show-files {
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
  local object="${*%${!#}}"  # Get all args except the last
  local is="${@: -1}"  # Get the last arg (the comment)
  local change=${comment_${object// /_}}
  sqitch add $change \
    --template comment \
    --set object=$object \
    --set comment=$is \
    --note \'"Comment on $object"\' \
    && show-files $change
}

# Extensions

function create-extension {
  local extension=$1
  local change=${2:-create_extension_$extension}
  sqitch add $change \
    --template create_extension \
    --set extension=$extension \
    --note \'"Create $extension extension"\' \
    && show-files $change
}

# Functions

function create-function {
  local schema=$(extract-schema $1)
  local function=$(extract-object $1)
  local change=${2:-create_function_${schema}_${function}}
  sqitch add $change \
    --template create_function \
    --set schema=$schema \
    --set function=$function \
    --note \'"Add ${schema}.${function} function"\' \
    && show-files $change
}

function create-function-as {
  local schema=$1
  local function=$2
  local sql=$(cat)
  local change=${4:-create_function_${schema}_${function}}
  sqitch add $change \
    --template create_function_as \
    --set schema=$schema \
    --set function=$function \
    --set sql="$sql" \
    --note \'"Add ${schema}.${function} function"\' \
    && show-files $change
}

# Grants

function grant-execute {
  local schema=$1
  local function=$2
  local params=$3
  local role=$4
  local change=${5:-grant_execute_${schema}_${function}_to_${role}}
  sqitch add $change \
    --template grant_execute \
    --set schema=$schema \
    --set function=$function \
    --set params=$params \
    --set role=$role \
    --note \'"Grant execute on ${schema}.${function} to ${role}"\' \
    && show-files $change
}

function grant-schema-usage {
  local schema=$1
  local role=$2
  local change=${3:-grant_schema_usage_${schema}_to_${role}}
  sqitch add $change \
    --template grant_schema_usage \
    --set role=$role \
    --set schema=$schema \
    --note \'"Grant ${schema} to ${role}"\' \
    && show-files $change
}

function grant-role-membership {
  local role=$1
  local role_specification=$2
  local change=${3:-grant_role_membership_${role}_to_${role_specification}}
  sqitch add $change \
    --template grant_role_membership \
    --set role=$role \
    --set role_specification=$role_specification \
    --note \'"Grant ${role} to ${role_specification}"\' \
    && show-files $change
}

function grant-privilege {
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
    && show-files $change
}

# Roles

function create-role {
  local role=$1
  local change=${2:-create_role_${role}}
  sqitch add $change \
    --template create_role \
    --set role=$role \
    --note \'"Create ${role} role"\' \
    && show-files $change
}

function create-login-role {
  local role=$1
  local password=$2
  local change=${3:-create_role_${role}}
  sqitch add $change \
    --template create_login_role
    --set role=$role \
    --set password=$password \
    --note \'"Create ${role} role"\' \
    && show-files $change
}

# Schema

function create-schema {
  local schema=$1
  local change=${2:-create_schema_$schema}
  sqitch add $change \
    --template create_schema \
    --set schema=$schema \
    --note \'"Create $schema schema"\' \
    && show-files $change
}

# Tables

function create-table {
  local schema=$1
  local table=$2
  local change=${3:-create_table_${schema}_${table}}
  sqitch add $change \
    --template create_table \
    --set schema=$schema \
    --set table=$table \
    --note \'"Create ${schema}.${table} table"\' \
    && show-files $change
}

function create-table-as {
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
    && show-files $change
}

# Triggers

function create-trigger {
  local trigger=$1
  local when=$2
  local event=$3
  local schema=$4
  local table=$5
  local function=$6
  local change=${7:-create_trigger_${schema}_${table}_${trigger}}
  sqitch add $change \
    --template create_trigger \
    --set trigger=$trigger \
    --set when=$when \
    --set event=$event \
    --set schema=$schema \
    --set table=$table \
    --set function=$function \
    --note \'"Add trigger $trigger on ${schema}.${table}"\' \
    && show-files $change
}
