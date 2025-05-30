# ✨ Scripting Migrations

Iko’s scripting model lets you define migrations in plain Bash — using the same
DSL commands you’d use in CLI or shell mode.

---

## 📁 Where Scripts Go

Place your scripts in a `scripts/` directory in your project:

```
myapp/
├── migrations/
└── scripts/
    ├── auth.sh
    └── roles.sh
```

---

## 🧪 Example Script

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

create_function_as auth.encrypt_pass <<'SQL'
create function auth.encrypt_pass () returns trigger language plpgsql as $$
begin
  -- hash password before insert/update
  if tg_op = 'INSERT' or new.password <> old.password then
    new.password = crypt(new.password, gen_salt('bf'));
  end if;
  return new;
end; $$
SQL
```

Run with:

```sh
iko bash auth.sh
```

## 🧠 Tips

- Use `<<'SQL'` to safely embed SQL blocks
- Break large scripts into smaller ones per concern (e.g. auth.sh, roles.sh, audit.sh)
- Scripts are regular Bash: loops, conditionals, and functions all work

## 🧭 What's Next?

👉 [See how to deploy migrations to remote environments](./deploying.md)
