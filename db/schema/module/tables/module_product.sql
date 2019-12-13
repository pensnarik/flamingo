create table module.module_product
(
    id              serial primary key,
    module          varchar not null,
    product_id      integer not null references shop.product(id) on delete cascade,
    is_exported     boolean not null default true
);

create unique index on module.module_product(module, product_id);

comment on table module.module_product is 'Product export settings for export modules';

alter table module.module_product owner to shop;
