create table i18n.translation_manual
(
    id            integer primary key default nextval('i18n.translation_id_seq'),
    original      text not null,
    translation   text,
    translator    varchar(126),
    dt_added      timestamptz(0) not null default current_timestamp,
    dt_translated timestamptz(0)
);

create unique index on i18n.translation(lower(original));
