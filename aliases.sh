function show-files {
    local change=$1
    cat deploy/${change}.sql
    # for i in deploy verify revert; do cat $i/${change}.sql; done
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

function grant-role {
    local from_role=$1
    local to_role=$2
    local change=${3:-grant_${from_role}_to_${to_role}}
    sqitch add $change \
        --template grant_role \
        --set from_role=$from_role \
        --set to_role=$to_role \
        --note \'"Grant ${from_role} to ${to_role}"\' \
    && show-files $change
}

function grant-usage {
    local role=$1
    local to=$2
    local change=${3:-grant_usage_on_${what// /_}_to_${role}}
    sqitch add $change \
        --template grant_usage \
        --set role=$role \
        --set what=$what \
        --note \'"Grant usage on ${what}"\' \
    && show-files $change
}

function grant {
    local role=$1
    local type=$2
    local schema=$3
    local table=$4
    local change=${5:-grant_${role}_${type}_on_${schema}_${table}}
    sqitch add $change \
        --template grant \
        --set role=$role \
        --set type=$type \
        --set schema=$schema \
        --set table=$table \
        --note \'"Grant ${role} ${type} on ${schema}.${table}"\' \
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

# Triggers

function create-trigger {
    local schema=$1
    local table=$2
    local trigger=$3
    local function=$4
    local change=${5:-create_trigger_${schema}_${table}_${trigger}}
    sqitch add $change \
         --template create_trigger \
         --set schema=$schema \
         --set table=$table \
         --set trigger=$trigger \
         --set function=$function \
         --note \'"Add trigger $trigger on ${schema}.${table}"\' \
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
