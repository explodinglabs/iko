<p align="center">
  <img alt="Pig logo" height="200" src="https://github.com/explodinglabs/ply/blob/main/images/logo-light.png?raw=true#gh-light-mode-only" />
  <img alt="Pig logo" height="200" src="https://github.com/explodinglabs/ply/blob/main/images/logo-dark.png?raw=true#gh-dark-mode-only" />
</p>

<p align="center">
  <i>Easy Postgres Migrations</i>
</p>

_Pig_ is a **migration tool** for PostgreSQL databases.

It extends [Sqitch](https://sqitch.org/), adding [shell commands](/COMMANDS.md)
to simplify creating migrations from the command-line. For example, to create
an `api` schema, you'd simpig type:

```sh
pig create_schema api
```

Combine the commands into a [script](#scripting) to generate many migrations at
once.

## Installation

Pig runs inside a Docker container, so ensure [Docker is
installed](https://docs.docker.com/get-docker/).

Create a `pig` command by pasting this into your terminal:

```sh
pig() { docker run --rm -v ${PWD}/migrations:/repo:rw ghcr.io/explodinglabs/pig bash -c '"$@"' -- "$@" }
```

💡 Add it to your shell startup file for persistence (e.g., `.bashrc`,
`.zshrc`).

## Usage

### Initialise a Project

Run the following command to initialize a project (ensure the correct database
URI is set):

```sh
pig init --target postgres://user:pass@localhost:5432/app myapp
```

> 📖 Refer to the [Sqitch manual for
> init](https://sqitch.org/docs/manual/sqitch-init/).

### Create Migrations

Let's create a schema named `api`:

```sh
pig create_schema api
```

```
Created deploy/create_schema_api.sql
Created revert/create_schema_api.sql
Created verify/create_schema_api.sql
Added "create_schema_api" to sqitch.plan
create schema api;
```

Sqitch created three files – a deploy script, a revert script and a verify
script. It then added the change to `sqitch.plan`. Lastly, it printed the
deploy script for you to review.

> 📖 See the [full list of Pig commands](/COMMANDS.md).

### Deploy Migrations

Make sure Postgres is running, then type:

```sh
pig deploy
```

> 📖 Refer to the [Sqitch manual for
> deploy](https://sqitch.org/docs/manual/sqitch-deploy/).

## Scripting

Write reusable scripts that generate migrations, for example:

**migrations/auth.sh**

```sh
# Create an auth schema
create_schema auth

# Create an auth.user table
create_table_as auth.user <<EOF
create table auth.user (
  username text primary key check (length(username) >= 3),
  password text not null check (length(password) < 512),
  role name not null check (length(role) < 512)
);
EOF

# Create a function that encrypts passwords
create_function_as auth.encrypt_pass <<EOF
create function auth.encrypt_pass () returns trigger language plpgsql as $$
begin
  if tg_op = 'INSERT' or new.password <> old.password then
    new.password = crypt(new.password, gen_salt('bf'));
  end if;
  return new;
end; $$
EOF

# Call encrypt_pass when a user is inserted or updated
create_trigger encrypt_pass auth.user auth.encrypt_pass
```

Place it in `migrations/auth.sh` then run:

```sh
pig bash auth.sh
```
