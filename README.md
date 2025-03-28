# Mig

_Mig_ is a **Postgres migration tool** with a simple DSL to make database
changes simple. It extends the [Sqitch](https://sqitch.org/) container with
some templates and aliases.

## Installation

In a repository, create a `.env` file to set the Postgres target:

```sh
echo 'SQITCH_TARGET=postgres://user:pass@localhost:5432/app' >> .env
```

Create an alias:

```sh
alias mig="docker run ghcr.io/minibasehq/mig --env-file .env -v ./migrations:/repo:rw"
```

## Usage

To migrate, simply type `mig`:

```sh
mig sqitch deploy
```

To create a migration:

```sh
mig sqitch add create_table_tasks --note 'Create tasks table'
```
