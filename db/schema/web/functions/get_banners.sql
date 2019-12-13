create or replace
function web.get_banners() returns table
(
    id integer,
    image_url varchar,
    priority integer,
    href varchar
) as $$
    select b.id, b.image_url, b.priority, b.href
      from shop.banner b
     where b.is_visible
     order by b.priority;
$$ language sql security definer stable;

comment on function web.get_banners() is 'Returns banners for site main page';

alter function web.get_banners() owner to shop;
