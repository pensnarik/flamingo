create table shop.attribute_value (
    id serial,
    product_id integer not null,
    attribute_id integer not null,
    value text
);

alter table only shop.attribute_value
    add constraint attribute_value_product_id_fkey foreign key (product_id) references shop.product(id);

alter table only shop.attribute_value
    add constraint attribute_value_attribute_id_fkey foreign key (attribute_id) references shop.attribute(id);

alter table only shop.attribute_value
    add constraint attribute_value_pkey primary key (id);

create unique index attribute_value_product_id_attribute_id_idx on shop.attribute_value using btree (product_id, attribute_id);
