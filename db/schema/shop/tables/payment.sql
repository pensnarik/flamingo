create table shop.payment
(
    id              serial primary key,
    dt_added        timestamptz(0) not null default now(),
    dt_processed    timestamptz(0),
    status          shop.t_payment_status not null default 'new',
    service         varchar(126) not null,
    order_id        integer not null references shop.customer_order(id),
    ip              inet not null,
    currency        shop.t_currency not null,
    amount          numeric(8,2),
    external_id     varchar(255)
);

create unique index on shop.payment using btree (service, external_id);