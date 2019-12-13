create or replace
function admin.price_history_get() returns table
(
    id integer,
    product_id integer,
    sku varchar,
    name varchar,
    old_price numeric,
    new_price numeric,
    user_id integer,
    user_name varchar,
    dt_from timestamptz,
    product_url varchar
) as $$
    select t.id, t.product_id, t.sku, t.product_name, t.old_price,
           t.price, t.user_id, t.user_name, t.dt_from, t.product_url
      from (
        select h.id,
               h.product_id,
               p.sku,
               p.name as product_name,
               lag(h.price) over (partition by h.product_id order by dt_from) as old_price,
               h.price,
               h.user_id,
               u.name as user_name,
               h.dt_from,
               web.product_url_get(p.id) as product_url
          from stat.product_price_history h
          join shop.product p on p.id = h.product_id
          left join shop.system_user u on u.id = h.user_id
      ) t
     where t.dt_from > now() - interval '2 weeks'
    order by t.dt_from desc;
$$ language sql security definer stable;

alter function admin.price_history_get() owner to shop;

comment on function admin.price_history_get() is 'Product price history report';
