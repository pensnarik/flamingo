create or replace
function admin.get_next_banner_id() returns integer as $$
    select nextval('admin.banner_image_seq')::integer;
$$ language sql security definer;
