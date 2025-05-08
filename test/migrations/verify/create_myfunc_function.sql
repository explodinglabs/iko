begin $$
  assert (
    select exists (
      select 1 from information_schema.routines
      where routine_name = 'myfunc'
      
      and specific_schema = 'myfunc'
          )
  );
end; $$
