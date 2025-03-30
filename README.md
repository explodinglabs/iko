<p align="center">
  <img alt="Ply logo" height="100" src="https://github.com/minibasehq/ply/blob/main/.images/logo.png?raw=true" />
</p>

_Ply_ is a **Postgres database migration tool**, extending
[Sqitch](https://sqitch.org/) with a DSL to make common database changes easy.

## Installation

Ply runs inside a Docker container. Ensure you have
[Docker](https://docs.docker.com/get-docker/) installed before proceeding.

To create a `ply` command, paste this into your terminal:

```sh
ply() { docker run --rm -v ${PWD}/migrations:/repo:rw ghcr.io/minibasehq/ply bash -c "$*" }
```

> 💡Tip: Add this alias to your `~/.bashrc` or `~/.zshrc` for persistence.

Initialise Sqitch, configuring your database connection URI:

```sh
ply sqitch init --target postgres://user:pass@localhost:5432/app myapp
```

## Usage

Let's make a new schema named "api":

```sh
ply create-schema api
```

Sqitch creates three SQL files – one to deploy, one to verify and and one to
revert the change. The deploy script is output so you can see the change that
will be deployed, and decide if you need to make changes to it.

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
