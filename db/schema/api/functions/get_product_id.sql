CREATE OR REPLACE FUNCTION api.get_product_id(asku character varying)
 RETURNS integer
 LANGUAGE sql
 STABLE SECURITY DEFINER
AS $function$
    select p.id from shop.product p where p.sku = asku;
$function$
