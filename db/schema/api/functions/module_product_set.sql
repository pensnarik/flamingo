create or replace
function api.module_product_set
(
    amodule varchar,
    aproduct_id integer,
    ais_exported boolean
) returns void as $$
begin
    if ais_exported = true then
        delete from module.module_product where module = amodule and product_id = aproduct_id;
    else
        update module.module_product
           set is_exported = false
         where module = amodule
           and product_id = aproduct_id;

        if not found then
            insert into module.module_product(module, product_id, is_exported)
            values (amodule, aproduct_id, ais_exported);
        end if;
    end if;
end;
$$ language plpgsql security definer;

alter function api.module_product_set(varchar, integer, boolean) owner to shop;
