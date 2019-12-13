create table stat.product_available_history
(
    id serial primary key,
    product_id integer not null,
    dt_from timestamptz(0) not null default current_timestamp,
    available integer,
    user_id integer references shop.system_user(id) default core.get_current_user()
);

create unique index on stat.product_available_history(product_id, dt_from);

alter table stat.product_available_history owner to shop;
comment on table stat.product_available_history is 'Product available history';

comment on column stat.product_available_history.user_id is 'User ID';
