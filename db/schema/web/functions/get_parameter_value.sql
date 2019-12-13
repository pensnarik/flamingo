create or replace
function web.get_parameter_value(aparameter varchar) returns text as $$
	select value from shop.config where parameter = aparameter;
$$ language sql security definer stable;
