create table shop.cart
(
    id serial primary key,
    customer_id integer not null references shop.customer(id),
    product_id integer not null references shop.product(id),
    quantity smallint not null default 1,
    dt_added timestamptz(0) not null default current_timestamp
);

comment on table shop.cart is 'Корзина';

create unique index on shop.cart(customer_id, product_id);
