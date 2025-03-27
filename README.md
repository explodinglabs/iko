# Minimig

Minimig is a **Postgres database migration tool** with a simple DSL to make
life easier. Internally it's a Sqitch Docker container with some templates and
aliases built in.

## Installation

Create a `.env` file:

```sh
echo 'SQITCH_TARGET=postgres://user:pass@postgres:5432/app' >> .env
```

Create an alias:

```sh
alias minimig="docker run ghcr.io/minibasehq/minimig --env-file .env -v ./migrations:/repo:rw"
```

## Usage

To migrate, simply type `minimig`:

```sh
minimig
```

To create a migration:

```sh
minimig sqitch add create_table_todos --note 'Create a todos table'
```

## Schemas

Create schema:

```sh
create-schema [schema]
```

Drop schema (does not cascade, so drop everything in the schema first):

```sh
drop-schema [schema]
```

## Tables

Create table (edit the table):

```sh
create-table [schema] [table]
```

Drop table:

```sh
drop-table [schema] [table]
```

Add column:

```sh
add-column [schema] [table] [column]
```

Rename column:

```sh

```

Drop column:

```sh
drop-column [schema] [table] [column]
```

## Roles

Create role:

```sh
create-role [role] nologin
```

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

## Triggers

Create trigger:

```sh
create-trigger [schema] [table] [trigger] [function]
```

Drop trigger:

```sh

```

## Extensions

```sh
create-extension [extension]
```

## Views

Create view (Then edit the select statement):

```sh
./sqitch add create_view_api_teams --template create_view --set schema=api --set name=teams --note 'Add api.teams view'
```

```

```
