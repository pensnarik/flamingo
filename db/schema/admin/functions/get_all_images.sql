create or replace
function admin.get_all_images() returns table
(
    id integer,
    product_id integer,
    url varchar
) as $$
    select id, product_id, url from shop.product_image order by 1;
$$ language sql security definer stable;

alter function admin.get_all_images() owner to shop;

comment on function admin.get_all_images() is 'Returns all images for all products: for debug or develop purposes';
