create or replace
function web.product_accessories_get(aproduct_id integer) returns integer[] as $$
    select array_agg(child_id) from web.product_relations_get(aproduct_id, 'accessory');
$$ language sql security definer stable;

alter function web.product_accessories_get(integer) owner to shop;

