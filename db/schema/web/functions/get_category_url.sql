create or replace
function web.get_category_url(aid integer) returns varchar as $$
    select case when c.sef_name is null then '/category/' || id::varchar
                else '/category/' || c.sef_name
           end
      from shop.category c
     where c.id = aid;
$$ language sql security definer stable;

alter function web.get_category_url(integer) owner to shop;
