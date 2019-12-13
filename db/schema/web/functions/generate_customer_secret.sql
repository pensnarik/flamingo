create or replace
function web.generate_customer_secret() returns char(32) as $$
    select array_to_string(array(select substr('0123456789abcdef', trunc(random() * 16)::integer + 1, 1) from generate_series(1, 32)), '');
$$ language sql;
