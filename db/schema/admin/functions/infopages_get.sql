create or replace
function admin.infopages_get() returns table
(
    id integer,
    url varchar,
    views integer
) as $$
    select p.id, p.url, p.views
      from shop.infopage p
     order by p.id;
$$ language sql security definer stable;

alter function admin.infopages_get() owner to shop;
