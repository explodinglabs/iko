# 🛠️ Getting Started

This guide walks you through installing Iko and creating your first migration.

📁 It's recommended to start in a new directory or fresh Git repository:

```sh
mkdir myapp && cd myapp
git init
```

This keeps your migration files organized and version-controlled.

## 1. Install Iko

> ⚠️ **Iko runs inside a container,** so you'll need [Docker
> installed](https://docs.docker.com/get-docker/).

Install the Iko CLI (for development use):

```sh
curl -fsSL https://explodinglabs.com/iko/install.sh | sh
```

Verify it's working:

```sh
iko version
```

## 2. Create a .env file

If Postgres is running inside Docker:

```
SQITCH_TARGET=db:pg://postgres:postgres@postgres/app
DOCKER_NETWORK=your_docker_network
```

If Postgres is installed on your system (e.g. Linux):

```
SQITCH_TARGET=db:pg://postgres:postgres@localhost/app
```

On Mac or WSL2, use `host.docker.internal` instead of `localhost`.

## 3. Initialise a project

```sh
iko init myapp
```

This creates a new Sqitch project in a `migrations/` directory.

## 3. Create a migration

```sh
iko create_schema api
```

```
Created deploy/create_schema_api.sql
Created revert/create_schema_api.sql
Created verify/create_schema_api.sql
Added "create_schema_api" to sqitch.plan
create schema api;
```

What happened:

- Scripts were created to deploy, revert, and verify the change.
- The change was added to sqitch.plan.
- The deploy script was output for your review.

## 4. Deploy it

```sh
iko deploy
```
