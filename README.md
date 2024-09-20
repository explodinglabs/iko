# sqitch-templates

Clone into `~/.sqitch/templates`:
```sh
git clone https://github.com/explodinglabs/sqitch-templates ~/.sqitch/templates
```

## Create extension

```sh
./sqitch add create_extension_foo --template create_extension --set name=foo --note 'Create extension foo'
```

## Create function

```sh
./sqitch add create_function_utils_notify_row_updated --template create_function --set schema=utils --set name=notify_row_updated --note 'Add utils.notify_row_updated function'
```

Then edit the function in the deploy script.

## Create schema

```sh
./sqitch add create_schema_foo --template create_schema --set name=foo --note 'Add foo schema'
```

(Nothing more to do.)

## Create table

```sh
./sqitch add create_table_foo_bar --template create_table --set schema=foo --set name=bar --note 'Add foo.bar table'
```

Then add columns to the deploy script.

## Create trigger

<blockquote>
The (trigger) name cannot be schema-qualified — the trigger inherits the schema of its
table. - <cite><a href="https://www.postgresql.org/docs/9.5/static/sql-createtrigger.html">Postgres docs</a></cite>
</blockquote>

```sh
./sqitch add create_trigger_data_team_changed --template create_trigger --set table_schema=data --set table_name=team --set trigger_name=team_changed --note 'Add data.team_changed trigger'
```

Then edit the procedure called in the deployment script.

## Create view

```sh
./sqitch add create_view_api_teams --template create_view --set schema=api --set name=teams --note 'Add api.teams view'
```

Then edit the select statement.

## Grant schema usage

```sh
./sqitch add grant_api_usage_to_anon --template grant_schema_usage --set schema=api --set role=anon --note 'Grant usage on api schema to anon'
```

## Grant function execute

```sh
./sqitch add grant_execute_api_foo --template grant_execute --set name=api.login --set role=web_user --note 'Grant execute on api.login to web_user'
```

And edit the function params.

## Grant role membership

(i.e. `grant [role] to [role]`.)

```sh
./sqitch add grant_role_membership_foo --template grant_role_membership --set from_role=web_user --set role=authenticator --note 'Grant web_user to authenticator'
```

## Grant view privileges

```sh
./sqitch add grant_select_api_teams --template grant_view_privileges --set type=select --set schema=api --set table=teams --set role=web_user --note 'Grant select on api.teams to web_user'
```


# How to create an app

Copy the `sqitch` script into the project.

Initialise sqitch.
```sh
./sqitch init myapp --uri https://github.com/explodinglabs/myapp-db --engine pg
```

Create a `utils` schema, and an `update_modified_column` function which is used in many
tables.
```sh
./sqitch add create_schema_utils --template create_schema --set name=utils --note 'Create utils schema'
./sqitch add create_function_utils_update_modified_column --template create_function --set schema=utils --set name=update_modified_column --note 'Add utils.update_modified_column function'
```

Edit the `deploy` function, it should be:
```sql
create function utils.update_modified_column() returns trigger language plpgsql as $$
begin
    new.updated_at = now();
    return new;
end;
$$;
```

Create data schema and tables.
```sh
./sqitch add create_schema_data --template create_schema --set name=data --note 'Create data schema'
./sqitch add create_table_data_play --template create_table --set schema=data --set name=play --note 'Create data.play table'
```

Edit the table structure in `deploy/create_table_data_play.sql`.

At this point, start Postgres, set env vars, and then `./sqitch deploy`. (see your app's
README). Also check verify and revert.

