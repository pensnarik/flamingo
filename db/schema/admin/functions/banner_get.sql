create or replace
function admin.banner_get(aid integer) returns shop.banner as $$
    select * from shop.banner where id = aid;
$$ language sql security definer stable;

alter function admin.banner_get(integer) owner to shop;
