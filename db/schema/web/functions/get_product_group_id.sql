create or replace
function web.get_product_group_id(amnemonic varchar) returns integer as $$
    select p.id from shop.product_group p where mnemonic = amnemonic;
$$ language sql security definer stable;

alter function web.get_product_group_id(varchar) owner to shop;
