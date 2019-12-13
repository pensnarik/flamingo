create or replace
function api.category_json_by_id(acategory_id integer) returns json as $$
    select row_to_json(r) from (select name, image, sort_order from shop.category where id = acategory_id) r;
$$ language sql security definer stable;

alter function api.category_json(text) owner to shop;
