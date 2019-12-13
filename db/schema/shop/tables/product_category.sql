create table shop.product_category (
    id serial,
    product_id integer not null,
    category_id integer not null,
    date_time timestamp(0) without time zone default now() not null
);

alter table only shop.product_category
    add constraint product_category_category_id_fkey foreign key (category_id) references shop.category(id);

alter table only shop.product_category
    add constraint product_category_product_id_fkey foreign key (product_id) references shop.product(id);

alter table only shop.product_category
    add constraint product_category_pkey primary key (id);

create index on shop.product_category(product_id);
create index on shop.product_category(category_id);
create unique index on shop.product_category(product_id);
