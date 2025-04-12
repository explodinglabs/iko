<p align="center">
  <img alt="Ply logo" height="35" src="https://github.com/explodinglabs/ply/blob/main/.images/logo-light.png?raw=true#gh-light-mode-only" />
  <img alt="Ply logo" height="35" src="https://github.com/explodinglabs/ply/blob/main/.images/logo-dark.png?raw=true#gh-dark-mode-only" />
</p>

<p align="center">
  <a href="https://github.com/explodinglabs/ply/wiki">Documentation</a> |
  <a href="https://github.com/explodinglabs/ply/discussions">Discussions</a>
</p>

_Ply_ is a **migration tool** for PostgreSQL databases, that allows you to quickly create common migrations from the command line, or in a script. 

It extends [Sqitch](https://sqitch.org/), adding [commands](/COMMANDS.md) to
simplify creating and performing migrations. For example, to create an `api`
schema, you'd type `ply create_schema api`.

Combine the commands into a [script](#scripting) to generate many migrations at once.

## Installation

Ply runs inside a Docker container, so ensure [Docker is
installed](https://docs.docker.com/get-docker/).

Create a `ply` command by pasting this into your terminal:

```sh
ply() { docker run --rm -v ${PWD}/migrations:/repo:rw ghcr.io/explodinglabs/ply bash -c '"$@"' -- "$@" }
```

💡 Add it to your `~/.bashrc` or `~/.zshrc` for persistence.

## Usage

### Initialise a Project

Run the following command to initialise a project, ensuring the correct
database connection URI is set.

```sh
$ ply init --target postgres://user:pass@localhost:5432/app myapp
Created sqitch.conf
Created sqitch.plan
Created deploy/
Created revert/
Created verify/
```

> 📖 Refer to the [Sqitch manual for
> init](https://sqitch.org/docs/manual/sqitch-init/).

### Create Migrations

Let's create a schema named `api`:

```sh
$ ply create_schema api
Created deploy/create_schema_api.sql
Created revert/create_schema_api.sql
Created verify/create_schema_api.sql
Added "create_schema_api" to sqitch.plan
create schema api;
```

Sqitch created three files – a deploy script, a revert script and a verify
script. It then added the change to `sqitch.plan`. Ply then printed the deploy
script for you to review.

> 📖 See the [full list of Ply commands](/COMMANDS.md).

### Deploy Migrations

```sh
ply deploy
```

> 📖 Refer to the [Sqitch manual for
> deploy](https://sqitch.org/docs/manual/sqitch-deploy/).

## Scripting

Write reusable scripts that generate migrations, like:

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

Place it in `migrations/create.sh` then run:

```sh
ply bash create.sh
```
