create or replace
function admin.snippet_get(aid integer) returns shop.snippet as $$
    select * from shop.snippet where id = aid;
$$ language sql security definer stable;

alter function admin.snippet_get(integer) owner to shop;
