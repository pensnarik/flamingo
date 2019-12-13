create table shop.customer_order
(
    id            serial primary key,
    customer_id   integer not null references shop.customer(id),
    dt_create     timestamptz(0) not null default current_timestamp,
    amount        numeric(8,2),
    status        shop.t_order_status not null default 'new',
    token         char(32) not null default web.generate_customer_secret(),
    email         varchar(126) not null,
    phone         varchar(20) not null,
    name          varchar(126),
    city          varchar(126) not null,
    address       varchar(1000) not null,
    ip            inet not null,
    user_agent    varchar(1000),
    delivery_cost numeric(8,2) not null default 0,
    delivery_code varchar(126),
    delivery_name varchar(255)
);

create index on shop.customer_order(customer_id);

select setval('shop.customer_order_id_seq', 100200);

comment on column shop.customer_order.delivery_name is 'Full name of delivery service';
