create or replace
function web.infopage_get(aurl varchar) returns text as $$
    select p.code from shop.infopage p where url = aurl;
$$ language sql security definer stable;

alter function web.infopage_get(varchar) owner to shop;
