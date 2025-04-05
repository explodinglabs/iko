<p align="center">
  <img alt="Ply logo" height="100" src="https://github.com/explodinglabs/ply/blob/main/.images/logo.png?raw=true" />
</p>

# Ply

_Ply_ is a Postgres migration tool that makes database changes easy.

It extends [Sqitch](https://sqitch.org/), adding simple [commands](/COMMANDS.md)
to create migrations. For example to create an "api" schema, you'd type `ply create-schema api`.

Sqitch is also available, so to deploy your changes you'd type `ply sqitch deploy`.

## Installation

Ply runs inside a Docker container, so ensure you have [Docker
installed](https://docs.docker.com/get-docker/).

Create a `ply` command by pasting this into your terminal:

```sh
ply() { docker run --rm -v ${PWD}/migrations:/repo:rw ghcr.io/explodinglabs/ply" bash -c "$*" }
```

💡 Add it to your `~/.bashrc` or `~/.zshrc` for persistence.

## Usage

### Initialize a Sqitch project

Run the following command to [initialize a Sqitch
project](https://sqitch.org/docs/manual/sqitch-init/) (be sure to set the
correct database connection URI):

```sh
ply sqitch init --target postgres://user:pass@localhost:5432/app myapp
```

### Create Migrations

Let's create a schema named `api` using Ply's DSL:

```sh
ply create-schema api
```

Three SQL files are created –

- `deploy/create_schema_api.sql` to deploy the change,
- `verify/create_schema_api.sql` to verify the change, and
- `revert/create_schema_api.sql` to revert the change.

The deploy script is output so you can see the change that will be deployed.
You may want to changes to it.

> 📖 See the [full list of migration commands](/COMMANDS.md).

### Deploy Migrations

Use Sqitch to deploy the change:

```sh
ply sqitch deploy
```

> 📖 Refer to the [Sqitch Manual](https://sqitch.org/docs/manual/).

## Bulk Migration Scripts

Write scripts that create multiple migrations at once. This enables you to
define change sets, or an entire application, at a high level.

For example, create a file named `migrations/create-app.sh`:

```sh
create-schema api
create-table api task
create-function api task_updated
create-trigger api task task_updated task_updated
```

Run the script to create all migrations at once:

```sh
ply bash create-app.sh
```
