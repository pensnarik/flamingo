create or replace
function api.set_visibility(asku varchar, ais_visible boolean) returns integer as $$
begin
    update shop.product
       set is_visible = ais_visible
     where sku = asku;

    if found then
        return 0;
    else
        return -1;
    end if;
end;
$$ language plpgsql security definer;

alter function api.set_visibility(varchar, boolean) owner to shop;
