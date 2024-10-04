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

Create an `set_updated_at` function which is used in many tables.
```sh
./sqitch add create_function_utils_set_updated_at --template create_function --set schema=utils --set name=set_updated_at --note 'Add utils.set_updated_at function'
```

Edit the function. It should be:
```sql
create function utils.set_updated_at() returns trigger language plpgsql as $$
begin
    new.updated_at = now();
    return new;
end;
$$;
```

Create data schema.
```sh
./sqitch add create_schema_data --template create_schema --set name=data --note 'Create data schema'
```

Create a table.
```sh
./sqitch add create_table_data_play --template create_table --set schema=data --set name=play --note 'Create data.play table'
```

Edit the table structure in the deploy script.

At this point, start Postgres, set env vars, and then `sqitch deploy --verify`.
(see your app's README).


## Trigger a NOTIFY when a row is inserted and/or updated)

Add the amqp extension (https://github.com/omniti-labs/pg_amqp), which provides
the amqp.publish function:
```sh
./sqitch add create_extension_amqp --template create_extension --set name=amqp --note 'Create extension amqp'
```

Create the function that will be triggered when a row is inserted:
```sh
./sqitch add create_function_utils_notify_row --template create_function --set schema=utils --set name=notify_row --note 'Add utils.notify_row function'
```

Edit the function. It should be:
```sql
create function utils.notify_row() returns trigger language plpgsql as $$
begin
    -- Params are broker_id, exchange, routing_key, message
    perform amqp.publish(1, 'amq.fanout', '', json_build_object('event', TG_ARGV[0], 'data', row_to_json(NEW)::text)::text);
    return NEW;
end;
$$;
```

Create a trigger to call the function.
```sh
./sqitch add create_trigger_data_play_added --template create_trigger --set trigger=play_added --set table_schema=data --set table_name=play --set function=utils.notify_row --set event=play --note 'Add play_added trigger'
```

The default trigger fires on "insert". Edit the trigger to have "update" or
"insert or update".
