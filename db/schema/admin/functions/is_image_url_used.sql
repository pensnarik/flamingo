create or replace
function admin.is_image_url_used(aurl varchar) returns boolean as $$
    select exists (select * from shop.product_image ip where ip.url = aurl);
$$ language sql security definer stable;

alter function admin.is_image_url_used(varchar) owner to shop;

comment on function admin.is_image_url_used(varchar)
    is 'Returns true if image URL is used in any product, call this function '
       'before deleting an image to ensure that file will not be lost';
