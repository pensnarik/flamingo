-- drop function web.get_product_images(integer);

create or replace
function web.get_product_images
(
    aproduct_id integer,
    asize integer default -1
) returns table
(
    id integer,
    url varchar,
    priority integer
) as $$
    select i.id,
           case when asize = - 1 then i.url
           else replace(i.url, '/static/image/product/', '/static/image/product/' || asize::text || '/')
           end,
           i.priority
      from shop.product_image i
     where i.product_id = aproduct_id
    order by i.priority;
$$ language sql security definer stable;

comment on function web.get_product_images(integer, integer) is 'Returns all images for product, sorted by priority';

alter function web.get_product_images(integer, integer) owner to shop;
