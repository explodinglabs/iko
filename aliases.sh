#!/bin/bash
# setopt aliases
# alias sqitch='./sqitch'

function show-files {
  local change=$1
  cat deploy/${change}.sql
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

function drop-schema {
  local schema=$1
  local change=${2:-drop_schema_$schema}
  sqitch add $change \
    --template drop_schema \
    --set schema=$schema \
    --note \'"Drop $schema schema"\' \
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

function add-column {
:
# sqitch add alter_table_foo_bar_add_baz --template alter_table_add_column --set schema=foo --set table=bar --set column_name=baz --set column_type=integer --note 'Add foo.bar column baz'
}

function drop-table {
  local schema=$1
  local table=$2
  local change=${3:-drop_table_${schema}_${table}}
  sqitch add $change \
    --template drop_table \
    --set schema=$schema \
    --set table=$table \
    --note \'"Drop ${schema}.${table} table"\' \
    && show-files $change \
    && echo "TODO: Recreate the table in revert/${change}.sql" >&2
}

function create-table-auth-user {
  local change=${1:-create_table_auth_user}
  sqitch add $change \
    --template create_table_auth_user \
    --note \'"Create function auth.create_table_auth_user"\' \
    && show-files $change
}

function create-table-auth-refresh-token {
  local change=${1:-create_table_auth_refresh_token}
  sqitch add $change \
    --template create_table_auth_refresh_token \
    --note \'"Create function auth.create_table_auth_refresh_token"\' \
    && show-files $change
}

# Roles

function create-role-authenticator {
  local change=${1:-create_role_authenticator}
  sqitch add $change \
    --template create_role_authenticator \
    --note \'"Create role authenticator"\' \
    && show-files $change
}

function create-role {
  local role=$1
  local change=${2:-create_role_${role}}
  sqitch add $change \
    --template create_role \
    --set role=$role \
    --note \'"Create ${role} role"\' \
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

function grant-table-privilege {
  local type=$1
  local schema=$2
  local table=$3
  local role=$4
  local change=${5:-grant_table_privilege_${type}_on_${schema}_${table}_to_${role}}
  sqitch add $change \
    --template grant_table_privilege \
    --set role=$role \
    --set type=$type \
    --set schema=$schema \
    --set table=$table \
    --note \'"Grant ${type} on ${schema}.${table} to ${role}"\' \
    && show-files $change
}

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

# Functions

function create-function {
  local schema=$1
  local function=$2
  local change=${3:-create_function_${schema}_${function}}
  sqitch add $change \
    --template create_function \
    --set schema=$schema \
    --set function=$function \
    --note \'"Add ${schema}.${function} function"\' \
    && show-files $change
}

function create-function-auth-check-role-exists {
  local change=${1:-create_function_auth_check_role_exists}
  sqitch add $change \
    --template create_function_auth_check_role_exists \
    --note \'"Create function auth.check_role_exists"\' \
    && show-files $change
}

function create-function-auth-encrypt-pass {
  local change=${1:-create_function_auth_encrypt_pass}
  sqitch add $change \
    --template create_function_auth_encrypt_pass \
    --note \'"Create function auth.encrypt_pass"\' \
    && show-files $change
}

function create-function-auth-generate-access-token {
  local change=${1:-create_function_auth_generate_access_token}
  sqitch add $change \
    --template create_function_auth_generate_access_token \
    --note \'"Create function auth.generate_access_token"\' \
    && show-files $change
}

function create-function-api-login {
  local change=${1:-create_function_api_login}
  sqitch add $change \
    --template create_function_api_login \
    --note \'"Create function api.login"\' \
    && show-files $change
}

function create-function-api-logout {
  local change=${1:-create_function_api_logout}
  sqitch add $change \
    --template create_function_api_logout \
    --note \'"Create function api.logout"\' \
    && show-files $change
}

function create-function-api-refresh-token {
  local change=${1:-create_function_api_refresh_token}
  sqitch add $change \
    --template create_function_api_refresh_token \
    --note \'"Create function api.refresh_token"\' \
    && show-files $change
}

# Triggers

function create-trigger {
  local schema=$1
  local table=$2
  local function=$3
  local trigger=$4
  local change=${5:-create_trigger_${schema}_${table}_${trigger}}
  sqitch add $change \
    --template create_trigger \
    --set schema=$schema \
    --set table=$table \
    --set function=$function \
    --set trigger=$trigger \
    --note \'"Add trigger $trigger on ${schema}.${table}"\' \
    && show-files $change
}

function create-trigger-auth-ensure-user-role-exists {
  local change=${1:-create_trigger_auth_ensure_user_role_exists}
  sqitch add $change \
    --template create_trigger_auth_ensure_user_role_exists \
    --note \'"Create trigger auth.ensure_user_role_exists"\' \
    && show-files $change
}

function create-trigger-auth-encrypt-pass {
  local change=${1:-create_trigger_auth_encrypt_pass}
  sqitch add $change \
    --template create_trigger_auth_encrypt_pass \
    --note \'"Create trigger auth.encrypt_pass"\' \
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
