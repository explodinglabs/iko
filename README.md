<p align="center">
  <img alt="Ply logo" height="35" src="https://github.com/explodinglabs/ply/blob/main/.images/logo-light.png?raw=true#gh-light-mode-only" />
  <img alt="Ply logo" height="35" src="https://github.com/explodinglabs/ply/blob/main/.images/logo-dark.png?raw=true#gh-dark-mode-only" />
</p>

<p align="center">
  <a href="https://github.com/explodinglabs/ply/wiki">Documentation</a> |
  <a href="https://github.com/explodinglabs/ply/discussions">Discussions</a>
</p>

_Ply_ is a **migration tool** for PostgreSQL databases.

It extends [Sqitch](https://sqitch.org/), adding [commands](/COMMANDS.md) to
simplify creating and performing migrations. For example, to create an `api`
schema, you'd type `ply create-schema api`.

Combine the commands into a [script](#scripting) to define many migrations, or
an entire database structure, in one place.

## Installation

Ply runs inside a Docker container, so ensure [Docker is
installed](https://docs.docker.com/get-docker/).

Create a `ply` command by pasting this into your terminal:

```sh
ply() { docker run --rm -v ${PWD}/migrations:/repo:rw ghcr.io/explodinglabs/ply bash -c '"$@"' -- "$@" }
```

💡 Add it to your `~/.bashrc` or `~/.zshrc` for persistence.

## Usage

### Initialise a project

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

> 📖 See [Sqitch init](https://sqitch.org/docs/manual/sqitch-init/).

### Create Migrations

Let's create a schema named `api`:

```sh
$ ply create-schema api
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

> 📖 Refer to the [Sqitch Manual](https://sqitch.org/docs/manual/).

## Scripting

Write scripts that generate multiple migrations at once.

Here's an example script:

```sh
# migrations/create.sh

create-schema auth
create-table-as auth user <<EOF
create table auth.user (
  username text primary key check (length(username) >= 3),
  password text not null check (length(password) < 512),
  role name not null check (length(role) < 512)
);
EOF
create-function-as auth encrypt_pass <<EOF
create function auth.encrypt_pass () returns trigger language plpgsql as $$
begin
  if tg_op = 'INSERT' or new.password <> old.password then
    new.password = crypt(new.password, gen_salt('bf'));
  end if;
  return new;
end; $$
EOF
create trigger encrypt_pass
  before insert or update on auth.user for each row
  execute procedure auth.encrypt_pass ();
```

Run the script to create all migrations at once:

```sh
ply bash create.sh
```
