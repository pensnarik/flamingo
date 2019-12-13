create table module.config
(
    id          serial primary key,
    module      varchar(126) not null,
    config      jsonб
    is_enabled boolean not null default true
);

create unique index on module.config(module);

comment on column module.config.is_enabled is 'Is module enabled';
