create or replace
function web.get_feedback() returns table
(
    id integer,
    dt_added timestamptz,
    name varchar,
    message text,
    rate smallint
) as $$
    select f.id, f.dt_added, f.name, f.message, f.rate
      from shop.feedback f
     where f.is_published
     order by f.dt_added desc;
$$ language sql security definer stable;

alter function web.get_feedback() owner to shop;
