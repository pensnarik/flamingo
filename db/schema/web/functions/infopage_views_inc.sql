create or replace
function web.infopage_views_inc(aurl varchar) returns integer as $$
declare
    vviews integer;
begin
    update shop.infopage
       set views = views + 1
     where url = aurl
    returning views into vviews;

    return vviews;
end;
$$ language plpgsql security definer;

alter function web.infopage_views_inc(varchar) owner to shop;
