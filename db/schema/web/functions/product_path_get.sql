create or replace
function web.product_path_get(aid integer) returns integer[] as $$
    with recursive r as (
        select c.id, c.parent_id, 0 as level
          from shop.product_category pc
          join shop.category c on c.id = pc.category_id
         where product_id = aid
        union
        select c.id, c.parent_id, level + 1
          from shop.category c
          join r on r.parent_id = c.id
    ) select array_agg(id order by level desc) from r;
$$ language sql security definer stable;

alter function web.product_path_get(integer) owner to shop;
