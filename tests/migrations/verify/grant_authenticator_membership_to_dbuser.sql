do $$
begin
  assert (
    select pg_has_role('authenticator', 'dbuser', 'member')
  );
end;
$$ language plpgsql;
