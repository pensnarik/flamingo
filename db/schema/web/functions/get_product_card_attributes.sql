create or replace
function web.get_product_card_attributes(aproduct_id integer)
returns table
(
    category_id integer,
    category_name varchar,
    id integer,
    name  varchar,
    value varchar
) as $$
begin
    return query
    select c.id, c.name::varchar, a.id, a.name::varchar, v.value::varchar
      from shop.attribute_value v
      join shop.attribute a on a.id = v.attribute_id
      join shop.attribute_category c on c.id = a.attribute_category_id
     where v.product_id = aproduct_id
       and a.in_product_card = true;
end;
$$ language plpgsql security definer stable;
