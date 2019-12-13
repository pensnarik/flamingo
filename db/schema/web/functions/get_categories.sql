-- drop function web.get_categories(integer);

create or replace
function web.get_categories(aparent_id integer) returns
table (
    id integer,
    parent_id integer,
    name varchar,
    image varchar,
    sef_name varchar,
    url varchar
) as $$
    select c.id, c.parent_id, c.name, c.image, c.sef_name,
           case when c.sef_name is null then '/category/' || id::varchar
                else '/category/' || c.sef_name
           end
      from shop.category c
     where c.parent_id is not distinct from aparent_id
       -- and exists (select *
       --               from shop.product_category pc
       --               join shop.product p on p.id = pc.product_id
       --              where pc.category_id = c.id
       --                and p.is_visible
       --             )
    order by c.sort_order, c.name;
$$ language sql security definer stable;

alter function web.get_categories(integer) owner to shop;
