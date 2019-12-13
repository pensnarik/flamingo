create or replace
function web.product_relations_get
(
    aparent_id integer,
    arelation varchar
) returns table
(
    id integer,
    parent_id integer,
    child_id integer,
    relation varchar,
    relation_name varchar,
    child_name varchar,
    child_sku varchar,
    child_price numeric
) as $$
    select pr.id,
           pr.parent_id as parent_id,
           pr.child_id as child_id,
           r.mnemonic as relation,
           r.name as relation_name,
           p.name as child_name,
           p.sku as child_sku,
           p.price as child_price
      from shop.product_relation pr
      join shop.relation r on r.id = pr.relation_id
      join shop.product p on p.id = pr.child_id
     where r.mnemonic = arelation
     order by pr.id;
$$ language sql security definer stable;

alter function web.product_relations_get(integer, varchar) owner to shop;
