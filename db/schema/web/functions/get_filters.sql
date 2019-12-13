create or replace
function web.get_filters() returns json as $$
    select coalesce(json_agg((select x from (select attribute_id, name, operator, distinct_values, position) x) order by position), '{}'::json)
      from shop.filter
     where is_enabled;
$$ language sql security definer stable;

alter function web.get_filters() owner to shop;
