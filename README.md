# sqitch-templates

Clone into `~/.sqitch/templates`:
```sh
git clone https://github.com/explodinglabs/sqitch-templates ~/.sqitch/templates
```

Add an ad-hoc change:
```sh
sqitch add [change] --note 'What it does'
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
drop-table [schema_name] [table_name]
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
create-trigger [schema] [table] [trigger_name] [function_name]
```

Drop trigger:
```sh
```

## Extensions

```sh
create-extension [extension]
./sqitch add create_extension_foo --template create_extension --set name=foo --note 'Create extension foo'
```

## Views

Create view (Then edit the select statement):
```sh
./sqitch add create_view_api_teams --template create_view --set schema=api --set name=teams --note 'Add api.teams view'
```

## Grants

Grant schema usage:
```sh
./sqitch add grant_api_usage_to_anon --template grant_schema_usage --set schema=api --set role=anon --note 'Grant usage on api schema to anon'
```

Grant function execute (edit the function params):
```sh
./sqitch add grant_execute_api_foo --template grant_execute --set name=api.login --set role=web_user --note 'Grant execute on api.login to web_user'
```

Grant role membership (i.e. `grant [role] to [role]`.):
```sh
./sqitch add grant_role_membership_foo --template grant_role_membership --set from_role=web_user --set role=authenticator --note 'Grant web_user to authenticator'
```

Grant view privileges:
```sh
./sqitch add grant_select_api_teams --template grant_view_privileges --set type=select --set schema=api --set table=teams --set role=web_user --note 'Grant select on api.teams to web_user'
```
