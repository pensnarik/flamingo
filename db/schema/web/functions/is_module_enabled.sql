create or replace
function web.is_module_enabled(amodule varchar) returns boolean as $$
    select exists(select *
                    from module.config c
                   where c.module = amodule and c.is_enabled);
$$ language sql security definer stable;

alter function web.is_module_enabled(varchar) owner to shop;

comment on function web.is_module_enabled(varchar) is 'Return true if module is enabled, if module is disabled or absent returns false';
