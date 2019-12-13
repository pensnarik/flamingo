-- drop function web.get_products(integer);

create or replace
function web.get_products(acategory_id integer) returns integer[] as $$
    select array_agg(id order by p.name)
      from shop.product p
     where exists (
        select *
          from shop.product_category pc
          left join shop.category c on pc.category_id = c.id
         where pc.product_id = p.id
           and (pc.category_id = acategory_id or c.parent_id = acategory_id)
    )
       and p.is_visible and p.dt_deleted is null;
$$ language sql security definer;

comment on function web.get_products(integer) is 'Returns product list for category page';

alter function web.get_products(integer) owner to shop;
