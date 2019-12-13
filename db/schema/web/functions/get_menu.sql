-- drop function web.get_menu(varchar);

create or replace
function web.get_menu(aposition varchar default 'left') returns table
(
    id integer,
    title varchar,
    url varchar,
    parent_id integer,
    pos varchar
) as $$
    select m.id, m.title, m.url, m.parent_id, m.position
      from shop.menu m
     where (m.position = aposition or aposition is null)
     order by m.priority;
$$ language sql security definer stable;

comment on function web.get_menu(varchar) is 'Returns menu for website';

alter function web.get_menu(varchar) owner to shop;
