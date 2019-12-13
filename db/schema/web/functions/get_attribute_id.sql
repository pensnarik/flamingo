create or replace
function web.get_attribute_id(aattribute_name varchar) returns integer as $$
    select id from shop.attribute where name = aattribute_name;
$$ language sql security definer immutable;
