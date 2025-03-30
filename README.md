<p align="center">
  <img alt="Ply logo" height="100" src="https://github.com/minibasehq/ply/blob/main/.images/logo.png?raw=true" />
</p>

# Ply

_Ply_ is a **Postgres database migration tool**, extending
[Sqitch](https://sqitch.org/) with a DSL to make common database changes easy.

## Installation

Ply runs inside a Docker container, so ensure you have [Docker
installed](https://docs.docker.com/get-docker/) before proceeding.

Create a `ply` command by pasting this into your terminal:

```sh
ply() { docker run --rm -v ${PWD}/migrations:/repo:rw ghcr.io/minibasehq/ply" bash -c "$*" }
```

Add it to your `~/.bashrc` or `~/.zshrc` for persistence.

## Usage

### Initialize a Sqitch project

Run the following command to initialize a Sqitch project:

```sh
ply sqitch init --target postgres://user:pass@localhost:5432/app myapp
```

### Create a Migration

Create a schema named `api` using Ply's DSL:

```sh
ply create-schema api
```

| 📖 See the [full list of migration commands](wiki).

Sqitch creates three SQL files – to deploy, verify and revert the change. The
deploy script is output so you can see the change that will be deployed, and
decide if you need to make changes to it.

### Deploy Migrations

Use Sqitch to deploy changes:

```sh
ply sqitch deploy
```

## Bulk migration scripts

You can write a script to define multiple migrations at once.

### Example: Creating an Application Schema

Create a `migrations/create-app.sh`:

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

Run the script to create all migrations at once:

```sh
ply bash create-app.sh
```
