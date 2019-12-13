create table shop.banner
(
    id serial primary key,
    image_url varchar(255) not null,
    priority integer not null default 0,
    is_visible boolean not null default true,
    href varchar(255)
);

alter table shop.banner owner to shop;
