# Create an app

Copy the `sqitch` script from another app into the project.

Initialise sqitch.
```sh
./sqitch init myapp --uri https://github.com/explodinglabs/myapp-db --engine pg
```

Create a `utils` schema.
```sh
./sqitch add create_schema_utils --template create_schema --set name=utils --note 'Create utils schema'
```

Create an `update_modified_column` function which is used in many tables.
```sh
./sqitch add create_function_utils_update_modified_column --template create_function --set schema=utils --set name=update_modified_column --note 'Add utils.update_modified_column function'
```

Edit the deploy function. It should be:
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

Edit the table structure in the deploy script.

At this point, start Postgres, set env vars, and then `./sqitch deploy`. (see your app's
README). Also check verify and revert.

## To create a trigger

```sh
./sqitch add create_trigger_data_play_added --template create_trigger --set trigger_name=play_added --set table=data.play --set event=play-added --note 'Add play_added trigger'
```
