create or replace
function shop.category_path_as_text(apath integer[]) returns text as $$
    select array_to_string(shop.category_path_as_arr(apath), '->');
$$ language sql security definer stable;

alter function shop.category_path_as_text(integer[]) owner to shop;
