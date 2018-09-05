-- Аренда квартир. Отбраковка: почасов., посуты., комнаты. Киев
UPDATE uvekon.re_advert_load
SET status = -1
WHERE id_segment = 1 AND id_subsegment = 2 AND id_type_oper = 2 
AND lower(advert_text) ~ '(посуточно|подобов|погодинн|почасов|нда комнат|дам комнат|сдается комнат|дається кімнат|ренду комнату|даётся комнат|комната для|сдам место|койко-мест|койка-мест|подселение)' 
AND status = 1 AND id_region = '80' AND price_uah < 6001

-- Аренда квартир. Отбраковка: цена < 3000 грн. Киев
UPDATE uvekon.re_advert_load
SET status = -1
WHERE id_segment = 1 AND id_subsegment = 2 AND id_type_oper = 2 
AND status = 1 AND id_region = '80' AND price_uah < 3001

UPDATE uvekon.re_advert_load
SET floor = replace(substring(floor,'[.,]{1}[\d]'), '.', '')
WHERE floor like '%.%'

UPDATE uvekon.re_advert_load
SET floor = -1
WHERE floor = 'цокольний'

UPDATE uvekon.re_advert_load
SET kitchen_area = ''
WHERE character_length(kitchen_area) > 4

UPDATE uvekon.re_advert_load
SET floor = -1
WHERE floor = 'цокольний'

UPDATE uvekon.re_advert_load
SET floor = replace(floor, ' ', '')
WHERE floor like '% %'


-- Простановка состояния "дублирование"  для дублей по коду объявления -- долго выполняется
update uvekon.re_advert_load l
set status=-9, reject_note='Дубликат объявления ID='||(
select id
from uvekon.re_advert_load_double t
where l.status <> -9
and t.agency=l.agency
and t.realty_kod=l.realty_kod
)||' с кодом объявления '||l.realty_kod 
where  exists (
select 1 from uvekon.re_advert_load_double t
where l.status <> -9
and t.agency=l.agency
and t.realty_kod=l.realty_kod
 and t.id<>l.id);

 -- Простановка состояния "дублирование"  по основным полям
update uvekon.re_advert_load l
set status=-9, reject_note='Дубликат объявления ID='||(
select id
from uvekon.re_advert_load_double t
where l.status <> -9
and t.agency=l.agency
and t.id_segment=l.id_segment
and t.id_subsegment=l.id_subsegment
and t.id_type_oper=l.id_type_oper
and t.id_region=l.id_region
and t.total_area_d=l.total_area_d
and t.currency_advert_d=l.currency_advert_d
and t.price_usd=l.price_usd
and t.advert_text=l.advert_text
) 
where exists (
select 1 from uvekon.re_advert_load_double t
where l.status <> -9
and t.agency=l.agency
and t.id_segment=l.id_segment
and t.id_subsegment=l.id_subsegment
and t.id_type_oper=l.id_type_oper
and t.id_region=l.id_region
and t.total_area_d=l.total_area_d
and t.currency_advert_d=l.currency_advert_d
and t.price_usd=l.price_usd
and t.advert_text=l.advert_text
 and t.id<>l.id);