create table i18n.translation_column
(
    id                serial primary key,
    table_name        varchar(126),
    original_column   varchar(126),
    translated_column varchar(126)
);

create unique index on i18n.translation_column(table_name, original_column);

comment on table i18n.translation_column is 'Columns for translation';
