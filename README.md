<p align="center">
  <img alt="Ply logo" height="35" src="https://github.com/explodinglabs/ply/blob/main/.images/logo-light.png?raw=true#gh-light-mode-only" />
  <img alt="Ply logo" height="35" src="https://github.com/explodinglabs/ply/blob/main/.images/logo-dark.png?raw=true#gh-dark-mode-only" />
</p>

_Ply_ simplifies migrations on Postgres databases.

It extends [Sqitch](https://sqitch.org/) providing simple
[commands](/COMMANDS.md) for creating and performing migrations.

For example, `ply create-schema api` generates a migration to create an `api`
schema.

## Installation

Ply runs inside a Docker container, so ensure [Docker is
installed](https://docs.docker.com/get-docker/).

Create a `ply` command by pasting this into your terminal:

```sh
ply() { docker run --rm -v ${PWD}/migrations:/repo:rw ghcr.io/explodinglabs/ply" bash -c '"$@"' -- "$@" }
```

💡 Add it to your `~/.bashrc` or `~/.zshrc` for persistence.

## Usage

### Initialize a Sqitch project

Run the following command to [initialize a Sqitch
project](https://sqitch.org/docs/manual/sqitch-init/), ensuring the correct
database connection URI is set:

```sh
ply init --target postgres://user:pass@localhost:5432/app myapp
```

### Create Migrations

Let's create a schema named `api` using Ply's DSL:

```sh
ply create-schema api
```

Sqitch creates three files –

- `deploy/create_schema_api.sql` to deploy the change,
- `verify/create_schema_api.sql` to verify the change, and
- `revert/create_schema_api.sql` to revert the change.

The deploy script is outputted for you to review and modify as needed before
deployment.

> 📖 See the [full list of migration commands](/COMMANDS.md).

### Deploy Migrations

Use Sqitch to deploy the change:

```sh
ply deploy
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
