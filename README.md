# Mig

_Mig_ is a **Postgres migration tool**. It extends the
[Sqitch](https://sqitch.org/) container with templates and aliases to create a
simple DSL to make database changes easy.

## Usage

Create an alias:

```sh
alias mig="docker run ghcr.io/minibasehq/mig .env -v ./migrations:/repo:rw  --env SQITCH_TARGET=postgres://user:pass@localhost:5432/app"
```

To migrate, simply type `mig`:

```sh
mig sqitch deploy
```

To create a migration:

```sh
mig sqitch add create_table_tasks --note 'Create tasks table'
```
