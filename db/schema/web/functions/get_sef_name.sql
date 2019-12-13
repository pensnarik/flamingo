create or replace
function web.get_sef_name(aname varchar) returns varchar as $$
    select replace(lower(aname), ' ', '-');
$$ language sql;

alter function web.get_sef_name(varchar) owner to shop;
