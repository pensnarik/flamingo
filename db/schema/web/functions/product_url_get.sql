create or replace
function web.product_url_get(aproduct_id integer) returns varchar as $$
    select case when p.sef_name is not null then '/product/' || p.sef_name
           else '/product/' || p.id::varchar
           end
      from product p
     where p.id = aproduct_id;
$$ language sql security definer stable;

alter function web.product_url_get(integer) owner to shop;
