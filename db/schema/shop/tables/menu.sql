create table shop.menu
(
    id serial primary key,
    title varchar(126) not null,
    url varchar(126) not null,
    parent_id integer references shop.menu(id)
);
