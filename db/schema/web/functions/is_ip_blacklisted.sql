create or replace
function web.is_ip_blacklisted(aip inet) returns boolean as $$
    select exists (select * from shop.black_list l where l.ip >>= aip);
$$ language sql security definer stable;
