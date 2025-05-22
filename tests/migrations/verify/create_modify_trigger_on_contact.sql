do $$
begin
  assert (
    select exists (
      select 1
      from information_schema.triggers
      where trigger_name = 'modify'
        and event_object_table = 'contact'
    )
  );
end;
$$ language plpgsql;
