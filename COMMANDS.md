# Commands

## Extensions

```sh
create-extension [extension]
```

create-extension pgcrypto # Adds public.crypt function used in auth.encrypt_pass
create-extension pgjwt # Adds public.sign function used in api.jwt_test
create-extension amqp # Adds amqp schema

## Functions

Create function:

```sh
create-function data playlist_updated
```

Drop function (edit the revert script to add the function back):

```sh

```

To edit a function, just edit the "create function" deploy script and sqitch
rebase, or if the project has been deployed to another environment, do a sqitch
rework.

create-function-auth-check-role-exists
create-function-auth-encrypt-pass
create-function-auth-generate-access-token
create-function-api-login
create-function-api-logout
create-function-api-refresh-token
create-function api asset_updated
create-function api playlist_updated
create-function api mpv_command # Send an MPV command
create-function api play_playlist_id # Select playlist files from db and play
create-function api play_playlist_file # Load files in a known playlist text file and play
create-function api play_files # Write playlist text file and play

## Grants

Grant schema usage:

```sh
grant-usage [schema] [role]
./sqitch add grant_api_usage_to_anon --template grant_schema_usage --set schema=api --set role=anon --note 'Grant usage on api schema to anon'
```

Grant select:

```sh
grant-select [schema] [table] [role]
./sqitch add grant_select_api_teams --template grant_view_privileges --set type=select --set schema=api --set table=teams --set role=web_user --note 'Grant select on api.teams to web_user'
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

create-trigger-auth-ensure-user-role-exists
create-trigger-auth-encrypt-pass
create-trigger api asset asset_updated asset_updated
create-trigger api playlist playlist_updated playlist_updated

## Views

Create view (Then edit the select statement):

```sh
./sqitch add create_view_api_teams --template create_view --set schema=api --set name=teams --note 'Add api.teams view'
```
