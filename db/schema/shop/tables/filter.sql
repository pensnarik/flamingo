create table shop.filter
(
    id              serial primary key,
    attribute_id    integer not null references shop.attribute(id),
    name            text not null,
    operator        varchar(126),
    is_enabled      boolean not null default true,
    distinct_values text[],
    position        integer not null default 0
);

alter table shop.filter owner to shop;

create unique index on shop.filter(attribute_id);
