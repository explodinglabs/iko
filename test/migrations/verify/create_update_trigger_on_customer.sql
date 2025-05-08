begin $$
  assert (
    select exists (
      select 1 from information_schema.triggers
      where trigger_name = 'update'
      
      and event_object_schema = 'customer'
            and event_object_table = 'customer'
    )
  );
end; $$
