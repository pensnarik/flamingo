create or replace
function admin.feedbacks_get() returns table
(
    id integer,
    is_published boolean,
    dt_added timestamptz,
    name varchar,
    message varchar
) as $$
    select f.id, f.is_published, f.dt_added, f.name, f.message
      from shop.feedback f
     order by f.dt_added desc;
$$ language sql security definer stable;

alter function admin.feedbacks_get() owner to shop;
