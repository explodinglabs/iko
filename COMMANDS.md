# Commands

- [Ad-hoc](#adhoc)
- [Extensions](#extensions)
- [Functions](#functions)
- [Grants](#grants)
- [Roles](#roles)
- [Schemas](#schemas)
- [Tables](#tables)
- [Triggers](#triggers)
- [Views](#views)

## Extensions

### create-extension

Create an extension:

```sh
create-extension <extension>
```

#### Example

Create an extension named `pgcrypto`:

```sh
create-extension pgcrypto
```

## Functions

### create-function

Create a function:

```sh
create-function <schema> <function>
```

Edit the function in the deploy script.

#### Example

Create a function named `update` in the `api` schema:

```sh
create-function api update
```

### create-function-as

Create a function, writing the function inline:

```sh
create-function-as <schema> <function> <sql>
```

This is useful in bulk migration scripts.

#### Example

Create a function named `api.square`:

```sh
create-function-as api square <<EOF
create function api.square(@number int) returns int as
begin
    return @number * @number;
end;
EOF
```

## Grants

### grant-execute

Grants execute permission on a specific function to a role.

```sh
grant-execute <schema> <function> <signature> <role>
```

### Example

```sh
grant-execute api login '(text,text)' anon
```

This grants the `anon` role permission to execute the `api.login(text,text)`
function.

### grant-schema-usage

Grant schema usage:

```sh
grant-schema-usage <schema> <role>
```

#### Example

```sh
grant-schema-usage api api_user
```

Grants usage of the `api` schema to `api_user`.

### grant-role-membership

Grant role membership:

```sh
grant-role-membership <role_specification> <role>
```

Example:

```sh
grant-role-membership authenticator api_user
```

Grants membership in `authenticator` to `api_user`.

### grant-table-privilege

Grant table privilege:

```sh
grant-table-privilege <privilege> <schema> <table> <role>
```

For example:

```sh
grant-table-privilege insert api asset api_user
```

Allows an `api_user` to insert into the `api.asset` table.

## Roles

### create-role

Creates a `nologin` role.

```sh
create-role <role>
```

### Example:

```sh
create-role dbuser
```

Creates a role named `dbuser`.

## create-role-login

Creates a login role with a specified password.

```sh
create-role-login <role> <password>
```

### Example

```sh
create-role-login dbuser 'securepass123'
```

This creates a login role named `dbuser` with the password `securepass123`.

## Schemas

### create-schema

Create a schema:

```sh
create-schema <schema>
```

#### Example

```sh
create-schema api
```

Creates a schema named `api`.

## Tables

Create a table (after this command, edit the table):

```sh
create-table <schema> <table>
```

#### Example

```sh
create-table api asset
```

Drop table:

```sh
drop-table api tasks
```

Add column:

```sh
add-column api tasks name
```

Drop column:

```sh
drop-column [schema] [table] [column]
```

create-table-auth-user
create-table-auth-refresh-token
create-table api asset
create-table api playlist_asset
create-table api playlist

## Triggers

Create trigger:

```sh
create-trigger [schema] [table] [trigger] [function]
```

Drop trigger:

```sh

```

```
create-trigger-auth-ensure-user-role-exists
create-trigger-auth-encrypt-pass
create-trigger api asset asset_updated asset_updated
create-trigger api playlist playlist_updated playlist_updated
```

## Views

Create view (Then edit the select statement):

```sh
./sqitch add create_view_api_teams --template create_view --set schema=api --set name=teams --note 'Add api.teams view'
```
