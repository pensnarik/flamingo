-- drop function admin.product_get(integer);

create or replace
function admin.product_get(aid integer) returns
table (
    id integer,
    sku varchar,
    name varchar,
    url varchar,
    manufacturer_id integer,
    price numeric,
    diagram varchar,
    lookup_no smallint,
    vehicle_id varchar,
    note text,
    description text,
    image text,
    available integer,
    manufacturer_name varchar,
    category_id integer,
    is_visible boolean,
    previous_price numeric,
    sef_name varchar,
    gtin varchar
) as $$
    select p.id,
           p.sku,
           p.name,
           web.product_url_get(p.id),
           p.manufacturer_id,
           p.price,
           (select diagram from shop.product_diagram where product_id = p.id limit 1),
           (select lookup_no from shop.product_diagram where product_id = p.id limit 1),
           substring(sku from '-(.+)$'),
           web.get_attribute_value(p.id, web.get_attribute_id('Note')),
           web.get_product_description(p.id),
           web.get_product_main_image(p.id),
           p.available,
           m.name,
           web.get_product_main_category(p.id),
           p.is_visible,
           p.previous_price,
           p.sef_name,
           p.gtin
      from shop.product p
      left join shop.manufacturer m on m.id = p.manufacturer_id
     where p.id = aid;
$$ language sql security definer stable;

alter function admin.product_get(integer) owner to shop;
