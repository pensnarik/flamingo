create or replace
function web.get_attribute_value
(
    aproduct_id integer,
    aattribute_id integer
) returns text as $$
    select v.value
      from shop.attribute_value v
     where v.attribute_id = aattribute_id
       and v.product_id = aproduct_id;
$$ language sql security definer stable;
