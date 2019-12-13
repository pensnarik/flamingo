create or replace
function web.product_by_sef_get(asef varchar) returns integer as $$
    select p.id from shop.product p where p.sef_name = asef;
$$ language sql security definer stable;

alter function web.product_by_sef_get(varchar) owner to shop;
comment on function web.product_by_sef_get(varchar) is 'Returns product ID by sef name if exists';
