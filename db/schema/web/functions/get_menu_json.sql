create or replace
function web.get_menu_json() returns json as $$
    select coalesce(json_agg(t), '[]'::json) from
    (
        select id, name, 0 depth, sort_order,
               case when c.sef_name is not null then '/category/' || c.sef_name
                    else '/category/' || c.id::text end url,

                (select json_agg(t) from (
                    select cc.id, cc.name, 1 depth,
                    case when cc.sef_name is not null then '/category/' || cc.sef_name
                    else '/category/' || cc.id::text end url
                  from shop.category cc
                 where parent_id = c.id
                   and cc.is_visible order by cc.sort_order) t) childs
          from shop.category c
         where parent_id is null
           and web.has_category_products(c.id)
           and c.is_visible
        group by 1, 2, 3, 4
        order by sort_order
    ) t
$$ language sql security definer stable;

alter function web.get_menu_json() owner to shop;
