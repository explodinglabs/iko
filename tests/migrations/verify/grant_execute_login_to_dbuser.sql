begin $$
  assert (
    select has_function_privilege(
      'dbuser',
      'login(text,text)',
      'execute'
    )
  );
end; $$
