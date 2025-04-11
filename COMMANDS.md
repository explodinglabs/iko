# Commands

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

### comment

Define or change the comment of an object.

### Usage

```sh
comment <object> <comment>
```

Parameters:

- **object:** The database object to add a comment to. Can be schema-qualified.
- **comment:** The comment to apply.

The last argument is taken as the comment; everything before that is considered
the object.

### Example

```sh
comment schema api 'Schema for the API endpoints'
```

Generates the following deploy script:

```sql
comment on schema api is 'Schema for the API endpoints';
```

## Extensions

### create-extension

Install an extension.

```sh
create-extension <extension>
```

For example, to create an extension named `pgcrypto`:

```sh
create-extension pgcrypto
```

Generates the following deploy script:

```sql
create extension "pgcrypto";
```

## Functions

### create-function

Define a new function.

```sh
create-function <function>
```

For example, to create a function named `create_user`:

```sh
create-function create_user
```

Generates the following deploy script:

```sql
create or replace function public.create_user () returns void language plpgsql as
begin
  return;
end;
```

The editor is launched for you to edit the function.

### create-function-as

Define a new function inline (useful in scripts).

```sh
create-function-as <function> <sql>
```

For example, to define a function named `square`:

```sh
create-function-as square <<EOF
create function public.square(@number int) returns int as
begin
    return @number * @number;
end;
EOF
```

## Grants

### grant-execute

Grants execute permission on a function to a role.

```sh
grant-execute <function> <signature> <role>
```

For example, to grant execute permission on `login` to `dbuser`:

```sh
grant-execute login '(text,text)' dbuser
```

Generates the following deploy script:

```sql
grant execute on function login (text,text) to dbuser;
```

### grant-schema-usage

Grant schema usage to a role.

```sh
grant-schema-usage <schema> <role>
```

For example, to grant usage of the `api` schema to `dbuser`:

```sh
grant-schema-usage api dbuser
```

Generates the following deploy script:

```sql
grant usage on schema api to dbuser;
```

### grant-role-membership

Grant membership in a role.

```sh
grant-role-membership <role_specification> <role>
```

For example, to grant membership in `authenticator` to `dbuser`:

```sh
grant-role-membership authenticator dbuser
```

Generates the following deploy script:

```sql
grant authenticator to dbuser;
```

### grant-privilege

Grant privileges on a database object.

```sh
grant-privilege <privilege> <object> <role>
```

For example, to allow an `dbuser` to insert into the `asset` table:

```sh
grant-privilege insert asset dbuser
```

Generates the following deploy script:

```sql
grant select on public.asset to dbuser;
```

## Roles

### create-role

Creates a `nologin` role.

```sh
create-role <role>
```

For example, to create a `dbuser` role:

```sh
create-role dbuser
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

### create-login-role

Creates a login role with a password.

```sh
create-login-role <role> <password>
```

For example, to create a `dbuser` role with password, `securepass123`:

```sh
create-login-role dbuser 'securepass123'
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

### create-schema

Enter a new schema into the database.

```sh
create-schema <schema>
```

For example, to create a schema named `api`:

```sh
create-schema api
```

Generates the following deploy script:

```sql
create schema api;
```

## Tables

### create-table

Generates a migration to create a table, and launches the editor.

```sh
create-table <table>
```

For example, to create a table named `customer`:

```sh
create-table customer
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

### create-table-as

Create a new table in the database, inline.
This is useful for bulk migration scripts.

```sh
create-table-as <table> <sql>
```

For example, to create a table named `customer`:

```sh
create-table-as customer <<EOF
create table public.customer (
  id bigint generated always as identity primary key,
  created_at timestamp not null default now(),
  updated_at timestamp not null default now(),
  name text not null
);
EOF
```

## Triggers

### create-trigger

Create a on a table.

```sh
create-trigger <trigger> <when> <table> <function>
```

For example, to create a trigger named `customer_updated` that fires before
updating a row in `customer`, calling `customer_updated`:

```sh
create-trigger customer_updated before insert or update user customer_updated
```

Generates the following deploy script:

```sql
create trigger customer_updated
  before update on public.customer
  for each row execute function customer_updated();
```

> 📖 See [CREATE TRIGGER](https://www.postgresql.org/docs/current/sql-createtrigger.html).
