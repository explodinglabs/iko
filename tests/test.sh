set -euo pipefail

create_extension pgcrypto
create_schema api

# Tables
create_table customer
create_table api.customer
create_table_as movie <<'SQL'
create table movie (
  id bigint generated always as identity primary key,
  created_at timestamptz not null default now(),
  name text not null
);
SQL
create_table_as api.movie <<'SQL'
create table api.movie (
  id bigint generated always as identity primary key,
  created_at timestamptz not null default now(),
  name text not null
);
SQL

# Functions
create_function myfunc
create_function api.myfunc
create_function_as update <<'SQL'
create function update() returns trigger as $$
begin
  return new;
end;
$$ language plpgsql;
SQL
create_function_as api.update <<'SQL'
create function api.update() returns trigger as $$
begin
  return new;
end;
$$ language plpgsql;
SQL

# Triggers
create_trigger update_customer customer update
create_trigger update_api_customer api.customer api.update
create_trigger_as modify_customer customer <<'SQL'
create trigger modify_customer
  after insert or update on customer
  for each row execute function update();
SQL
create_trigger_as modify_api_customer api.customer <<'SQL'
create trigger modify_api_customer
  after insert or update on api.customer
  for each row execute function api.update();
SQL

# Comments
comment schema api 'This is my comment'
comment -c another_comment schema api <<'EOF'
Multiline comment
Multiline comment
Multiline comment
EOF
comment table api.customer 'The customer table'
comment column api.customer.name 'The customers name'
# Test where the table is not schema qualified
comment column movie.name 'The movie name'
comment function 'api.myfunc()' 'The myfunc function'

# Roles & Permissions
create_login_role authenticator 'securepass123'
create_role api_user
grant_schema_usage api api_user
grant_execute 'myfunc()' api_user
grant_execute 'api.myfunc()' api_user
grant_role_membership authenticator api_user
grant_table_privilege select customer api_user
grant_table_privilege select api.customer api_user


