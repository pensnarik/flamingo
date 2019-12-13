create or replace
function admin.module_category_get
(
    amodule varchar,
    acategory_id integer
) returns boolean as $$
    select not exists (
        select *
          from module.module_category mc
         where mc.module = amodule
           and mc.category_id = acategory_id
           and mc.is_exported = false
    )
$$ language sql security definer stable;

alter function admin.module_category_get(varchar, integer) owner to shop;
