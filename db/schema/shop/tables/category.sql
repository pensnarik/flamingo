create table shop.category (
    id serial primary key,
    name_en text,
    name text,
    parent_id integer,
    sort_order integer not null default 0,
    image varchar(126),
    sef_name varchar(126),
    is_exported boolean not null default false,
    is_visible boolean not null default true
);

alter table only shop.category
    add constraint category_parent_id_fkey foreign key (parent_id) references shop.category(id);

create unique index category_name_parent_id_idx on shop.category using btree (name, parent_id);
create index on shop.category(lower(name_en));
create index on shop.category (parent_id);
create unique index on shop.category (sef_name);

comment on column shop.category.is_exported is 'DEPRECATED';
