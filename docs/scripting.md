# ✨ Scripting Migrations

Write reusable Bash scripts to define database changes:

<strong>scripts/auth.sh</strong>

```sh
# Create an auth schema
create_schema auth

# Create a user table
create_table_as auth.user <<'SQL'
create table auth.user (
  username text primary key check (length(username) >= 3),
  password text not null check (length(password) < 512),
  role name not null check (length(role) < 512)
);
SQL

# Add a function to hash passwords
create_function_as auth.encrypt_pass <<'SQL'
create function auth.encrypt_pass () returns trigger language plpgsql as $$
begin
  if tg_op = 'INSERT' or new.password <> old.password then
    new.password = crypt(new.password, gen_salt('bf'));
  end if;
  return new;
end; $$
SQL

# Trigger it on insert/update
create_trigger encrypt_pass auth.user auth.encrypt_pass
```

Run the script to generate migrations:

```sh
iko bash auth.sh
```
