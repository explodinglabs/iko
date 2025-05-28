# 🛠️ Usage

## 1. Create a `.env` file

```sh
echo 'PG_URI=pg://user:pass@postgres/app' > .env
```

## 2. Initialise a project

```sh
iko init --target '$PG_URI' myapp
```

This creates a new Sqitch project in a `migrations` directory. The target is
set to an environment variable, so it stays portable across dev, CI, and
production environments.

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
