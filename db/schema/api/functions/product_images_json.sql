create or replace
function api.product_images_json(aproduct_id integer) returns json as $$
    select coalesce(json_agg((select x from (select  i.priority, i.url) x)), '[]'::json) as images
      from shop.product_image i
     where i.product_id = aproduct_id;
$$ language sql security definer stable;
