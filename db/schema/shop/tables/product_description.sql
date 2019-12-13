create table product_description (
    id serial,
    product_id integer not null,
    description text not null
);

alter table only shop.product_description
    add constraint product_description_product_id_fkey foreign key (product_id) references shop.product(id);

alter table only shop.product_description
    add constraint product_description_pkey primary key (id);

create unique index product_description_product_id_idx on shop.product_description using btree (product_id);

