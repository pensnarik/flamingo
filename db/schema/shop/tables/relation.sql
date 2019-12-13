create table shop.relation
(
    id serial primary key,
    mnemonic varchar(126) not null unique,
    name varchar(126) not null unique,
    description text
);

alter table shop.relation owner to shop;

comment on column shop.relation.mnemonic is
    'Mnemonic name for relation, in english. '
    'All functions should refer to this unique value instead of if';
