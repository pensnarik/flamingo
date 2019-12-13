create or replace
function web.get_diagram
(
    adiagram varchar,
    avehicle_id integer
) returns table
(
    product_id integer,
    product_name varchar,
    product_sku varchar,
    product_description text,
    product_price numeric(8,2),
    lookup_no smallint
) as $$
    select pd.product_id,
           p.name,
           p.sku,
           web.get_product_description(p.id),
           p.price,
           pd.lookup_no
      from shop.product_diagram pd
      join shop.product p on p.id = pd.product_id
     where pd.diagram = adiagram
       and p.sku like '%-' || avehicle_id::text
    order by pd.lookup_no;
$$ language sql security definer stable;
