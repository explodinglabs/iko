set -euo pipefail

create_extension pgcrypto
create_schema api
comment schema api 'This is my comment'

# Tables
create_table customer
create_table api.customer
create_table_as movie <<'EOF'
create table movie (
  id bigint generated always as identity primary key,
  created_at timestamptz not null default now(),
  name text not null
);
EOF
create_table_as api.movie <<'EOF'
create table api.movie (
  id bigint generated always as identity primary key,
  created_at timestamptz not null default now(),
  name text not null
);
EOF

# Functions
create_function myfunc
create_function api.myfunc
create_function_as update <<'EOF'
create function update() returns trigger as $$
begin
  return new;
end;
$$ language plpgsql;
EOF
create_function_as api.update <<'EOF'
create function api.update() returns trigger as $$
begin
  return new;
end;
$$ language plpgsql;
EOF

# Triggers
create_trigger update_customer customer update
create_trigger update_api_customer api.customer api.update
create_trigger_as modify_customer customer <<'EOF'
create trigger modify_customer
  after insert or update on customer
  for each row execute function update();
EOF
create_trigger_as modify_api_customer api.customer <<'EOF'
create trigger modify_api_customer
  after insert or update on api.customer
  for each row execute function api.update();
EOF

# Roles & Permissions
create_login_role authenticator 'securepass123'
create_role api_user
grant_schema_usage api api_user
grant_execute myfunc '()' api_user
grant_execute api.myfunc '()' api_user
grant_role_membership authenticator api_user
grant_table_privilege select customer api_user
grant_table_privilege select api.customer api_user
