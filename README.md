<p align="center">
  <img alt="Iko logo" height="150" src="https://github.com/explodinglabs/iko/blob/main/images/logo-light.png?raw=true#gh-light-mode-only" />
  <img alt="Iko logo" height="150" src="https://github.com/explodinglabs/iko/blob/main/images/logo-dark.png?raw=true#gh-dark-mode-only" />
</p>

<h1 align="center">
  ikō
</h1>

**Iko** (_ee-koh_) is a lightweight command-line tool for managing **Postgres
database migrations using the command-line**.

It wraps [Sqitch](https://sqitch.org/) with a developer-friendly DSL and simple
scripting.

## ❤️ Why Iko?

- Batteries-included: deploy, revert, verify
- Works inside a container — zero local deps
- Reliable, clean migrations for teams
- Powerful scripting model with Bash

## 🚀 Installation

> ⚠ **Iko runs inside a container,** so you'll need [Docker
> installed](https://docs.docker.com/get-docker/).

Install with:

```sh
curl -fsSL https://explodinglabs.com/iko/install.sh | sh
```

Verify it's working:

```sh
iko version
```

## 🛠️ Quick Example

### 1. Initialise a project

```sh
iko init --target db:pg://user:pass@postgres/dbname myapp
```

This creates a new project with a `sqitch.plan`, ready for migrations.

### 2. Create a migration

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

### 3. Deploy it

Make sure your database is running, then:

```sh
iko deploy
```

## ✨ Scripting Migrations

Write reusable Bash scripts to define database changes:

<details>
  <summary><strong>scripts/auth.sh</strong> – <em>Click to expand</em></summary>

```sh
# Create an auth schema
create_schema auth

# Create a user table
create_table_as auth.user <<'EOF'
create table auth.user (
  username text primary key check (length(username) >= 3),
  password text not null check (length(password) < 512),
  role name not null check (length(role) < 512)
);
EOF

# Add a function to hash passwords
create_function_as auth.encrypt_pass <<'EOF'
create function auth.encrypt_pass () returns trigger language plpgsql as $$
begin
  if tg_op = 'INSERT' or new.password <> old.password then
    new.password = crypt(new.password, gen_salt('bf'));
  end if;
  return new;
end; $$
EOF

# Trigger it on insert/update
create_trigger encrypt_pass auth.user auth.encrypt_pass
```

</details>

Run the script:

```sh
iko bash auth.sh
```

## ➡️ Next Steps

- Learn the [DSL commands](COMMANDS.md)
