<p align="center">
  <img alt="Iko logo" height="150" src="https://github.com/explodinglabs/iko/blob/main/images/logo-light.png?raw=true#gh-light-mode-only" />
  <img alt="Iko logo" height="150" src="https://github.com/explodinglabs/iko/blob/main/images/logo-dark.png?raw=true#gh-dark-mode-only" />
</p>

<h1 align="center">
  ikō
</h1>

**Iko** (_ee-koh_) is a Postgres database **schema migration tool**.

It extends [Sqitch](https://sqitch.org/), adding a set of [shell
commands](/COMMANDS.md) that make it easier to create and manage migrations
from the command-line.

You can also [combine commands into scripts](#scripting) to generate multiple
migrations at once — useful for initializing schemas or evolving complex
systems.

## Installation

Iko runs inside a container, so you'll need to have [Docker
installed](https://docs.docker.com/get-docker/).

Install the `iko` command-line tool:

```sh
curl -fsSL https://explodinglabs.com/iko/install.sh | sh
```

Confirm it's working:

```sh
iko version
```

## Usage

### Initialise a Project

Run the following command to initialize a project, setting a default target
database (typically this is your local development server):

```sh
iko init --target db:pg://user:pass@postgres/dbname myapp
```

Keep in mind Iko is running inside a container, so it uses [Docker's
networking](https://docs.docker.com/engine/network/). `localhost` refers to the
container, not the host machine!

> 📖 Refer to the [Sqitch manual for
> init](https://sqitch.org/docs/manual/sqitch-init/).

### Create Migrations

Let's create a schema named `api`:

```sh
$ iko create_schema api
Created deploy/create_schema_api.sql
Created revert/create_schema_api.sql
Created verify/create_schema_api.sql
Added "create_schema_api" to sqitch.plan
create schema api;
```

Here's what happened:

1. Three scripts were created: to _deploy_, _revert_, and _verify_ the change.
2. The change was added to `sqitch.plan`.
3. Finally, the deploy script was printed for your review.

> 📖 See the [full list of Iko commands](/COMMANDS.md).

### Deploy

Make sure the database server is running, then type:

```sh
iko deploy
```

> 📖 Refer to the [Sqitch manual for
> deploy](https://sqitch.org/docs/manual/sqitch-deploy/).

## Scripting

Write reusable scripts that generate migrations, for example:

<details>
  <summary><b>scripts/auth.sh</b> – Click to expand</summary>

```sh
# Create an auth schema
create_schema auth

# Create an auth.user table
create_table_as auth.user <<'EOF'
create table auth.user (
  username text primary key check (length(username) >= 3),
  password text not null check (length(password) < 512),
  role name not null check (length(role) < 512)
);
EOF

# Create a function that encrypts passwords
create_function_as auth.encrypt_pass <<'EOF'
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

</details>

Run it to generate migrations:

```sh
iko bash auth.sh
```

Next: [Iko's Commands](COMMANDS.md).
