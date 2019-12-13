create or replace
function api.product_json(asku varchar) returns json as $$
    select row_to_json(t.*)
      from (
        select p.name,
               m.name manufacturer,
               c.name category,
               p.sku,
               d.description,
               p.gtin,
               api.product_images_json(p.id) as images,
               api.product_attrs_json(p.id) as attributes,
               shop.category_path_as_text(p.path) as categories,
               api.product_groups_json(p.id) as groups
          from shop.product p
          join shop.manufacturer m
            on m.id = p.manufacturer_id
          left join shop.product_description d
            on d.product_id = p.id
          left join shop.product_category pc
            on pc.product_id = p.id
          left join shop.category c
            on c.id = pc.category_id
         where p.sku = asku
        ) t;
$$ language sql security definer stable;

alter function api.product_json(varchar) owner to shop;
