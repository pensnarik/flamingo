create or replace
function shop.human_size_as_mb(ahuman_size varchar) returns integer as $$
    select regexp_replace(ahuman_size, '\D', '', 'g')::int *
           (case when position('Мб' in ahuman_size) > 0 then 1
                 when position('Гб' in ahuman_size) > 0 then 1024
            else 0 end)
$$ language sql stable;

alter function shop.human_size_as_mb(varchar) owner to shop;
