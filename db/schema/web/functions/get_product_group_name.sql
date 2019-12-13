create or replace
function web.get_product_group_name(aid integer) returns varchar as $$
    select p.name from shop.product_group p where id = aid;
$$ language sql security definer stable;

alter function web.get_product_group_name(integer) owner to shop;
