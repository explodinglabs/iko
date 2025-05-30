# Command Reference

This page lists all the commands provided by Iko.

Iko provides a developer-friendly DSL for defining database migrations. These
commands generate `deploy`, `revert`, and `verify` scripts using built-in
templates and follow a consistent pattern.

You can run commands:

- Directly from the command line
- Inside an interactive Iko shell
- From reusable Bash scripts

For a breakdown of these options, see [Running Commands](./running.md).  
For tips on writing migration scripts, see [Scripting](./scripting.md).

---

## 🔁 Sqitch Commands

Iko wraps and aliases all core [Sqitch
commands](https://sqitch.org/docs/manual/).

For example:

```sh
iko deploy
iko revert
iko status
```

You can also access Sqitch directly:

```sh
iko sqitch --version
```

---

## 🧩 Ad-Hoc Migrations

If your change doesn’t match one of the built-in commands, you can use `add` to
create a named migration manually:

```sh
add create_customer_view
```

You’ll be prompted to enter a note, and then edit the deploy/revert/verify SQL
files yourself.

> Only the deploy script is required. The verify and revert scripts are
> optional.

More details: [sqitch-add docs](https://sqitch.org/docs/manual/sqitch-add/)

---

## 🗨️ Comments

Add or update a comment on a Postgres object.

**Syntax:**

```sh
comment <object> <comment>
```

**Example:**

```sh
comment schema api 'Schema for the API endpoints'
```

---

## 🧩 Extensions

Install a Postgres extension.

**Syntax:**

```sh
create_extension <extension>
```

**Example:**

```sh
create_extension pgcrypto
```

---

## 🧠 Functions

### `create_function`

Create a function using your editor.

**Syntax:**

```sh
create_function <function>
```

**Example:**

```sh
create_function create_user
```

---

### `create_function_as`

Define a function inline — useful in scripts.

**Syntax:**

```sh
create_function_as <function> <<'SQL'
<sql>
SQL
```

**Example:**

```sh
create_function_as square <<'SQL'
create function square(n int) returns int as $$
begin
  return n * n;
end;
$$ language plpgsql;
SQL
```

---

## 🔐 Grants

### `grant_execute`

Grant execute permission on a function.

**Syntax:**

```sh
grant_execute <function> <signature> <role>
```

**Example:**

```sh
grant_execute login '(text,text)' dbuser
```

---

### `grant_schema_usage`

Grant usage on a schema.

**Syntax:**

```sh
grant_schema_usage <schema> <role>
```

**Example:**

```sh
grant_schema_usage api dbuser
```

---

### `grant_role_membership`

Grant membership in a role.

**Syntax:**

```sh
grant_role_membership <role_specification> <role>
```

**Example:**

```sh
grant_role_membership authenticator dbuser
```

---

### `grant_table_privilege`

Grant privileges on a table.

**Syntax:**

```sh
grant_table_privilege <type> <table> <role>
```

**Example:**

```sh
grant_table_privilege insert asset dbuser
```

---

## 👤 Roles

### `create_role`

Create a nologin role.

**Syntax:**

```sh
create_role <role>
```

**Example:**

```sh
create_role dbuser
```

---

### `create_login_role`

Create a login role with password.

**Syntax:**

```sh
create_login_role <role> <password>
```

**Example:**

```sh
create_login_role dbuser 'securepass123'
```

---

## 🏗️ Schemas

**Syntax:**

```sh
create_schema <schema>
```

**Example:**

```sh
create_schema api
```

---

## 🧱 Tables

### `create_table`

Create a table using your editor.

**Syntax:**

```sh
create_table <table>
```

**Example:**

```sh
create_table customer
```

---

### `create_table_as`

Define a table inline — ideal for scripts.

**Syntax:**

```sh
create_table_as <table> <<'SQL'
<sql>
SQL
```

**Example:**

```sh
create_table_as customer <<'SQL'
create table customer (
  id bigint generated always as identity primary key,
  name text not null,
  created_at timestamp not null default now()
);
SQL
```

---

## 🔁 Triggers

### `create_trigger`

Create a trigger linked to a function.

**Syntax:**

```sh
create_trigger <trigger> <table> <function>
```

**Example:**

```sh
create_trigger customer_updated customer customer_updated
```

> Note: Trigger names cannot be schema-qualified — they inherit the table's schema.

---

### `create_trigger_as`

Define a trigger inline.

**Syntax:**

```sh
create_trigger_as <trigger> <table> <<'SQL'
<sql>
SQL
```

**Example:**

```sh
create_trigger_as modify contact <<'SQL'
create trigger modify
  after insert or update on contact
  for each row execute function modify_record();
SQL
```

---

## ⏭️ Next Steps

👉 Learn the [different ways to run commands](./running.md)  
👉 Or go deeper into [writing reusable scripts](./scripting.md)
