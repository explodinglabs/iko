# Migration Commands

- [Ad-hoc](#adhoc)
- [Extensions](#extensions)
- [Functions](#functions)
- [Grants](#grants)
- [Roles](#roles)
- [Schemas](#schemas)
- [Tables](#tables)
- [Triggers](#triggers)

## Ad-hoc

To create a migration not listed below, use [sqitch
add](https://sqitch.org/docs/manual/sqitch-add/):

```sh
ply sqitch add create_view -n 'Create a view'
```

## Extensions

### create-extension

Load a new extension into the current database.

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

Defines a new function. Edit the function in the generated deploy script.

```sh
create-function <schema> <function>
```

For example, to create a function named `update` in the `api` schema:

```sh
create-function api update
```

Generates the following deploy script:

```sql
create or replace function api.update () returns void language plpgsql as
begin
  return;
end;
```

### create-function-as

Define a function inline (useful in bulk migration scripts).

```sh
create-function-as <schema> <function> <sql>
```

For example, to define a function named `api.square`:

```sh
create-function-as api square <<EOF
create function api.square(@number int) returns int as
begin
    return @number * @number;
end;
EOF
```

## Grants

### grant-execute

Grants execute permission on a function to a role.

```sh
grant-execute <schema> <function> <signature> <role>
```

For example, to grant execute permission on `api.login` to `dbuser`:

```sh
grant-execute api login '(text,text)' dbuser
```

Generates the following deploy script:

```sql
grant execute on function api.login (text,text) to dbuser;
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
grant-privilege <privilege> <schema> <object> <role>
```

For example, to allow an `dbuser` to insert into the `api.asset` table:

```sh
grant-privilege insert api asset dbuser
```

Generates the following deploy script:

```sql
grant select on api.asset to dbuser;
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
$do$
begin
   if exists (
     select from pg_catalog.pg_roles
     where rolname = 'dbuser'
   ) then
      raise notice 'Role already exists, skipping.';
   else
      create role dbuser nologin;
   end if;
end
$do$;
```

### create-role-login

Creates a login role with a password.

```sh
create-role-login <role> <password>
```

For example, to create a `dbuser` role with password, `securepass123`:

```sh
create-role-login dbuser 'securepass123'
```

Generates the following deploy script:

```sql
do $$
begin
   if exists (
     select from pg_catalog.pg_roles
     where rolname = 'dbuser'
   ) then
      raise notice 'Role already exists, skipping.';
   else
      create role dbuser noinherit login password 'securepass123';
   end if;
end $$;
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

Create a new table in the database. Edit the table structure.

```sh
create-table <schema> <table>
```

For example, to create a table named `customer` in the `api` schema:

```sh
create-table api customer
```

Generates the following deploy script:

```sql
create table api.customer (
  id bigint generated always as identity primary key,
  created_at timestamp not null default now(),
  updated_at timestamp not null default now(),
  name text not null
);
```

### create-table-as

Create a new table in the database, inline.
This is useful for bulk migration scripts.

```sh
create-table <schema> <table> <sql>
```

For example, to create a table named `customer` in the `api` schema:

```sh
create-table api customer <<EOF
create table api.customer (
  id bigint generated always as identity primary key,
  created_at timestamp not null default now(),
  updated_at timestamp not null default now(),
  name text not null
);
EOF
```

## Triggers

### create-trigger

Create a trigger on a table.

```sh
create-trigger <trigger> <when> <event> <schema> <table> <function>
```

For example, to create a trigger named `customer_updated` that fires before
updating a row in `api.customer`, calling `api.customer_updated`:

```sh
create-trigger customer_updated before update api customer customer_updated
```

Generates the following deploy script:

```sql
create trigger customer_updated
  before update on api.customer
  for each row execute function api.customer_updated();
```

## Views

Create a view. Edit the select statement.

```sh
./sqitch add create_view_api_teams --template create_view --set schema=api --set name=teams --note 'Add api.teams view'
```
