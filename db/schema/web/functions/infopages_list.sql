create or replace
function web.infopages_list() returns table
(
    url varchar
) as $$
    select p.url from shop.infopage p;
$$ language sql security definer stable;

alter function web.infopages_list() owner to shop;
