begin $$
   if exists (
     select from pg_catalog.pg_roles
     where rolname = 'dbuser'
   ) then
      raise notice 'Role already exists, skipping.';
   else
      create role 'dbuser' nologin;
   end if;
end; $$
