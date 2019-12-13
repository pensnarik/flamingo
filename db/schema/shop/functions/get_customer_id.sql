create or replace
function shop.get_customer_id(acustomer_secret char(32)) returns integer as $$
    select id from shop.customer where secret = acustomer_secret;
$$ language sql;
