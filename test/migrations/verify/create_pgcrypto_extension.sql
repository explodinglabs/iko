begin $$
  assert (
    select exists (
      select 1 from pg_extension where extname='pgcrypto'
    )
  );
end; $$
