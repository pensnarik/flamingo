create table shop.product_image (
    id serial,
    product_id integer not null,
    priority integer default 0 not null,
    url text not null
);

alter table only shop.product_image
    add constraint product_image_product_id_fkey foreign key (product_id) references shop.product(id);

alter table only shop.product_image
    add constraint product_image_pkey primary key (id);
