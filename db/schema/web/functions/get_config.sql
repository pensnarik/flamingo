create or replace
function web.get_config() returns json as $$
    select json_object_agg(parameter, value) from shop.config;
$$ language sql security definer stable;
