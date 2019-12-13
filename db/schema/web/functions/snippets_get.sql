-- drop function web.snippets_get(varchar);

create or replace
function web.snippets_get(apos varchar default null) returns table
(
    id integer,
    name varchar,
    pos varchar,
    priority integer,
    data text,
    show_in_admin boolean
) as $$
    select s.id, s.name, s.pos, s.priority, s.data, s.show_in_admin
      from shop.snippet s
     where (s.pos = apos or apos is null)
       and s.is_enabled
     order by priority;
$$ language sql security definer stable;

alter function web.snippets_get(varchar) owner to shop;
