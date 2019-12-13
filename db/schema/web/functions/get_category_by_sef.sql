create or replace
function web.get_category_by_sef(asef varchar) returns integer as $$
    select c.id from shop.category c where sef_name = asef;
$$ language sql security definer stable;

alter function web.get_category_by_sef(varchar) owner to shop;
