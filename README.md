<p align="center">
  <img alt="Ply logo" height="100" src="https://github.com/minibasehq/ply/blob/main/.images/logo.png?raw=true" />
</p>

_Ply_ is a **Postgres database migration tool**, extending
[Sqitch](https://sqitch.org/) with a DSL to make common database changes easy.

## Usage

Paste the following in a terminal to create a `ply` function:

<small>Put it inside your shell's rc file for permanence. Functions are defined differently in some shells such as Fish.</small>

```sh
ply() { docker run --rm --volume ${PWD}/migrations:/repo:rw ghcr.io/minibasehq/ply bash -c "$*" }
```

Initialise Sqitch:

```sh
ply sqitch init --target postgres://user:pass@localhost:5432/app myapp
```

Let's make a new schema named "api" (See the [full list of migration
commands](wiki)):

```sh
ply create-schema api
```

Sqitch creates three SQL scripts – to deploy, verify and revert the change. The
deploy script is output so you can see the change that will be deployed.

Use Sqitch to deploy changes:

```sh
ply sqitch deploy
```

## Bulk migration scripts

You might write a script to perform many migrations at once. For example,
create a `migrations/create-app.sh`:

```sh
create-schema api

# Create Tasks table
create-table api task
create-function api task_updated
create-trigger api task task_updated task_updated

# Create basic subscriber role
create-role basic_subscriber
grant-role-membership authenticator basic_subscriber
grant-schema-usage api basic_subscriber
grant-table-privilege select api task basic_subscriber
grant-table-privilege insert api task basic_subscriber
grant-table-privilege update api task basic_subscriber
```

Then execute the script to create all migrations at once:

```sh
ply bash create-app.sh
```
