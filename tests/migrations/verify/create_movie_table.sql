do $$
begin
  assert (
    select exists (
      select 1
      from information_schema.tables
      where table_name = 'movie'
        and table_schema = 'movie'
    )
  );
end;
$$ language plpgsql;
