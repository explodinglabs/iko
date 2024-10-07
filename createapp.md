# Create an app

Copy the `sqitch` script from another app into the project.

Initialise sqitch.
```sh
./sqitch init myapp --uri https://github.com/explodinglabs/myapp-db --engine pg
```

Create "data" schema.
```sh
create-schema data
```

Create a table.
```sh
create-table data playlist
```

Edit the table structure in the deploy script.

At this point, start Postgres, set env vars, and then `sqitch deploy --verify`.
(see your app's README).


## Create trigger to update updated_at column

Create the function:
```sh
create-function data playlist_row_updated
./sqitch add create_function_utils_notify_row --template create_function --set schema=data --set name=playlist_row_updated --note 'Add data.playlist_row_updated function'
```

The default function updates updated_at.

Trigger the function when a row is updated:
```sh
create-trigger data playlist playlist_updated
./sqitch add create_trigger_data_playlist_updated --template create_trigger --set table_schema=data --set table_name=playlist --set trigger_name=playlist_updated --note 'Add data.team_changed trigger'
```

The default trigger simply updates updated_at.

# Trigger a NOTIFY when a row is inserted and/or updated)

Add the amqp extension (https://github.com/omniti-labs/pg_amqp), which provides
the amqp.publish function:
```sh
./sqitch add create_extension_amqp --template create_extension --set name=amqp --note 'Create extension amqp'
```
