create or replace
function web.get_category(aid integer) returns
table (
    id integer,
    name varchar,
    image varchar,
    sef_name varchar,
    url varchar
) as $$
    select c.id, c.name, c.image, c.sef_name,
           case when c.sef_name is null then '/category/' || id::varchar
                else '/category/' || c.sef_name
           end
      from shop.category c
     where c.id = aid;
$$ language sql security definer stable;

alter function web.get_category(integer) owner to shop;
