create table shop.attribute (
    id serial,
    attribute_category_id integer references shop.attribute_category(id),
    in_product_card boolean not null default false,
    name text,
    description text,
    priority integer not null default 0
);

alter table only attribute
    add constraint attribute_pkey primary key (id);

create unique index attribute_name_idx on shop.attribute using btree (attribute_category_id, name);


