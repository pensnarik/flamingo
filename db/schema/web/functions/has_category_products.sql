create or replace
function web.has_category_products(acategory_id integer) returns boolean as $$
    select exists (
        select *
          from shop.product p
         where array[acategory_id] <@ p.path
           and p.is_visible
           and p.dt_deleted is null
    );
$$ language sql security definer stable;