create or replace
function web.get_breadcrumbs
(
  acategory_id integer
) returns
table (
    id        integer,
    name      text,
    parent_id integer,
    level     integer,
    root_id   integer,
    path      integer[],
    spath     text[]
) as $$
with recursive r as (
    select id, name, parent_id, 1 as level, id as root_id, array[id] as path, array[name] as spath
      from shop.category
     where id = acategory_id
    union
    select c.id, c.name, c.parent_id, r.level + 1 as level, r.path[1], r.path || c.id as path, r.spath || array[c.name] as spath
      from shop.category c
      join r on r.parent_id = c.id
)
select * from r;
$$ language sql security definer;
