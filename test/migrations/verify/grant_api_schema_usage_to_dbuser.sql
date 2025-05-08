begin $$
  assert (
    select exists (
      select pg_has_role('dbuser', 'api', 'usage')
    )
  );
end; $$
