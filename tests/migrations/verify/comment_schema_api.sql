do $$
begin
  assert (
    select description = 'This is my comment'
    from pg_namespace n
    join pg_description d on d.objoid = n.oid
    where n.nspname = 'api'
      and d.objsubid = 0
  );
end;
$$ language plpgsql;
