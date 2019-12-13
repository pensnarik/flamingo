create or replace
function admin.feedback_reject(aid integer) returns integer as $$
declare
    vid integer;
begin
    delete from shop.feedback where id = aid
    returning id into vid;

    return vid;
end;
$$ language plpgsql security definer;

alter function admin.feedback_reject(integer) owner to shop;
