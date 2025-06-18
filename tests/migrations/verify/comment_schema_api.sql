do $$
declare
  actual text;
begin
  select description into actual
  from pg_namespace n
  join pg_description d on d.objoid = n.oid
  where d.objsubid = 0
    and n.nspname = 'api';

  -- We don't assert on the value because subsequent comments may override the
  -- original one, which will make the earlier verify scripts fail
  assert actual is not null;
end;
$$ language plpgsql;
