create table module.module_category
(
    id serial primary key,
    module varchar not null,
    category_id integer not null references shop.category(id) on delete cascade,
    is_exported boolean not null default true
);

create unique index on module.module_category(module, category_id);

comment on table module.module_category is 'Category export settings for export modules';

alter table module.module_category owner to shop;
