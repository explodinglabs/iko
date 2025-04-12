# Commands

## Sqitch aliases

Ply provides aliases for the following Sqitch commands:

- add
- deploy
- init
- revert
- verify

For example, to create an ad-hoc migration not listed below, use:

```sh
ply add create_view -n 'Create a view'
```

Then to deploy, `ply deploy`.

Other commands are below.

- [General](#general)
- [Comments](#comments)
- [Extensions](#extensions)
- [Functions](#functions)
- [Grants](#grants)
- [Roles](#roles)
- [Schemas](#schemas)
- [Tables](#tables)
- [Triggers](#triggers)

## Comments

> 📖 PostgreSQL documentation for
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

Generates the following deploy script:

```sql
comment on schema api is 'Schema for the API endpoints';
```

## Extensions

> 📖 PostgreSQL documentation for
> [CREATE EXTENSION](https://www.postgresql.org/docs/current/sql-comment.html).

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

Generates the following deploy script:

```sql
create extension "pgcrypto";
```

## Functions

> 📖 PostgreSQL [CREATE
> FUNCTION](https://www.postgresql.org/docs/current/sql-createfunction.html).

### create_function

Define a new function.

```sh
create_function <function>
```

#### 🧪 Example Usage

To create a function named `create_user`:

```sh
create_function create_user
```

Generates the following deploy script:

```sql
create or replace function public.create_user () returns void language plpgsql as
begin
  return;
end;
```

The editor is launched for you to edit the function.

### create_function_as

Define a new function inline (useful in scripts).

```sh
create_function_as <function> <sql>
```

#### 🧪 Example Usage

To define a function named `square`:

```sh
create_function_as square <<EOF
create function public.square(@number int) returns int as
begin
    return @number * @number;
end;
EOF
```

## Grants

> 📖 PostgreSQL documentation for
> [GRANT](https://www.postgresql.org/docs/current/sql-grant.html).

### grant_execute

Grants execute permission on a function to a role.

```sh
grant_execute <function> <signature> <role>
```

#### 🧪 Example Usage

To grant execute permission on `login` to `dbuser`:

```sh
grant_execute login '(text,text)' dbuser
```

Generates the following deploy script:

```sql
grant execute on function public.login (text,text) to dbuser;
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

Generates the following deploy script:

```sql
grant usage on schema api to dbuser;
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

Generates the following deploy script:

```sql
grant authenticator to dbuser;
```

### grant_table_privilege

Grant privileges on a table.

```sh
grant_table_privilege <type> <table> <role>
```

#### 🧪 Example Usage

To allow an `dbuser` to insert into the `asset` table:

```sh
grant_privilege insert asset dbuser
```

Generates the following deploy script:

```sql
grant select on public.asset to dbuser;
```

## Roles

> 📖 PostgreSQL [CREATE
> ROLE](https://www.postgresql.org/docs/current/sql-createrole.html).

### create-role

Creates a `nologin` role.

```sh
create_role <role>
```

#### 🧪 Example Usage

To create a `dbuser` role:

```sh
create_role dbuser
```

Generates the following deploy script:

```sql
begin $$
   if exists (
     select from pg_catalog.pg_roles
     where rolname = 'dbuser'
   ) then
      raise notice 'Role already exists, skipping.';
   else
      create role dbuser nologin;
   end if;
end; $$
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

Generates the following deploy script:

```sql
begin $$
   if exists (
     select from pg_catalog.pg_roles
     where rolname = 'dbuser'
   ) then
      raise notice 'Role already exists, skipping.';
   else
      create role dbuser noinherit login password 'securepass123';
   end if;
end; $$
```

## Schemas

> 📖 PostgreSQL [CREATE
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

Generates the following deploy script:

```sql
create schema api;
```

## Tables

> 📖 PostgreSQL [CREATE
> TABLE](https://www.postgresql.org/docs/current/sql-createtable.html).

### create_table

Generates a migration to create a table, and launches the editor.

```sh
create_table <table>
```

#### 🧪 Example Usage

To create a table named `customer`:

```sh
create_table customer
```

Generates the following deploy script:

```sql
create table public.customer (
  id bigint generated always as identity primary key,
  created_at timestamp not null default now(),
  updated_at timestamp not null default now(),
  name text not null
);
```

The editor is launched for you to edit the function.

### create_table_as

Create a new table in the database, inline.
This is useful for bulk migration scripts.

```sh
create_table_as <table> <sql>
```

#### 🧪 Example Usage

To create a table named `customer`:

```sh
create_table_as customer <<EOF
create table public.customer (
  id bigint generated always as identity primary key,
  created_at timestamp not null default now(),
  updated_at timestamp not null default now(),
  name text not null
);
EOF
```

## Triggers

> 📖 PostgreSQL [CREATE
> TRIGGER](https://www.postgresql.org/docs/current/sql-createtrigger.html).

### create_trigger

Create a trigger on a table.

```sh
create_trigger <trigger> <table> <function>
```

#### 🧪 Example Usage

To create a trigger named `customer_updated` that fires before updating a row
in `customer`, calling `customer_updated`:

### create_trigger_as

```sh
create_trigger_as customer_updated before insert or update user customer_updated
```

#### 🧪 Example Usage

Generates the following deploy script:

```sql
create trigger customer_updated
  before update on public.customer
  for each row execute function customer_updated();
```
