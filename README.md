<p align="center">
  <img alt="Iko logo" height="150" src="https://github.com/explodinglabs/iko/blob/main/images/logo-light.png?raw=true#gh-light-mode-only" />
  <img alt="Iko logo" height="150" src="https://github.com/explodinglabs/iko/blob/main/images/logo-dark.png?raw=true#gh-dark-mode-only" />
</p>

<h1 align="center">
  ikō
</h1>

_Iko_ is a database **schema migration tool**. Currently only PostgreSQL and
compatible databases are supported.

It extends [Sqitch](https://sqitch.org/), adding [shell commands](/COMMANDS.md)
to simplify creating common migrations from the command-line.

Combine the commands into [scripts](#scripting) to generate many migrations at
once.

## Installation

Iko runs inside a Docker container, so ensure [Docker is
installed](https://docs.docker.com/get-docker/).

To install the `iko` command, run:

```sh
curl -fsSL https://explodinglabs.com/iko/install.sh | sh
```

This creates a simple executable script at `~/.local/bin/iko`.

Test it's working:

```sh
$ iko check
No project configuration found. Run the "init" command to initialize a project
```

## Usage

### Initialise a Project

Run the following command to initialize a project -- ensuring the correct
database URI is set.

```sh
iko init myapp
```

> 📖 Refer to the [Sqitch manual for
> init](https://sqitch.org/docs/manual/sqitch-init/).

### Set a target database

Set the default target database:

```sh
iko config --local deploy.target db:pg://user@localhost/dbname
```

Keep in mind Iko is running inside a container so it uses Docker's networking.
`localhost` doesn't refer to the host machine.

> 📖 Refer to [Sqitch
> tutorial](https://sqitch.org/docs/manual/sqitchtutorial/).

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

Three scripts were created – to _deploy_, _revert_ and _verify_ the change. The
change was then added to `sqitch.plan`. Lastly, the deploy script was printed
for you to review.

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

**scripts/auth.sh**

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

Place it in `scripts/auth.sh` then run:

```sh
iko bash auth.sh
```

Next: See [Iko's full command set](COMMANDS.md).
