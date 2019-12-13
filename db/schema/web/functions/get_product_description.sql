create or replace
function web.get_product_description
(
    aproduct_id integer,
    achars_limit integer default null
) returns text as $$
    select case when achars_limit is null or (length(d.description) < achars_limit - 3) then d.description
                else substring(d.description from 1 for achars_limit) || '...'
                end
      from shop.product_description d
     where d.product_id = aproduct_id;
$$ language sql security definer stable;

comment on function web.get_product_description(integer, integer) is 'Returns product description';

alter function web.get_product_description(integer, integer) owner to shop;
