# Ply

_Ply_ is a **Postgres database migration tool**. It extends
[Sqitch](https://sqitch.org/) adding templates and functions to make performing
common database changes easier.

## Usage

Create a `ply` function (be sure to set the correct database connection URI):

```sh
ply() { docker run --rm --volume ${PWD}/migrations:/repo:rw ghcr.io/minibasehq/ply "$@" }
```

Initialise Sqitch:

```sh
ply sqitch init --target postgres://user:pass@localhost:5432/app
```

### Create migrations

Let's make a new schema named "api" (see the [full list of migration
commands](wiki)):

```sh
ply create-schema api
```

Three SQL scripts are created – to deploy, verify and rollback the change. The
deploy script is output so you can see the change that will occur.

### Deploy migrations

To deploy migrations, simply type `mig sqitch deploy`:

```sh
mig sqitch deploy
```
