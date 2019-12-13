create table shop.black_list
(
    id serial primary key,
    dt_added timestamp(0) not null default current_timestamp,
    ip inet not null,
    is_auto boolean not null default false
);

comment on table shop.black_list is 'Blask list, customers cannot make orders from these ips';

alter table shop.black_list owner to shop;

create unique index on shop.black_list(ip);
