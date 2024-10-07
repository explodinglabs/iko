# sqitch-templates

Clone into `~/.sqitch/templates`:
```sh
git clone https://github.com/explodinglabs/sqitch-templates ~/.sqitch/templates
```

## Extensions

```sh
./sqitch add create_extension_foo --template create_extension --set name=foo --note 'Create extension foo'
```

## Schemas

Create schema:
```sh
create-schema [schema_name]
```

Drop schema (does not cascade, so drop everything in the schema first):
```sh
drop-schema [schema_name]
```

## Tables

Create table (edit the table):
```sh
create-table [schema_name] [table_name]
```

Add column:
```sh
./sqitch add alter_table_foo_bar_add_baz --template alter_table_add_column --set schema=foo --set table=bar --set column_name=baz --set column_type=integer --note 'Add foo.bar column baz'
```

Alter column (Edit the revert script to set the old type):
```sh
./sqitch add alter_table_foo_bar_alter_baz --template alter_table_alter_column --set schema=foo --set table=bar --set column_name=baz --set change='type varchar(4)' --note 'Alter foo.bar column baz'
```

Drop table
```sh
drop-table
```


## Functions

Create function (edit the function):
```sh
./sqitch add create_function_utils_notify_row --template create_function --set schema=utils --set name=notify_row --note 'Add utils.notify_row function'
```

Rename function:
```sh
./sqitch add rename_function_utils_notify_row --template rename_function --set oldschema=utils --set oldname=notify_row --set newschema=utils --set newname=notify_row --note 'Rename utils.notify_row function'
```

Edit function (rework):
```sh
sqitch rework change_name --note 'Change change_name'
```

Drop function (edit the revert script to add the function back):
```sh
```

## Triggers

Create trigger:
```sh
./sqitch add create_trigger_data_team_changed --template create_trigger --set table_schema=data --set table_name=team --set trigger_name=team_changed --note 'Add data.team_changed trigger'
```

Edit trigger:
Drop the trigger then create a new one.

Drop trigger:
```sh
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
