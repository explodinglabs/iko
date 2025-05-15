do $$
begin
  assert (
    select exists (
      select 1
      from information_schema.tables
      where table_name = 'customer'
        and table_schema = 'customer'
    )
  );
end;
$$ language plpgsql;
