do $$
begin
  assert (
    select exists (
      select 1
      from information_schema.table_privileges
      where lower(privilege_type) = ''
        and table_name = ''
        and grantee = ''
    )
  );
end;
$$ language plpgsql;
