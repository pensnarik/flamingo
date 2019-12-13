create table shop.attribute_category
(
    id          serial primary key,
    name        text not null,
    description text
);

create unique index on shop.attribute_category(name);
