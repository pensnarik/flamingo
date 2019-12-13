create or replace
function web.category_path(aid integer) returns integer[] as $$
    select case when c.parent_id is null then array[c.id]::integer[]
           else array[c.parent_id, c.id]::integer[]
           end
      from shop.category c
     where c.id = aid;
$$ language sql security definer stable;

alter function web.category_path(integer) owner to shop;
comment on function web.category_path(integer) is 'Returns category path as array';
