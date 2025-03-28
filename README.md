# Mig

_Mig_ is a **Postgres migration tool**. It extends
[Sqitch](https://sqitch.org/) with templates and aliases, combining to create a
simple DSL for easy database changes.

## Usage

Create a `mig` alias which points to your Postgres database:

```sh
alias mig="docker ghcr.io/minibasehq/mig .env -v ./migrations:/repo:rw --env SQITCH_TARGET=postgres://user:pass@localhost:5432/app"
```

## Create a migration

To make a migration which creates a new scheme named "api":

```sh
mig create-schema api
```

Three sql scripts are created – to deploy, verify and rollback the change – and
the deploy script is output to the terminal so you can see what will be
deployed.

## Deploy migrations

To deploy migrations, simply type `mig`:

```sh
mig
```

See the [full list of Mig commands](wiki).
