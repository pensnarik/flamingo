create or replace
function web.get_status_name(astatus t_order_status) returns varchar as $$
    select case when astatus = 'new' then 'Новый'
                when astatus = 'confirmed' then 'Подтвержден'
                when astatus = 'paid' then 'Оплачен'
                when astatus = 'closed' then 'Закрыт'
                when astatus = 'cancelled' then 'Отменен'
           else '?'
           end;
$$ language sql security definer immutable;
