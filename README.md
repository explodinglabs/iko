# Mig

_Mig_ is a **Postgres migration tool**. It extends
[Sqitch](https://sqitch.org/) with templates and aliases to create a simple DSL
for easy database changes.

## Usage

Create a `mig` alias (be sure to set the correct database connection URI):

```sh
alias mig="docker run --rm ghcr.io/minibasehq/mig -v ./migrations:/repo:rw --env SQITCH_TARGET=postgres://user:pass@localhost:5432/app"
```

### Create migrations

Let's make a new schema named "api" (see the [full list of migration
commands](wiki)):

```sh
mig create-schema api
```

Three SQL scripts are created – to deploy, verify and rollback the change. The
deploy script is output to the terminal so you can see the change that will
occur.

### Deploy migrations

To deploy migrations, simply type `mig` (or `mig sqitch deploy`):

```sh
mig
```
