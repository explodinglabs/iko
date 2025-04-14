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
