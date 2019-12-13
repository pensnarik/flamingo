create table shop.snippet
(
    id serial primary key,
    name varchar(126),
    pos varchar(126),
    priority integer not null default 0,
    is_enabled boolean not null default true,
    data text,
    show_in_admin boolean not null default true
);

comment on column shop.snippet.show_in_admin is 'Toggles should snippet be displayed when user in admin or not';
