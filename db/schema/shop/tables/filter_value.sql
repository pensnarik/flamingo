create table shop.filter_value
(
    id serial primary key,
    filter_id integer not null references shop.filter(id),
    distinct_value text,
    expression text
);

alter table shop.filter_value owner to shop;

create unique index on shop.filter_value(filter_id, distinct_value);
