# Running Commands

Iko supports three ways to run commands — depending on whether you're working interactively or scripting migrations.

---

## 1. 🔹 Command-Line Mode

Run Iko commands directly in your terminal:

```sh
iko create_schema api
iko create_table users
iko deploy
```

This is the most common mode for quick, one-off tasks or small changes.

You can use both:

- Iko’s DSL commands like `create_table`, `create_function`, etc.
- Native Sqitch commands like `deploy`, `revert`, `status`

## 2. 🔸 Shell Mode

Start an interactive session with:

```sh
iko shell
```

Or just:

```sh
iko
```

You’ll get an `iko>` prompt where you can run commands without typing iko every
time:

```sh
iko> create_schema auth
iko> create_table sessions
iko> deploy
```

Useful when you’re exploring or applying a sequence of changes interactively.

## 3. 🔻 Script Mode

Write reusable Bash scripts inside your `scripts/` directory:

```sh
# scripts/auth.sh

create_schema auth

create_table_as auth.user <<'SQL'
create table auth.user (
  username text primary key,
  password text not null,
  role name not null
);
SQL
```

Run the script with:

```sh
iko bash auth.sh
```

Script mode is ideal for:

- Defining and reusing sets of related migrations
- Keeping complex changes readable
- Avoiding repetitive commands

## When to Use Each

| Mode    | Best For                                |
| ------- | --------------------------------------- |
| CLI     | Simple changes, quick edits             |
| Shell   | Interactive sessions, experimenting     |
| Scripts | Reusable, readable, and complex changes |

> ✅ All three modes support the same DSL commands — choose the style that fits
> your workflow.

## 🧭 What's Next?

👉 [Continue to Scripting Iko Migrations](./scripting.md)
