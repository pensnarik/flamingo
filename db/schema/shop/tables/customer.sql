create table shop.customer
(
    id          serial primary key,
    secret      char(32) unique not null default web.generate_customer_secret(),
    dt_created  timestamptz(0) not null default current_timestamp
);
