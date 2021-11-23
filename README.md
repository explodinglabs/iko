## Create schema

```sh
sqitch add foo_schema --template create_schema --set name=foo --note 'Add foo schema'
```

(Nothing more to do.)

## Create table

```sh
sqitch add foo_bar --template create_table --set schema=foo --set name=bar --note 'Add foo.bar table'
```

Then add columns to the deploy script.

## Create trigger

<blockquote>
The name cannot be schema-qualified — the trigger inherits the schema of its
table. - <cite><a href="https://www.postgresql.org/docs/9.5/static/sql-createtrigger.html">Postgres docs</a></cite>
</blockquote>

```sh
sqitch add data_team_changed_trigger --template create_trigger --set table_schema=data --set table_name=team --set trigger_name=team_changed --note 'Add data.team_changed trigger'
```

Then edit the procedure called in the deployment script.

## Create function

```sh
sqitch add utils_notify_row_updated --template create_function --set schema=utils --set name=notify_row_updated --note 'Add utils.notify_row_updated function'
```

Then edit the function in the deploy script.

## Create view

```sh
sqitch add api_teams --template create_view --set schema=api --set name=teams --note 'Add api.teams view'
```

Then edit the select statement.
