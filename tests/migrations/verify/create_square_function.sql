do $$
begin
  assert (
    select exists (
      select 1 from information_schema.routines
      where routine_name = 'square'
    )
  );
end;
$$ language plpgsql;
