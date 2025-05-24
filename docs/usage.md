# 🛠️ Usage

## 1. Initialise a project

```sh
iko init --target db:pg://user:pass@postgres/dbname myapp
```

This creates a new project with a `sqitch.plan`, ready for migrations.

## 2. Create a migration

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

## 3. Deploy it

Make sure your database is running, then:

```sh
iko deploy
```
