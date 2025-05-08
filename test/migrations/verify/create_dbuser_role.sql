begin $$
  assert (
    select exists (
      select 1
      from information_schema.enabled_roles
      where role_name = 'dbuser'
    )
  );
end; $$
