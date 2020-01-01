create or replace
function web.product_path_get(aid integer) returns integer[] as $$
    with recursive r as (
        select c.id, c.parent_id, 0 as level
          from shop.product_category pc
          join shop.category c on c.id = pc.category_id
         where product_id = aid
        union
        select c.id, c.parent_id, level + 1
          from shop.category c
          join r on r.parent_id = c.id
    ) select array_agg(id order by level desc) from r;
$$ language sql security definer stable;

alter function web.product_path_get(integer) owner to shop;


create or replace
function web.product_path_get_fast(aid integer) returns integer[] as $$
declare
  result integer[];
  vid integer; vparent_id integer;
begin
  select category_id into vid from shop.product_category where product_id = aid limit 1;

  if vid is null then
    return null;
  end if;

  result := array[vid];

  loop
    select parent_id, id
      into vparent_id, vid
      from shop.category c
     where c.id = vid;

    if vparent_id is not null then
      result := array[vparent_id] || result;
      vid := vparent_id;
    else
      exit;
    end if;
  end loop;

  return result;
end;
$$ language plpgsql;

create trigger tidu_product_category_fast
  AFTER INSERT OR DELETE OR UPDATE ON product_category
  FOR EACH ROW EXECUTE PROCEDURE tidu_product_category_fast();