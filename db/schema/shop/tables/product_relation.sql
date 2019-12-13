create table shop.product_relation
(
    id serial primary key,
    parent_id integer not null references shop.product(id),
    child_id integer not null references shop.product(id),
    relation_id integer not null references shop.relation(id)
);

alter table shop.product_relation owner to shop;

create unique index on shop.product_relation(parent_id, child_id, relation_id);

comment on table shop.product_relation is 'Relations between products';
