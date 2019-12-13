create or replace
function admin.banners_get() returns setof shop.banner as $$
    select * from shop.banner order by priority, id;
$$ language sql security definer stable;

alter function admin.banners_get() owner to shop;
