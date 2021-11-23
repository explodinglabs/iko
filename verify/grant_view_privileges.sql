-- Verify [% project %]:[% change %] on [% engine %]

do $$
BEGIN

-- For a table or view
assert (
    select exists (
        select 1 from information_schema.table_privileges
        where privilege_type = '[% type %]'
        and table_schema='[% schema %]'
        and table_name = '[% table %]'
        and grantee='[% role %]'
    )
);

END; $$;
