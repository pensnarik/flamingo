create or replace
function api.product_attrs_json(aproduct_id integer) returns json as $$
    select coalesce(json_agg((select x from (select ac.name category, a.name, v.value) x)), '[]'::json) as attributes
      from shop.attribute_value v
      join shop.attribute a
        on a.id = v.attribute_id
      join shop.attribute_category ac
        on ac.id = a.attribute_category_id
     where v.product_id = aproduct_id;
$$ language sql security definer stable;
