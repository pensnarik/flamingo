create or replace
function web.export_stat(aday date default current_date) returns table
(
    sku varchar,
    name varchar,
    viewed integer,
    added_to_cart integer,
    ordered integer
) as $$
    select p.sku, p.name, s.viewed, s.added_to_cart, s.ordered
      from stat.product_stat s
      join shop.product p on p.id = s.product_id
     where s.dt = aday
       and s.viewed > 0
     order by s.viewed desc;
$$ language sql security definer stable;

alter function web.export_stat(date) owner to shop;

comment on function web.export_stat(date) is 'Exports product stat for mailing and so on';
