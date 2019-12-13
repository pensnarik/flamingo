create or replace
function admin.module_category_set
(
    amodule varchar,
    acategory_id integer,
    ais_exported boolean
) returns integer as $$
declare
    vid integer;
begin
    update module.module_category
       set is_exported = ais_exported
     where module = amodule
       and category_id = acategory_id
    returning id into vid;

    if not found then
        insert into module.module_category (module, category_id, is_exported)
        values (amodule, acategory_id, ais_exported)
        returning id into vid;
    end if;

    return vid;
end;
$$ language plpgsql security definer;

alter function admin.module_category_set(varchar, integer, boolean) owner to shop;
