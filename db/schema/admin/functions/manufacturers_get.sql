create or replace
function admin.manufacturers_get() returns table
(
    id integer,
    name varchar
) as $$
    select m.id, m.name from shop.manufacturer m order by m.name;
$$ language sql security definer stable;

alter function admin.manufacturers_get() owner to shop;
