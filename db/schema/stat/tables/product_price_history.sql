create table stat.product_price_history
(
    id serial primary key,
    product_id integer not null,
    dt_from timestamptz(0) not null default current_timestamp,
    price numeric(8, 2),
    user_id integer references shop.system_user(id) default core.get_current_user()
);

create unique index on stat.product_price_history(product_id, dt_from);

alter table stat.product_price_history owner to shop;
comment on table stat.product_price_history is 'Product price history';

comment on column stat.product_price_history.user_id is 'User ID';
