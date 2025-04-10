<p align="center">
  <img alt="Ply logo" height="35" src="https://github.com/explodinglabs/ply/blob/main/.images/logo-light.png?raw=true#gh-light-mode-only" />
  <img alt="Ply logo" height="35" src="https://github.com/explodinglabs/ply/blob/main/.images/logo-dark.png?raw=true#gh-dark-mode-only" />
</p>

_Ply_ is a **migration tool** for Postgres databases.

<p align="center">
  <a href="https://github.com/explodinglabs/minibase/wiki">Documentation</a> |
  <a href="https://github.com/explodinglabs/minibase/discussions">Discussions</a>
</p>

It extends [Sqitch](https://sqitch.org/), providing simple
[commands](/COMMANDS.md) for creating and performing migrations. For example,
to create an `api` schema, you'd type `ply create-schema api`.

Sqitch is available as `ply sqitch`, though some common commands are aliased
(e.g. `ply deploy` is an alias for `ply sqitch deploy`).

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
$ ply init --target postgres://user:pass@localhost:5432/app myapp
Created sqitch.conf
Created sqitch.plan
Created deploy/
Created revert/
Created verify/
```

### Create Migrations

Let's create a schema named `api` using Ply's DSL:

```sh
$ ply create-schema api
Created deploy/create_schema_api.sql
Created revert/create_schema_api.sql
Created verify/create_schema_api.sql
Added "create_schema_api" to sqitch.plan
create schema api;
```

Sqitch created three files – a deploy script, a verify script, and a revert
script. It then added the change to `sqitch.plan`. Ply then printed the deploy
script for you to review and modify as needed before deployment.

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
