create or replace
function admin.snippets_get() returns setof shop.snippet as $$
    select * from shop.snippet order by priority;
$$ language sql security definer stable;

alter function admin.snippets_get() owner to shop;
