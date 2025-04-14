comment schema api 'This is my comment'
create_extension pgcrypto
create_function_as square <<EOF
create function square(@number int) returns int as
begin
    return @number * @number;
end;
EOF
grant_execute login '(text,text)' dbuser
grant_schema_usage api dbuser
grant_role_membership authenticator dbuser
grant_table_privilege select asset dbuser
create_role dbuser
create_login_role adam 'securepass123'
create_schema api
create_table customer
create_table_as movie <<EOF
create table movie (
  id bigint generated always as identity primary key,
  created_at timestamp not null default now(),
  updated_at timestamp not null default now(),
  name text not null
);
EOF
create_trigger update customer update_table
