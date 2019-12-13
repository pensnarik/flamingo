create or replace
function shop.get_new_sef_name
(
    aproduct_id integer,
    aname varchar
) returns varchar as $$
declare
    vsef_name varchar;
begin
    vsef_name := substring(web.sef_from_text(aname) for 126);

    if not exists (select * from shop.product where sef_name = vsef_name) then
        return vsef_name;
    else
        return null;
    end if;
end;
$$ language plpgsql stable;

alter function shop.get_new_sef_name(integer, varchar) owner to shop;
comment on function shop.get_new_sef_name(integer, varchar) is 'Returns new sef name for a product';
