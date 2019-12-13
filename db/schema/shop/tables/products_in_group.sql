create table shop.products_in_group
(
    id serial primary key,
    product_id integer not null references shop.product(id),
    group_id integer not null references shop.product_group(id)
);

create unique index on shop.products_in_group(product_id, group_id);

alter table shop.products_in_group owner to shop;
