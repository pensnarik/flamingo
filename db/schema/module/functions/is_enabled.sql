create or replace
function module.is_enabled(amodule varchar) returns boolean as $$
    select exists (select * from module.config where module = amodule and is_enabled = true);
$$ language sql security definer;

alter function module.is_enabled(varchar) owner to shop;
