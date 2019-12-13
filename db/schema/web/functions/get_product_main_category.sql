create or replace
function web.get_product_main_category(aproduct_id integer) returns integer as $$
    select category_id from shop.product_category where product_id = aproduct_id;
$$ language sql security definer stable;

comment on function web.get_product_main_category(integer) is 'Returns product category, "main" is for legacy';
