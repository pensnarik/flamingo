create table shop.manufacturer (
    id serial,
    name text not null
);

alter table only shop.manufacturer
    add constraint manufacturer_pkey primary key (id);

create unique index manufacturer_name_idx on shop.manufacturer(name);
