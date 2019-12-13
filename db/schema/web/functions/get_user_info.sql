create or replace
function web.get_user_info(auser_id integer) returns table
(
    name varchar,
    email varchar,
    is_admin boolean
) as $$
    select u.name, u.email, u.is_admin
      from shop.system_user u
     where u.id = auser_id;
$$ language sql security definer stable;
