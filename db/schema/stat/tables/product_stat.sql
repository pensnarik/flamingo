create table stat.product_stat
(
    id serial primary key,
    dt date not null default current_date,
    product_id integer not null references shop.product(id),
    viewed integer not null default 0,
    added_to_cart integer not null default 0,
    ordered integer not null default 0
);

alter table stat.product_stat owner to shop;

create unique index on stat.product_stat(dt, product_id);
