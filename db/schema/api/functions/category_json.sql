create or replace
function api.category_json(acategory text) returns json as $$
    select row_to_json(r) from (select name, image, sort_order from shop.category where name = acategory) r;
$$ language sql security definer stable;

alter function api.category_json(text) owner to shop;
