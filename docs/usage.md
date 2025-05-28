# 🛠️ Usage

## 1. Initialise a project

```sh
iko init myapp
```

This creates a new Sqitch project in a `migrations` directory. The target is
set to an environment variable, so it stays portable across dev, CI, and
production environments.

## 2. Create a `.env` file

Set your database connection URI and (if needed) Docker network settings.

### If Postgres is running inside Docker:

```sh
echo 'SQITCH_TARGET=db:pg://postgres:postgres@postgres/app' > .env
echo 'DOCKER_NETWORK=explodinglabs' >> .env
```

> ✅ Replace postgres with your Docker Compose service name or container name.
> ✅ Replace explodinglabs with your Docker network name (you can find it with
> docker network ls).

### If Postgres is installed directly on your system (e.g. Linux):

```sh
echo 'SQITCH_TARGET=db:pg://postgres:postgres@localhost/app' > .env
```

> ✅ localhost refers to your host system from inside the container (only works
> on native Linux).
> ⚠️ On Mac or WSL2, use host.docker.internal instead of localhost.

> ⚠️ **Important:** Do not create the `.env` file or set `SQITCH_TARGET` until _after_ you run:
>
> ```sh
> iko init myapp
> ```
>
> If `SQITCH_TARGET` is set too early, `iko init` may fail with a message like:
>
> ```
> Missing required arguments: name
> ```
>
> You can safely add `.env` and `SQITCH_TARGET` after initialization is complete.

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
