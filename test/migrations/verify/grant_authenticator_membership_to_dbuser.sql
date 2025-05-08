begin $$
  assert (
    select exists (
      select pg_has_role('authenticator', 'dbuser', 'member')
    )
  );
end; $$
