create table shop.product (
    id serial,
    sku text,
    name text not null,
    url text,
    manufacturer_id integer,
    price numeric(8,2),
    available integer not null default 0,
    is_visible boolean not null default false,
    sef_name varchar(126),
    viewed integer not null default 0,
    dt_added timestamp(0) not null default current_timestamp,
    previous_price numeric,
    create_user_id integer references shop.system_user(id) default core.get_current_user(),
    update_user_id integer references shop.system_user(id) default core.get_current_user(),
    path integer[],
    dt_deleted timestamp(0),
    gtin varchar(255),
    is_exported boolean not null default true,
    sort_order integer not null default 0
);

alter table only shop.product
    add constraint product_manufacturer_id_fkey foreign key (manufacturer_id) references shop.manufacturer(id);

alter table only shop.product
    add constraint product_pkey primary key (id);

create unique index product_sku_idx on product using btree (sku);
create index on shop.product (lower(name) varchar_pattern_ops);
create index product_path_idx on shop.product using gin (path);

comment on column shop.product.available is 'Product units available';
comment on column shop.product.is_visible is 'Toggle product visibility';
comment on column shop.product.viewed is 'Product view count';
comment on column shop.product.previous_price is 'Previous product price';
comment on column shop.product.create_user_id is 'User who created a product';
comment on column shop.product.update_user_id is 'User who was last who updated a product';
comment on column shop.product.path is 'Category path for product';
comment on column shop.product.gtin is 'Global Table Item Number: EAN, UPC, ISBN, etc.';
comment on column shop.product.is_exported is 'If false, product will not be exported by export module despite of the other settings';
comment on column shop.product.sort_order is 'Sort order';
