-- drop function web.get_popular_products(integer);

create or replace
function web.get_popular_products(alimit integer default 10) returns integer[] as $$
    select array_agg(p.id order by p.name)
      from shop.product p
      join shop.products_in_group pg on pg.product_id = p.id
      join shop.product_group g on g.id = pg.group_id
     where g.mnemonic = 'popular'
       and p.is_visible
       and p.dt_deleted is null
$$ language sql security definer;

alter function web.get_popular_products(integer) owner to shop;

comment on function web.get_popular_products(integer) is 'Returns popular products for main page';
