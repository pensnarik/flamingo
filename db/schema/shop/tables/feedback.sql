create table shop.feedback
(
    id serial primary key,
    name varchar(126),
    dt_added timestamptz(0) not null default current_timestamp,
    rate smallint not null default 5,
    message text,
    ip inet,
    is_published boolean not null default false
);
