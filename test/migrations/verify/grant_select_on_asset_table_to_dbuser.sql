begin $$
  assert (
    select exists (
      select 1 from information_schema.table_privileges
      where lower(privilege_type) = 'select'
      
      and table_schema = 'api'
            and table_name = ''
      and grantee = 'dbuser'
    )
  );
end; $$
