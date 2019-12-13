create or replace
function api.product_sort_order_set
(
    asku varchar,
    asort_order integer
) returns integer as $$
declare
    vresult integer;
begin
    update shop.product
       set sort_order = asort_order
     where sku = asku
    returning id into vresult;

    return vresult;
end;
$$ language plpgsql security definer;

comment on function api.product_sort_order_set(varchar, integer) is 'Updates sort_order column value for product';

alter function api.product_group_set(varchar, integer) owner to shop;
