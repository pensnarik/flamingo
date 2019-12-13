create table shop.infopage
(
    id serial primary key,
    url varchar(126),
    views integer not null default 0,
    code text
);

alter table shop.infopage owner to shop;

create unique index on shop.infopage(url);
