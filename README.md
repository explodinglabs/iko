<p align="center">
  <img alt="Ply logo" height="100" src="https://github.com/minibasehq/ply/blob/main/.images/logo.png?raw=true" />
</p>

_Ply_ is a **Postgres migration tool** that make database changes easy.

## Overview

Ply extends the [Sqitch](https://sqitch.org/) Docker image, adding templates
and commands to make creating common migrations simple. For example, to create
a table named `task` in the `api` schema, you'd type `ply create-table api task`.

All Sqitch commands are also available, such as `ply sqitch deploy`.

## Installation

Ply runs inside a Docker container, so ensure you have [Docker
installed](https://docs.docker.com/get-docker/).

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

Sqitch creates three SQL files – to deploy, verify and revert the change. The
deploy script is output, so you can see the change that will be deployed.

> 📖 See the [full list of migration commands](wiki).

### Deploy Migrations

Use Sqitch to deploy changes:

```sh
ply sqitch deploy
```

## Bulk Migration Scripts

You can write a script to define multiple migrations at once.

For example, create file named `migrations/create-app.sh`:

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

Using scripts lets you define large change sets, or an entire application, at a
high level.
