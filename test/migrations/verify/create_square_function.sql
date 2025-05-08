begin $$
  assert (
    select exists (
      select 1 from information_schema.routines
      
      where specific_schema = 'square'
            and routine_name = 'square'
    )
  );
end; $$
