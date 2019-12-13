create or replace
function shop.category_path_as_arr(apath integer[]) returns text[] as $$
    select array_agg(c.name order by ordinality)
      from shop.category c
      join (select * from unnest(apath::int[]) with ordinality id) t using (id)
     where array[c.id] <@ apath;
$$ language sql security definer stable;

alter function shop.category_path_as_arr(integer[]) owner to shop;
