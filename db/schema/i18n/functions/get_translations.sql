create or replace
function i18n.get_translations
(
    aoriginal text
) returns table (
    id          integer,
    original    text,
    translation text,
    translator  text,
    is_manual   boolean
) as $$
    select t.id, t.original, t.translation, t.translator, true
      from i18n.translation_manual t
     where lower(t.original) like lower(aoriginal) || '%'
    union all
    select t.id, t.original, t.translation, t.translator, false
      from i18n.translation t
     where lower(t.original) like lower(aoriginal) || '%'
     order by 2;
$$ language sql security definer;
