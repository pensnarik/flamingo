create table shop.system_user
(
    id          serial primary key,
    login       varchar(50) not null,
    password    char(32) not null,
    create_date timestamptz(0) default now() not null,
    name        varchar(126),
    is_admin    boolean default false not null,
    email       varchar(255),
    user_role   varchar(100)
);

create unique index system_user_lower_idx on shop.system_user using btree (lower((login)::text));

insert into shop.system_user(login, password, name, email) values ('admin', md5('admin'), 'Администратор', 'admin@flamingo.ru');
