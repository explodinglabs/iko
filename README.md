<p align="center">
  <img alt="Iko logo" height="150" src="https://github.com/explodinglabs/iko/blob/main/images/logo-light.png?raw=true#gh-light-mode-only" />
  <img alt="Iko logo" height="150" src="https://github.com/explodinglabs/iko/blob/main/images/logo-dark.png?raw=true#gh-dark-mode-only" />
</p>

<h1 align="center">
  ikō
</h1>

**Iko** (_ee-koh_) is a tool for managing Postgres database migrations using
the command-line.

Iko favors:

- **Clarity over magic** — see exactly what your database is doing.
- **Unix-style composition** — use the shell to script and automate.
- **Convention over configuration** — just follow the file layout and naming pattern.

## Installation

Iko runs inside a container, so you'll need to have [Docker
installed](https://docs.docker.com/get-docker/).

Install `iko`:

```sh
curl -fsSL https://explodinglabs.com/iko/install.sh | sh
```

Confirm it's working:

```sh
iko version
```

## Quick Example

### Initialise a Project

Initialize a project, setting a target database:

```sh
iko init --target db:pg://user:pass@postgres/dbname myapp
```

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

Three scripts were created: to _deploy_, _revert_, and _verify_ the change. The
change was added to `sqitch.plan`. Then the deploy script was printed for your
review.

### Deploy

Make sure the database server is running, then type:

```sh
iko deploy
```

> 📖 Refer to [Sqitch
> deploy](https://sqitch.org/docs/manual/sqitch-deploy/).

## Scripting

Write reusable scripts that generate migrations, for example:

<details>
  <summary><b>scripts/auth.sh</b> – <a>Click to expand</a></summary>

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
