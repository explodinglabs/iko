# 🛠️ Usage

> 🧪 This covers **local development**.
>
> For production or CI/CD usage, see [Deploying to Remote
> Environments](./deploying.md).

## 1. Initialise a project

```sh
iko init myapp
```

This creates a new Sqitch project in a `migrations` directory.

## 2. Create a .env file

Create a `.env` file with the appropriate settings based on your Postgres setup:

### If Postgres is running inside Docker:

```sh
echo 'SQITCH_TARGET=db:pg://postgres:postgres@<your_service_name>/app' > .env
echo 'DOCKER_NETWORK=<your_docker_network>' >> .env
```

### If Postgres is installed directly on your system:

```sh
echo 'SQITCH_TARGET=db:pg://postgres:postgres@localhost/app' > .env
```

On Mac or WSL2, use `host.docker.internal` instead of `localhost`.

> ⚠️ Don't set `SQITCH_TARGET` before running `iko init`, or you'll get an error
> like "Missing required arguments: name".

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

Ensure your Postgres server is running, then:

```sh
iko deploy
```
