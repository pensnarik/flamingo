-- drop function web.categories_for_export_get(varchar);

create or replace
function web.categories_for_export_get(amodule varchar) returns table
(
    id integer,
    name varchar,
    parent_id integer
) as $$
    select c.id, c.name, c.parent_id
      from shop.category c
     where not exists (
        select *
          from module.module_category mc
         where mc.module = amodule
           and mc.category_id = c.id
           and mc.is_exported = false
       )
     order by c.id;
$$ language sql security definer stable;

alter function web.categories_for_export_get(varchar) owner to shop;
