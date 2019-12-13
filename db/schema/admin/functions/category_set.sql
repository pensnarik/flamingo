-- drop function admin.category_set(integer, varchar, integer, boolean, integer);

create or replace
function admin.category_set
(
    aid integer,
    aname varchar,
    aparent_id integer,
    ais_exported boolean,
    asort_order integer
) returns integer as $$
declare
    vid integer;
begin
    if aid is null then
        insert into shop.category(name, parent_id, is_exported, sort_order)
        values (aname, aparent_id, ais_exported, asort_order)
        returning id into vid;
    else
        update shop.category
           set name = aname,
               parent_id = aparent_id,
               is_exported = ais_exported,
               sort_order = asort_order
         where id = aid
        returning id into vid;
    end if;

    return vid;
end;
$$ language plpgsql security definer;

comment on function admin.category_set(integer, varchar, integer, boolean, integer) is 'Creates or updates a category';

alter function admin.category_set(integer, varchar, integer, boolean, integer) owner to shop;
