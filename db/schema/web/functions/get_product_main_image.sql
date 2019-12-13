drop function web.get_product_main_image(integer);

create or replace
function web.get_product_main_image
(
    aproduct_id integer,
    asize integer default -1
) returns text as $$
    select case when asize = -1 then i.url
           else replace(i.url, '/static/image/product/', '/static/image/product/' || asize::text || '/')
           end
      from shop.product_image i
     where product_id = aproduct_id order by priority limit 1;
$$ language sql security definer stable;

alter function web.get_product_main_image(integer, integer) owner to shop;
