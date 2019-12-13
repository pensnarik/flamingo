create or replace
function admin.feedback_publish(aid integer) returns integer as $$
declare
    vid integer;
begin
    update shop.feedback
       set is_published = true
     where id = aid
    returning id into vid;

    return vid;
end;
$$ language plpgsql security definer;

alter function admin.feedback_publish(integer) owner to shop;
