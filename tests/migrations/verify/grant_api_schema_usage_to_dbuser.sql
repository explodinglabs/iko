do $$
begin
  assert pg_has_role('dbuser', 'api', 'USAGE'),
    format('Role %s must have USAGE on schema %s', 'dbuser', 'api');
end;
$$ language plpgsql;
