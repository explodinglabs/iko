# Commands

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

```sh
create-extension pgcrypto
```

Creates an extension named `pgcrypto`.

## Functions

### create-function

Create a function:

```sh
create-function <schema> <function>
```

Edit the function in the deploy script.

#### Example

```sh
create-function data playlist_updated
```

```
create-function api asset_updated
create-function-api-login
create-function-api-logout
create-function-api-refresh-token
create-function-auth-check-role-exists
create-function-auth-encrypt-pass
create-function-auth-generate-access-token
```

## Grants

### grant-usage

Grant schema usage:

```sh
grant-usage <schema> <role>
```

#### Example

```sh
grant-usage
```

Grant select:

```sh
grant-select <schema> <table> <role>
```

Grant function execute (edit the function params):

```sh
./sqitch add grant_execute_api_foo --template grant_execute --set name=api.login --set role=web_user --note 'Grant execute on api.login to web_user'
```

Grant role membership (i.e. `grant [role] to [role]`.):

```sh
grant [role] [role]
./sqitch add grant_role_membership_foo --template grant_role_membership --set from_role=web_user --set role=authenticator --note 'Grant web_user to authenticator'
```

## grant-execute

Grants execute permission on a specific function to a role.

```sh
grant-execute <schema> <function> <signature> <role>
```

### Example

```sh
grant-execute api login '(text,text)' anon
```

This grants the `anon` role permission to execute the `login` function in the
`api` schema with the `(text, text)` signature.

grant-role-membership authenticator anon
grant-schema-usage amqp api_user # extension has its own 'amqp' schema
grant-table-privilege insert api asset api_user

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
