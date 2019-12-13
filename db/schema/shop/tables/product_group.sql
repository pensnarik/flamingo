create table shop.product_group
(
    id serial primary key,
    mnemonic varchar(126) not null,
    name varchar(126)
);

create unique index on shop.product_group(mnemonic);

alter table shop.product_group owner to shop;

insert into shop.product_group(mnemonic, name) values ('popular', 'Полулярные товары');
