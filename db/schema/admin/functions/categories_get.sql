-- drop function admin.categories_get(integer);

create or replace
function admin.categories_get(aparent_id integer) returns setof shop.category as $$
    select *
      from shop.category c
    order by c.sort_order;
$$ language sql security definer stable;

comment on function admin.categories_get(integer) is 'Returns a category list';

alter function admin.categories_get(integer) owner to shop;
