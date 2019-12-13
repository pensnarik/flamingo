create table shop.payment_method
(
    id          serial primary key,
    code        varchar(50) not null,
    name        varchar(255) not null
);

create unique index payment_method_code on shop.payment_method(code);
create unique index payment_method_name on shop.payment_method(name);

alter table shop.customer_order add payment_method_id integer references shop.payment_method(id);

alter table shop.payment_method owner to shop;
