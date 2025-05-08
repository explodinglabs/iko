begin $$
   if exists (
     select from pg_catalog.pg_roles
     where rolname = 'adam'
   ) then
      raise notice 'Role already exists, skipping.';
   else
      create role 'adam' noinherit login password 'securepass123';
   end if;
end; $$
