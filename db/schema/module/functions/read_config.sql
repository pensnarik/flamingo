create or replace
function module.read_config(amodule varchar) returns json as $$
    select config from module.config where module = amodule;
$$ language sql security definer stable;
