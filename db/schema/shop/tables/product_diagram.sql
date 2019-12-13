create table shop.product_diagram
(
    id serial primary key,
    product_id integer not null references shop.product(id),
    diagram varchar(126),
    lookup_no smallint
);

create index on shop.product_diagram(product_id);
create unique index on shop.product_diagram(product_id, diagram, lookup_no);
