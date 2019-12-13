create table shop.order_item
(
    id          serial primary key,
    order_id    integer not null references shop.customer_order(id),
    product_id  integer not null references shop.product(id),
    price       numeric(8,2) not null,
    quantity    integer not null,
    amount      numeric(8,2) not null
);

create unique index on shop.order_item (order_id, product_id);
