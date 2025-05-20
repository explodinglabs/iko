# Commands

## Table of Contents

- [Sqitch Commands](#sqitch-commands)
- [Ad-hoc Migrations](#ad-hoc-migrations)
- [Comments](#comments)
- [Extensions](#extensions)
- [Functions](#functions)
- [Grants](#grants)
- [Roles](#roles)
- [Schemas](#schemas)
- [Tables](#tables)
- [Triggers](#triggers)

## Sqitch commands

Iko aliases all Sqitch commands.

You can also access `sqitch` directly, such as:

```sh
iko sqitch --version
```

[See the full list of Sqitch commands.](https://sqitch.org/docs/manual/)

## Ad-hoc migrations)

#### create

Use the `create` command to crate an ad-hoc migration. Creates empty deploy, verify and revert scripts for
you to write yourself. Use with `-e/--edit` to open your editor.

```sh
create <note>
```

The note describes the purpose of the change, is used for both the Sqitch
change note and also the change name (after some sanitisation such as replacing
spaces with underscores).

#### 🧪 Example Usage

To set a comment on the `api` schema:

```sh
create --edit 'Create customer view'
```

This is equivalent to `iko add create_customer_view --note 'Create customer view'`.

Alternatively, use `iko add create_customer_view` which launches the editor for
you to enter a note.

> 📖 See
> [sqitch-add](https://sqitch.org/docs/manual/sqitch-add/).

## Comments

> 📖 See Postgres
> [COMMENT](https://www.postgresql.org/docs/current/sql-comment.html).

### comment

Define or change the comment of an object.

```sh
comment <object> <comment>
```

The last argument is taken as the comment; everything before that is considered
the object.

#### 🧪 Example Usage

To set a comment on the `api` schema:

```sh
comment schema api 'Schema for the API endpoints'
```

## Extensions

> 📖 See Postgres [CREATE
> EXTENSION](https://www.postgresql.org/docs/current/sql-comment.html).

### create_extension

Install an extension.

```sh
create_extension <extension>
```

#### 🧪 Example Usage

To create an extension named `pgcrypto`:

```sh
create_extension pgcrypto
```

## Functions

> 📖 See Postgres [CREATE
> FUNCTION](https://www.postgresql.org/docs/current/sql-createfunction.html).

### create_function

Define a new function. Use with `--edit`.

```sh
create_function <function>
```

`<function>` can be schema-qualified.

#### 🧪 Example Usage

To create a function named `create_user`:

```sh
create_function create_user
```

### create_function_as

Define a new function inline. Useful in scripts.

```sh
create_function_as <function> <sql>
```

`<function>` can be schema-qualified.

#### 🧪 Example Usage

To define a function named `square`:

```sh
create_function_as square <<EOF
create function square(@number int) returns int as
begin
    return @number * @number;
end;
EOF
```

## Grants

> 📖 See Postgres
> [GRANT](https://www.postgresql.org/docs/current/sql-grant.html).

### grant_execute

Grants execute permission on a function to a role.

```sh
grant_execute <function> <signature> <role>
```

`<function>` can be schema-qualified.

#### 🧪 Example Usage

To grant execute permission on `login` to `dbuser`:

```sh
grant_execute login '(text,text)' dbuser
```

### grant_schema_usage

Grant schema usage to a role.

```sh
grant_schema_usage <schema> <role>
```

#### 🧪 Example Usage

To grant usage of the `api` schema to `dbuser`:

```sh
grant_schema_usage api dbuser
```

### grant_role_membership

Grant membership in a role.

```sh
grant_role_membership <role_specification> <role>
```

#### 🧪 Example Usage

To grant membership in `authenticator` to `dbuser`:

```sh
grant_role_membership authenticator dbuser
```

### grant_table_privilege

Grant privileges on a table.

```sh
grant_table_privilege <type> <table> <role>
```

`<table>` can be schema-qualified.

#### 🧪 Example Usage

To allow an `dbuser` to insert into the `asset` table:

```sh
grant_privilege insert asset dbuser
```

## Roles

> 📖 See Postgres [CREATE
> ROLE](https://www.postgresql.org/docs/current/sql-createrole.html).

### create_role

Creates a `nologin` role.

```sh
create_role <role>
```

#### 🧪 Example Usage

To create a `dbuser` role:

```sh
create_role dbuser
```

### create_login_role

Creates a login role with a password.

```sh
create_login_role <role> <password>
```

#### 🧪 Example Usage

To create a `dbuser` role with password, `securepass123`:

```sh
create_login_role dbuser 'securepass123'
```

## Schemas

> 📖 See Postgres [CREATE
> SCHEMA](https://www.postgresql.org/docs/current/sql-createschema.html).

### create_schema

Enter a new schema into the database.

```sh
create_schema <schema>
```

#### 🧪 Example Usage

To create a schema named `api`:

```sh
create_schema api
```

## Tables

> 📖 See Postgres [CREATE
> TABLE](https://www.postgresql.org/docs/current/sql-createtable.html).

### create_table

Generates a migration to create a table. Use with `--edit`.

```sh
create_table <table>
```

`<table>` can be schema-qualified.

#### 🧪 Example Usage

To create a table named `customer`:

```sh
create_table customer
```

The editor is launched for you to edit the function.

### create_table_as

Create a new table in the database, inline. Useful in scripts.

```sh
create_table_as <table> <sql>
```

`<table>` can be schema-qualified.

#### 🧪 Example Usage

To create a table named `customer`:

```sh
create_table_as customer <<EOF
create table customer (
  id bigint generated always as identity primary key,
  created_at timestamp not null default now(),
  updated_at timestamp not null default now(),
  name text not null
);
EOF
```

## Triggers

> 📖 See Postgres [CREATE
> TRIGGER](https://www.postgresql.org/docs/current/sql-createtrigger.html).

### create_trigger

Create a trigger on a table.

```sh
create_trigger <trigger> <table> <function>
```

`<table>` and `<function>` can be schema-qualified.

Note: Don't schema-qualify the `<trigger>`. From the Postgres docs:

> The name cannot be schema-qualified — the trigger inherits the schema of its
> table.

#### 🧪 Example Usage

To create a trigger named `customer_updated` that fires before updating a row
in `customer`, calling `customer_updated`:

```sh
create_trigger customer_updated customer customer_updated
```

### create_trigger_as

Create a trigger on a table, inline.

```sh
create_trigger_as <trigger> <table> <sql>
```

`<table>` can be schema-qualified.

#### 🧪 Example Usage

Create a trigger `modify` on table `contact` calling `modify_record`:

```sh
create_trigger_as modify contact <<EOF
create trigger modify
  after insert or update on contact
  for each row execute function modify_record();
EOF
```
