<p align="center">
  <img alt="Ply logo" height="35" src="https://github.com/explodinglabs/ply/blob/main/.images/logo-light.png?raw=true#gh-light-mode-only" />
  <img alt="Ply logo" height="35" src="https://github.com/explodinglabs/ply/blob/main/.images/logo-dark.png?raw=true#gh-dark-mode-only" />
</p>

<p align="center">
  <a href="https://github.com/explodinglabs/ply/wiki">Documentation</a> |
  <a href="https://github.com/explodinglabs/ply/discussions">Discussions</a>
</p>

_Ply_ is a **migration tool** for PostgreSQL databases.

It extends [Sqitch](https://sqitch.org/), adding [commands](/COMMANDS.md) to
simplify creating and performing migrations. For example, to create an `api`
schema, you'd type `ply create-schema api`.

Combine the commands into a [script](#scripting) to define many migrations, or
an entire database structure, in one place.

## Installation

Ply runs inside a Docker container, so ensure [Docker is
installed](https://docs.docker.com/get-docker/).

Create a `ply` command by pasting this into your terminal:

```sh
ply() { docker run --rm -v ${PWD}/migrations:/repo:rw ghcr.io/explodinglabs/ply" bash -c '"$@"' -- "$@" }
```

💡 Add it to your `~/.bashrc` or `~/.zshrc` for persistence.

## Usage

### Initialise a project

Run the following command to initialise a project, ensuring the correct
database connection URI is set.

```sh
$ ply init --target postgres://user:pass@localhost:5432/app myapp
Created sqitch.conf
Created sqitch.plan
Created deploy/
Created revert/
Created verify/
```

> 📖 See [Sqitch init](https://sqitch.org/docs/manual/sqitch-init/).

### Create Migrations

Let's create a schema named `api`:

```sh
$ ply create-schema api
Created deploy/create_schema_api.sql
Created revert/create_schema_api.sql
Created verify/create_schema_api.sql
Added "create_schema_api" to sqitch.plan
create schema api;
```

Sqitch created three files – a deploy script, a revert script and a verify
script. It then added the change to `sqitch.plan`. Ply then printed the deploy
script for you to review.

> 📖 See the [full list of Ply commands](/COMMANDS.md).

### Deploy Migrations

```sh
ply deploy
```

> 📖 Refer to the [Sqitch Manual](https://sqitch.org/docs/manual/).

## Scripting

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
