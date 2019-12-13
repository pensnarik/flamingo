create table shop.product_option (
    id serial,
    product_id integer not null,
    value text not null
);

alter table only shop.product_option
    add constraint product_option_product_id_fkey foreign key (product_id) references shop.product(id);

alter table only shop.product_option
    add constraint product_option_pkey primary key (id);

create unique index product_option_product_id_value_idx on product_option using btree (product_id, value);
