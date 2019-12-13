create or replace
function admin.infopage_get(aid integer) returns table
(
    id integer,
    url varchar,
    views integer,
    code text
) as $$
    select p.id, p.url, p.views, p.code
      from shop.infopage p
     where p.id = aid;
$$ language sql security definer stable;

alter function admin.infopage_get(integer) owner to shop;
