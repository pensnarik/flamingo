create or replace
function web.get_product_id(asku varchar) returns integer as $$
    select p.id from shop.product p where p.sku = asku;
$$ language sql security definer stable;

comment on function web.get_product_id(varchar) is 'Returns product ID by SKU';

alter function web.get_product_id(varchar) owner to shop;
