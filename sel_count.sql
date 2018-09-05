select count(*)
from uvekon.re_advert_load
where agency='LUN'
and base_url like '%продаж-квартир%'

insert into uvekon.re_advert_load
select * from uvekon.re_advert_load1
where date_insert>=TO_DATE('03.11.2017','DD.MM.YYYY')



select count(*), region 
from uvekon.re_advert_load
where agency='LUN'
and base_url like '%продаж-квартир%'
group by region
order by region

select count(*), region 
from uvekon.re_advert_load
where agency='OLX'
and segment like 'Продаж квартир%'
group by region
order by region




select count(*)
from uvekon.re_advert_load
WHERE id_region is null

select count(*)
from uvekon.re_advert_load

select count(*)
from uvekon.re_advert_load
where agency='LUN'
and base_url like '%продаж-будинк%'


select count(*), region 
from uvekon.re_advert_load
where agency='LUN'
and base_url like '%продаж-будинк%'
group by region
order by region

select count(*)
from uvekon.re_advert_load
where agency='OLX'
and base_url like '%prodazha-domov%'


select count(*), region 
from uvekon.re_advert_load
where agency='OLX'
and base_url like '%prodazha-domov%'
group by region
order by region


select count(*)
from uvekon.re_advert_load
where agency='OLX'
and base_url like '%prodazha-zemli%'


select count(*), region 
from uvekon.re_advert_load
where agency='OLX'
and base_url like '%prodazha-zemli%'
group by region
order by region

select count(*)
from uvekon.re_advert_load
where agency='OLX'
and base_url like '%prodazha-pomescheniy%'


select count(*), region 
from uvekon.re_advert_load
where agency='OLX'
and base_url like '%prodazha-pomescheniy%'
group by region
order by region








update uvekon.re_agency_url u
set count_load=(
select count(*) from 
uvekon.re_advert_load l
where agency='LUN'
and region like '%крим%'
--and region like '%'||lower(u.note)||'%'
---and region like '%'||lower(substr(u.note,1,5))||'%'
)
where  id_url_sq=125000 --between 100000 and 200000   
and url not like '%?%'

select id_url_sq,note,count_load,count_advert 
from uvekon.re_agency_url 
where  id_url_sq between 100000 and 200000   
and url not like '%?%'
order by 1



select * ---count(*)
from uvekon.re_advert_load
where agency='OLX'
--and base_url like '%novostr%'
--and segment='Первинний ринок квартир' 
--and subsegment is not null
--and base_url like '%prodazha-pomescheniy-svobodnogo-naznacheniya%'
and subsegment='Продаж приміщень вільного призначення'
and region like '%Крим%'


select *
from uvekon.re_advert_load1
where agency='LUN'
--and realty_kod='155239'
limit 100

select count(*),realty_kod
from uvekon.re_advert_load
where agency='OLX'
group by realty_kod
having count(realty_kod)>1

select count(*)
from uvekon.re_advert_load1
where agency='LUN'
and coordinate_n <>''


select count(*)
from uvekon.re_advert_load1
where agency='LUN'
and base_url like '%продаж-квартир%'
and coordinate_n <>''



select count(*),l.region from 
uvekon.re_advert_load l,uvekon.re_agency_url u
where l.agency='LUN'
and l.region like '%'||lower(u.note)||'%'
and u.id_url_sq between 100000 and 200000   
and u.url not like '%?%'
group by l.region




select count(*), region 
from uvekon.re_advert_load
where agency='OLX'
and segment like '%продаж квартир%'
group by region
order by region

select count(*), region 
from uvekon.re_advert_load1
where agency='OLX'
and base_url like '%novostr%'
group by region
order by region






select *
from uvekon.re_advert_load1
where region='таїрове'

update uvekon.re_advert_load1
set region='Одеська область',
name_np='таїрове',
address='таїрове'
where region='таїрове'

update uvekon.re_advert_load1
set region='вінницька область'
where region like '%вінниця%'
and region<>'вінницька область'


"таїрове"



select count(*)
from uvekon.re_advert_load1
where agency='LUN'
and base_url like '%продаж-квартир%'

select count(*), region 
from uvekon.re_advert_load1
where agency='LUN'
and base_url like '%продаж-квартир%'
group by region


select count(distinct realty_kod)
from uvekon.re_advert_load1
where agency='LUN'
and base_url like '%продаж-будинків%'

select count(*)
from uvekon.re_advert_load
where agency='LUN'
and base_url like '%продаж-будинків%'
and coordinate_n <>''


select count(*), region 
from uvekon.re_advert_load1
where agency='LUN'
and base_url like '%продаж-будинків%'
group by region


select count(*)
from uvekon.re_advert_load
where agency='LUN'
and base_url like '%оренда-квартир%'

select count(*), region 
from uvekon.re_advert_load1
where agency='LUN'
and base_url like '%оренда-квартир%'
group by region



select count(*)
from uvekon.re_advert_load1
where agency='OLX'
and base_url like '%prodazha-kvartir%'

select count(*), region 
from uvekon.re_advert_load1
where agency='OLX'
and base_url like '%prodazha-kvartir%'
group by region





select count(*),max(date_insert),realty_kod
from uvekon.re_advert_load1
where agency='OLX'
group by realty_kod
having count(realty_kod)>1

select count(*)
from (
select count(*),max(date_insert),realty_kod
from uvekon.re_advert_load1
where agency='LUN'
--and base_url like '%prodazha-domov%'
group by realty_kod
having count(realty_kod)>1
) t

select count(*)
from uvekon.re_advert_load1
where agency='OLX'
and base_url like '%prodazha-domov%'

select *
from uvekon.re_advert_load1
where agency='OLX'
and base_url like '%prodazha-domov%'
limit 100



select count(*), region 
from uvekon.re_advert_load1
where agency='OLX'
and base_url like '%prodazha-domov%'
group by region


select count(*)
from  uvekon.re_agency_url


---------------------------------------
копирование 
--------------------------

insert into uvekon.re_advert_load1
(
  agency,
  realty_kod,
  date_advert,
  segment,
  region,
  region_district,
  name_np,
  address,
  price_advert,
  currency_advert,
  qt_room,
  floor,
  qt_floor,
  total_area,
  living_area,
  kitchen_area,
  land_area,
  wall_material,
  build_year,
  advert_url,
  coordinate_n,
  coordinate_e,
  street,
  house,
  district,
  mikrodistrict,
  primary_agency,
  status,
  date_insert,
  base_url, 
  price_typ,
  addr_all,
  id_segment,
  id_subsegment,
  id_type_oper,
  id_size_object,
  id_class_subsegment,
  id_region,
  koatuu_code,
  id_kotuu_district,
  date_advert_d,
  price_advert_d,
  currency_advert_d,
  price_uah,
  price_usd,
  total_area_d,
  price_1sq_meter_uah,
  price_1sq_meter_usd,
  subsegment,
  id_wall_material,
  reject_note,
  advert_text
)
select 
  agency,
  realty_kod,
  date_advert,
  segment,
  region,
  region_district,
  name_np,
  address,
  price_advert,
  currency_advert,
  qt_room,
  floor,
  qt_floor,
  total_area,
  living_area,
  kitchen_area,
  land_area,
  wall_material,
  build_year,
  advert_url,
  coordinate_n,
  coordinate_e,
  street,
  house,
  district,
  mikrodistrict,
  primary_agency,
  status,
  date_insert,
  base_url, 
  price_typ,
  addr_all,
  id_segment,
  id_subsegment,
  id_type_oper,
  id_size_object,
  id_class_subsegment,
  id_region,
  koatuu_code,
  id_kotuu_district,
  date_advert_d,
  price_advert_d,
  currency_advert_d,
  price_uah,
  price_usd,
  total_area_d,
  price_1sq_meter_uah,
  price_1sq_meter_usd,
  subsegment,
  id_wall_material,
  reject_note,
  advert_text
--select count(*)  
  from uvekon.re_advert_load2 l2
where not exists (select 1 from
uvekon.re_advert_load1 l1  where 
l1.realty_kod=l2.realty_kod)

-- agency='OLX'
--and not base_url like '%prodazha-kvartir%'

--------------

update uvekon.re_advert_load1
set id_class_subsegment=11
where id_class_subsegment is null
and agency='OLX'
and subsegment='Продаж окремо розташованих будівель';

---- удаление дублей OLX
delete from uvekon.re_advert_load1 l
where  exists (select 1 from 
(
select count(*),max(id) id,realty_kod
from uvekon.re_advert_load1
where agency='LUN'
and segment='Продаж квартир'
group by realty_kod
having count(realty_kod)>1) t
where t.realty_kod=l.realty_kod
 and t.id<>l.id)



select * ---count(*)
from uvekon.re_advert_load
where agency='OLX'
and base_url like '%prodazha-domov%'
limit 1000

and id_region is null


update  uvekon.re_advert_load
set id_segment=1,
id_subsegment=3,
id_type_oper=1
where agency='OLX'
and base_url like '%prodazha-domov%'


"https://www.olx.ua/uk/nedvizhimost/prodazha-domovЛуганська область"


select region,trim(region,'https://www.olx.ua/uk/nedvizhimost/prodazha-domov')
from uvekon.re_advert_load
where agency='OLX'
and base_url like '%prodazha-domov%'
limit 100

update  uvekon.re_advert_load
set region=trim(region,'https://www.olx.ua/uk/nedvizhimost/prodazha-domov')
where agency='OLX'
and base_url like '%prodazha-domov%'


select count(*)
from uvekon.re_advert_load1
where agency='OLX'
and base_url like '%arenda-kvartir%'
and koatuu_code is not null
limit 100

update  uvekon.re_advert_load
set region=trim(region,'https://www.olx.ua/uk/nedvizhimost/arenda-kvartir')
where agency='OLX'
and base_url like '%arenda-kvartir%'

update  uvekon.re_advert_load
set id_segment=1,
id_subsegment=2,
id_type_oper=2
where agency='OLX'
and base_url like '%arenda-kvartir%' 
----------------------------------------------------------------
select count(*)
from uvekon.re_advert a
where a.date_relevance=TO_DATE('31.08.2017','DD.MM.YYYY')
and a.koatuu_code is null
and a.realty_kod is not null



select count(*)
from uvekon.re_advert a,uvekon.re_advert_load8 a8
where a.date_relevance=TO_DATE('31.08.2017','DD.MM.YYYY')
and a.koatuu_code is null
--and a.id_agency=a8.id_agency
and a.realty_kod=a8.realty_kod
and a8.id_region is not null
--and a8.id_kotuu_district is not null

--select id_kotuu_district||'00000'
--from uvekon.re_advert_load8 

update uvekon.re_advert_load8 
set koatuu_code = id_kotuu_district||'00000'
where koatuu_code is null
and id_kotuu_district is not null

--select id_region||'00000000'
--from uvekon.re_advert_load8 
update uvekon.re_advert_load8 
set koatuu_code = id_region||'00000000'
where koatuu_code is null
and id_region is not null


update uvekon.re_advert_load8 
set koatuu_code = '3200000000'
where koatuu_code is null
and advert_url like '%київсь%'


update uvekon.re_advert_load8 
set koatuu_code = '3200000000'
where koatuu_code is null
and advert_url like '%київсь%'


update uvekon.re_advert_load8 
set koatuu_code = '0100000000'
where koatuu_code is null
and upper(addr_all) like '%КРИМ%'

update uvekon.re_advert_load8 
set koatuu_code = '8000000000'
where koatuu_code is null
and upper(region) like '%КИЇВ%'

8000000000



select count(*)--,min(a.id_re_advert_sq),max(a.id_re_advert_sq)
from uvekon.re_advert a,uvekon.re_advert_load8 a8,uvekon.re_agency ag
where a.date_relevance=TO_DATE('31.08.2017','DD.MM.YYYY')
and a.koatuu_code is null
and ag.name=a8.agency 
and ag.id_agency=a.id_agency
and a.realty_kod=a8.realty_kod
--and a8.koatuu_code is not null
--and a.id_re_advert_sq< 2350410


update uvekon.re_advert a
set koatuu_code =
(select a8.koatuu_code
from uvekon.re_advert_load8 a8,uvekon.re_agency ag
where a.realty_kod=a8.realty_kod
and ag.name=a8.agency 
and ag.id_agency=a.id_agency)
where a.date_relevance=TO_DATE('31.08.2017','DD.MM.YYYY')
and a.koatuu_code is null
---and a.id_re_advert_sq< 2750410

select * ---count(*)
from uvekon.re_advert_load8 a8
where koatuu_code is null
and status=1
limit 100

update uvekon.re_advert_load8
set koatuu_code='5310100000'
where upper(name_np) like '%ПОЛТАВА%'
and koatuu_code is null


update uvekon.re_advert_load8
set koatuu_code='4810100000'
where upper(name_np) like '%МИКОЛАЇВ%'
and koatuu_code is null

update uvekon.re_advert_load8
set koatuu_code='6510100000'
where upper(name_np) like '%ХЕРСОН%'
and koatuu_code is null

update uvekon.re_advert_load8
set koatuu_code='3222481601'
where upper(name_np) like '%ГАТНЕ%'
and koatuu_code is null

update uvekon.re_advert_load8
set koatuu_code='3520886403'
where upper(name_np) like '%МАРІУПОЛЬ%'
and koatuu_code is null

update uvekon.re_advert_load8
set koatuu_code='3222486201'
where upper(name_np) like '%'||upper('Софіївська Борщагівка')||'%'
and koatuu_code is null


update uvekon.re_advert_load8
set koatuu_code='5123755800'
where upper(name_np) like '%ТАЇРОВЕ%'
and koatuu_code is null


select count(*)
from uvekon.re_advert_load
where agency='OLX'
and base_url like '%prodazha-zemli%'


select count(*),region,subsegment
from uvekon.re_advert_load
where agency='OLX'
and base_url like '%prodazha-zemli%'
group by region,subsegment


limit 100


select cast(substr('123456',1,2)||'.'||substr('123456',3,10) AS double precision) 


select count(*)
from uvekon.re_advert_load
where agency='OLX'
and base_url like '%novostr%' 


select *
from uvekon.re_advert_load
where agency='OLX'
and base_url like '%novostr%' 
limit 1000

select count(*) from uvekon.re_advert_load
where id_segment is null


Добавить механизм обработки дубликатов. Варианты реализации: 
1. поиск объявлений где на 100% совпадают поля из блоков Размерность и Цена, 
а текст объявления совпадает на 85...100%. => 
2. самое свежее из таких объявлений (с датой обнаружения ближайшей к дате выгрузки) 
принимает статус "Обработан", если удовлетворяет существующим критериям отбраковки или "Отбракован". 
3. оставшемуся объявлению (или нескольким) присваивается статус "Дубликат" 
(такой статус предполагается добавить в список существующих фильтров)    

select count(*)
from (
select count(*),max(date_advert),
agency,id_segment,id_subsegment,id_type_oper,id_region,
total_area_d
currency_advert_d,price_usd,advert_text
--,uvekon.get_difference()
from uvekon.re_advert_load
--where agency='LUN'
--and base_url like '%prodazha-domov%'
group by agency,id_segment,id_subsegment,id_type_oper,id_region,
total_area_d,currency_advert_d,price_usd,advert_text
having count(id)>1
) t


select *
from (
select count(*),max(id) id,
agency,id_segment,id_subsegment,id_type_oper,id_region,
total_area_d,
currency_advert_d,price_usd,advert_text
--,uvekon.get_difference()
from uvekon.re_advert_load
group by agency,id_segment,id_subsegment,id_type_oper,id_region,
total_area_d,currency_advert_d,price_usd,advert_text
having count(id)>1
) t
limit 100



update uvekon.re_advert_load l
set status=-9
where  exists (select 1 from 
(
 select count(*),max(id) id,
 agency,id_segment,id_subsegment,id_type_oper,id_region,
 total_area_d,currency_advert_d,price_usd,advert_text
 from uvekon.re_advert_load
 group by agency,id_segment,id_subsegment,id_type_oper,id_region,
 total_area_d,currency_advert_d,price_usd,advert_text
 having count(id)>1) t
where t.agency=l.agency
and t.id_segment=l.id_segment
and t.id_subsegment=l.id_subsegment
and t.id_type_oper=l.id_type_oper
and t.id_region=l.id_region
and t.total_area_d=l.total_area_d
and t.currency_advert_d=l.currency_advert_d
and t.price_usd=l.price_usd
and t.price_usd=l.price_usd
and t.advert_text=l.advert_text
 and t.id<>l.id)

-----------
update uvekon.re_advert_load l
set status=-9, reject_note='Дубликат объявления ID='||(
select id
from (
select count(*),max(id) id,
 agency,id_segment,id_subsegment,id_type_oper,id_region,
 total_area_d,currency_advert_d,price_usd,advert_text
 from uvekon.re_advert_load
 group by agency,id_segment,id_subsegment,id_type_oper,id_region,
 total_area_d,currency_advert_d,price_usd,advert_text
 having count(id)>1) t
where t.agency=l.agency
and t.id_segment=l.id_segment
and t.id_subsegment=l.id_subsegment
and t.id_type_oper=l.id_type_oper
and t.id_region=l.id_region
and t.total_area_d=l.total_area_d
and t.currency_advert_d=l.currency_advert_d
and t.price_usd=l.price_usd
and t.advert_text=l.advert_text
) 
where  exists (select 1 from 
(
 select count(*),max(id) id,
 agency,id_segment,id_subsegment,id_type_oper,id_region,
 total_area_d,currency_advert_d,price_usd,advert_text
 from uvekon.re_advert_load
 group by agency,id_segment,id_subsegment,id_type_oper,id_region,
 total_area_d,currency_advert_d,price_usd,advert_text
 having count(id)>1) t
where t.agency=l.agency
and t.id_segment=l.id_segment
and t.id_subsegment=l.id_subsegment
and t.id_type_oper=l.id_type_oper
and t.id_region=l.id_region
and t.total_area_d=l.total_area_d
and t.currency_advert_d=l.currency_advert_d
and t.price_usd=l.price_usd
and t.advert_text=l.advert_text
 and t.id<>l.id)

SELECT substring(substring(advert_url,'-[^-]+?$'),2,100) np1,
substring(substring(advert_url,'/[^/]+?$'),2,100) np2,
substring(substring(advert_url,'-[^-]+?$'),2,50) np3,
* 
from uvekon.re_advert_load
WHERE agency='LUN'
and region='Київ'
and segment='Первинний ринок квартир'
and name_np not like'%київ%'


update uvekon.re_advert_load
set name_np='київ'
WHERE agency='LUN'
and region='Київ'
and segment='Первинний ринок квартир'
and name_np not like'%київ%'

select TO_DATE('03.06.2017','DD.MM.YYYY')+180

--Добавить фильтр в табл урлов
update uvekon.re_agency_url
set url=url||'&updateTime=month'
where id_url_sq between 300000 and 400000

--Поиск в радиусе (postgres user)
wkt_geom	id_re_advert_sq	date_relevance	id_agency	realty_kod	date_advert	id_segment	id_subsegment	id_class_subsegment	id_size_object	id_type_oper	price_advert	currency_advert	price_uah	price_usd	qt_room	floor	qt_floor	total_area	living_area	kitchen_area	id_wall_material	contact_person	advert_text	advert_url	koatuu_code	street	house	coordinate_set_way	id_district	id_mikrodistrict	primary_agency	is_valid	id_metro	time_to_metro	price_1sq_meter_uah	price_1sq_meter_usd	land_area	id_poligon_level_1	id_poligon_level_2	id_poligon_level_3	id_poligon_level_4	time_exposition	ln_price_usd	ln_price_1sq_meter_usd	year_building	distance_to_city	bathroom	heating	renovation	comfort	communications	infrastructure	landscape	furnishing	household_appliances	multimedia	apartment_layout	building_class	cadastral_number	buildings_on_land	wall_insulation	roof_type	room_height	type_offer	number_of_views	type_obj	id_build_type_u
Point (23.93270111 49.87628998999999652)	10116341	2018-04-30	2	295859506	2018-04-09	1	2	1	1	1	35000.00	840	916846	35000	1	5	9	41		9	2		Продам квартиру Замена окон дверей сантехники газовый счочик	https://www.olx.ua/uk/obyavlenie/prodam-kvartiru-IDk1ozv.html#071719243e	4610100000			1	279			True			22362.1	853.66		12	1209	1209003	1209000082		10.46310334047155	6.74953298805149																				Приватної особи	5514		
select * from uvekon.re_advert
 where earth_distance(
 ll_to_earth(cast (coordinate_n as  numeric), cast (coordinate_e as numeric)), 
 ll_to_earth(cast('50.2051751505' as  numeric), cast ('37.0497766826' as numeric)))<10000
 and coordinate_e <>''
and coordinate_n <>''
AND date_relevance = to_date('31.12.2017', 'DD.MM.YYYY')
AND id_segment = 1 
AND id_subsegment = 2 
AND id_type_oper = 1;

-- добавление полей логарифмов
update uvekon.re_advert
set ln_price_usd=LN(price_usd)
where price_usd > 0;

update uvekon.re_advert
set ln_price_1sq_meter_usd=LN(price_1sq_meter_usd)
where price_1sq_meter_usd > 0;

--размер базы
SELECT pg_size_pretty( pg_database_size( 'gis' ) );

SELECT 
    relname AS "table_name", 
    (relpages*8)/1024 AS "size_in_MB" 
FROM 
    pg_class 
ORDER BY 
    relpages DESC 
LIMIT 
    50;
-- 	Новые поля (логонорм. распред.)--
-- 1)	Средняя стоимость в $ (логонорм. распред.)
update uvekon.re_aggregate_info
set avg_cost_usd_log=exp(avg_ln_price_usd+((std_ln_price_usd^2)/2))
where avg_cost_usd_log is null
and avg_ln_price_usd <> 0
and std_ln_price_usd > 0
and count_advert > 2;
-- 2)	Средняя цена в $ (логонорм. распред.)
update uvekon.re_aggregate_info
set avg_price_usd_log=exp(avg_ln_price_1sq_meter_usd+((std_ln_price_1sq_meter_usd^2)/2))
where avg_price_usd_log is  null
and avg_ln_price_1sq_meter_usd <> 0
and std_ln_price_1sq_meter_usd > 0
and count_advert > 2;
-- 3)	Медиана стоимости объекта в $ (логонорм. распр.)
update uvekon.re_aggregate_info
set median_cost_usd_log=exp(avg_ln_price_usd)
where median_cost_usd_log is null
and avg_ln_price_usd <> 0
and count_advert > 2;
-- 4)	Медиана цены м2 в $ (логонорм. распр.)
update uvekon.re_aggregate_info
set median_price_usd_log=exp(avg_ln_price_1sq_meter_usd)
where median_price_usd_log is null
and avg_ln_price_1sq_meter_usd <> 0
and count_advert > 2;
-- 5)	Мода стоимости объекта в $ (логонорм. распр.)
update uvekon.re_aggregate_info
set moda_coast_usd_log=exp(avg_ln_price_usd-(std_ln_price_usd^2))
where moda_coast_usd_log is null
and avg_ln_price_usd <> 0
and std_ln_price_usd > 0
and count_advert > 2;
-- 6)	Мода цены м2 в $ (логонорм. распр.)
update uvekon.re_aggregate_info
set moda_price_usd_log=exp(avg_ln_price_1sq_meter_usd-(std_ln_price_1sq_meter_usd^2))
where moda_price_usd_log is null
and avg_ln_price_usd <> 0
and std_ln_price_usd > 0
and count_advert > 2;
-- 7)	Среднеквадратическое отклонение стоимости в $ (логонорм. распр.) 
update uvekon.re_aggregate_info
set std_cost_usd_log = |/((exp(std_ln_price_usd ^ 2) -1)*exp((2 * avg_ln_price_usd) + std_ln_price_usd ^ 2))
where std_cost_usd_log is null
and avg_ln_price_usd <> 0
and std_ln_price_usd > 0
and count_advert > 4;
-- 8)	Среднеквадратическое отклонение цены м2 в $ (логонорм. распр.) 
update uvekon.re_aggregate_info
set std_price_usd_log = |/((exp(std_ln_price_1sq_meter_usd ^ 2) - 1)*exp((2 * avg_ln_price_1sq_meter_usd) + std_ln_price_1sq_meter_usd ^ 2))
where std_price_usd_log is null
and avg_ln_price_1sq_meter_usd <> 0
and std_ln_price_1sq_meter_usd > 0
and count_advert > 4;
-- 9)	Коэфф. Асимметрии выборки для стоимости (логонорм. распр.)
update uvekon.re_aggregate_info
set k_skew_cost_usd_log=(exp(std_ln_price_usd^2)+2) * |/((exp(std_ln_price_usd^2)-1))
where k_skew_cost_usd_log is null
and std_ln_price_usd > 0 and std_ln_price_usd <= 2
and count_advert > 2;
-- 10)	Коэфф. Асимметрии выборки для цены м2 (логонорм. распр.)
update uvekon.re_aggregate_info
set k_skew_price_usd_log=(exp(std_ln_price_1sq_meter_usd^2)+2) * |/((exp(std_ln_price_1sq_meter_usd^2)-1))
where k_skew_price_usd_log is null
and std_ln_price_1sq_meter_usd > 0 and std_ln_price_1sq_meter_usd <= 2
and count_advert > 2;
-- 11)	95-% доверительный интервал стоимости объекта в $ (логонорм. распр.)
update uvekon.re_aggregate_info
set d_int_cost_usd_log=1.96*(std_cost_usd_log/(|/count_advert))
where d_int_cost_usd_log is null
and std_cost_usd_log > 0
and count_advert > 2;
-- 12)	95-% доверительный интервал цены м2 в $ (логонорм. распр.)
update uvekon.re_aggregate_info
set d_int_price_usd_log=1.96*(std_price_usd_log/(|/count_advert))
where d_int_price_usd_log is null
and std_price_usd_log > 0
and count_advert > 2;
-- 13)  Точность средних значения стоимости объекта (%) (логонорм. распр.)
update uvekon.re_aggregate_info
set accuracy_cost_log=(1-((d_int_cost_usd_log+d_int_cost_usd_log*(1+k_skew_cost_usd_log))/avg_cost_usd_log))*100
where accuracy_cost_log is null
and avg_cost_usd_log > 0
and count_advert > 2;
-- 14)  Точность средних значений цены м2 (%) (логонорм. распр.)
update uvekon.re_aggregate_info
set accuracy_price_log=(1-((d_int_price_usd_log+d_int_price_usd_log*(1+k_skew_price_usd_log))/avg_price_usd_log))*100
where accuracy_price_log is null
and avg_price_usd_log > 0
and count_advert > 2;

-- 	Новые поля (норм. распред.)--

-- 15-16)	95-% доверительный интервал стоимости объекта и цены м *(норм. распр.)
update uvekon.re_aggregate_info
set d_int_cost_usd_norm=1.96*(std_cost_usd_norm/(|/count_advert)),
	d_int_price_usd_norm=1.96*(std_price_usd_norm/(|/count_advert))
where std_cost_usd_norm > 0
and std_price_usd_norm > 0
and count_advert > 2;

-- 17-18)  Точность средних значения стоимости объекта и цены м2(%) *(норм. распр.)
update uvekon.re_aggregate_info
set accuracy_cost_norm=(1-(d_int_cost_usd_norm*2/price_object_usd))*100,
	accuracy_price_norm=(1-(d_int_price_usd_norm*2/price_1sq_meter_usd))*100
where d_int_cost_usd_norm is not null
and d_int_price_usd_norm > is not null
and count_advert > 2;

-- 19-20) Среднея минимальная и средняя максимальная цена *(норм)
update uvekon.re_aggregate_info
set avg_min_price_usd=price_1sq_meter_usd-std_price_usd_norm
where std_price_usd_norm is not null
and price_1sq_meter_usd-std_price_usd_norm > min_1sq_meter_usd*1.1
and count_advert > 2;

update uvekon.re_aggregate_info
set avg_min_price_usd=min_1sq_meter_usd*1.1
where std_price_usd_norm is not null
and price_1sq_meter_usd-std_price_usd_norm < min_1sq_meter_usd*1.1
and count_advert > 2;

update uvekon.re_aggregate_info
set avg_max_price_usd=price_1sq_meter_usd+2*std_price_usd_norm
where std_price_usd_norm is not null
and price_1sq_meter_usd+2*std_price_usd_norm < max_1sq_meter_usd*0.9
and count_advert > 2;

update uvekon.re_aggregate_info
set avg_max_price_usd=max_1sq_meter_usd*0.9
where std_price_usd_norm is not null
and price_1sq_meter_usd+2*std_price_usd_norm > max_1sq_meter_usd*0.9
and count_advert > 2;

------------------------------------------------
-- Обрезка регексп по н символов -  ^.{0,14}\w\b
------------------------------------------------
-- Обработка дат DOM.RIA
update uvekon.re_advert_load
set date_advert0=substring(date_advert0,'[\d.]+')
WHERE agency = 'DOM.RIA'

-- обработка дат DOM.RIA
update uvekon.re_advert_load
set date_advert_d=TO_DATE(date_advert,'DD.MM.YYYY')
where substring(date_advert,'^[\d]{4,4}') is null
and substring(date_advert,'^[\d]{2,}')<>''
and agency='DOM.RIA';

--Заполнение пустых дат актуальности. DOM.RIA
update uvekon.re_advert_load
set date_advert_d=date_advert0_d
where date_advert_d is null
and agency='DOM.RIA';

-- Простановка общей площади участков с  DOM.RIA
update uvekon.re_advert_load
set total_area_d=(case 
when units_land_area like 'сот%' or units_land_area = '' or units_land_area is null then total_area
when units_land_area = 'Га (гектар)' then total_area*100
when units_land_area = 'кв. м' then total_area/100
else null end)
where subsegment like 'Земля%' or subsegment like 'Ділянка%'
and agency = 'DOM.RIA';

-- Обработка площади участков с DOM.RIA
update uvekon.re_advert_load
set land_area=(case 
when units_land_area like 'сот%' or units_land_area = '' or units_land_area is null then land_area
when units_land_area = 'Га (гектар)' then land_area*100
when units_land_area = 'кв. м' then land_area/100
else null end)
where subsegment not like 'Земля%' or subsegment not like 'Ділянка%'
and agency = 'DOM.RIA';

--Жилая недвижимость. Домовладения. Сегментация. OLX
update uvekon.re_advert_load
set id_class_subsegment=(case 
when subsegment = 'Будинок' then 3
when subsegment = 'Котедж' or subsegment = 'Клубний будинок' or subsegment ='Дуплекс' then 15
when subsegment = 'Дача' then 5
when subsegment = 'Таунхаус' then 6
when subsegment = 'Частина будинку' then 4
when year_building = 'На етапі будівництва' then 17
else null end)
where agency in ('OLX')
and id_type_oper=1
and id_segment=1
and id_subsegment=3;


--Коммерческая недвижимость. Сегментация. Продажа-Аренда. Офисы. OLX
update uvekon.re_advert_load
set id_subsegment=4
where agency='OLX'
and subsegment='Офісні приміщення';

-- Коммерческая недвижимость. Сегментация. Продажа-Аренда. Офисы: отдельные здания. DOM.RIA
update uvekon.re_advert_load
set id_class_subsegment=(case 
when subsegment = 'Офісні будівлі' and type_obj = 'бізнес-центр' or type_obj = 'торгівельно-офісний центр' then 9
when subsegment = 'Офісні будівлі' and type_obj = 'адміністративна будівля' or type_obj = 'жилой фонд' or type_obj = 'нежитлове приміщення в житловому будинку' then 7
else 7 end)
where agency='DOM.RIA'
and id_segment=2
and id_subsegment=4;

-- Коммерческая недвижимость. Сегментация. Продажа-Аренда. Офисы: помещения. DOM.RIA
update uvekon.re_advert_load
set id_class_subsegment=(case 
when subsegment = 'Офісні приміщення' or subsegment = 'Офисные помещения' and total_area_d < 500 then 8
when subsegment = 'Офісні приміщення' or subsegment = 'Офисные помещения' and total_area_d > 500 and type_obj = 'адміністративна будівля' or type_obj = 'жилой фонд' or type_obj = 'нежитлове приміщення в житловому будинку' then 7
else 9 end)
where agency='DOM.RIA'
and id_segment=2
and id_subsegment=4;


--Коммерческая недвижимость. Сегментация. Продажа-Аренда. Гостиничная. OLX
update uvekon.re_advert_load
set id_subsegment=10
where agency='OLX'
and subsegment='База відпочинку, готель';

--Коммерческая недвижимость. Сегментация. Продажа-Аренда. Гостиничная. DOM.RIA
update uvekon.re_advert_load
set id_subsegment=10
where agency='DOM.RIA'
and subsegment='Готель'
or subsegment='База відпочинку, пансіонат';

--Коммерческая недвижимость. Сегментация. Продажа-Аренда. Торговая. МАФы. OLX
update uvekon.re_advert_load
set id_subsegment=5,id_class_subsegment=16
where agency='OLX'
and subsegment='МАФ (мала архітектурна форма)'
or subsegment='Торгова точка на ринку'
or type_obj='Ринок' or type_obj='Торговий майданчик';

--Коммерческая недвижимость. Сегментация. Продажа-Аренда. Торговая. OLX
update uvekon.re_advert_load
set id_subsegment=5
where agency='OLX'
and subsegment='Магазин, салон'
or subsegment='Ресторан, кафе, бар'
or subsegment='Кав''ярня'
or type_obj='Торговий центр';

--Коммерческая недвижимость. Сегментация. Продажа-Аренда. Торговая. DOM.RIA
update uvekon.re_advert_load
set id_subsegment=5
where agency='DOM.RIA'
and subsegment='Торгові площі'
or subsegment='Кафе, бар, ресторан'
or subsegment='Об''єкт сфери послуг';

--Коммерческая недвижимость. Сегментация. Продажа-Аренда. Промышленная недвижимость. OLX
update uvekon.re_advert_load
set id_subsegment=6,id_class_subsegment=13
where agency='OLX'
and subsegment='Приміщення промислового призначення'
or subsegment='АЗС'
or subsegment='Автомийка'
or subsegment='Шиномонтаж'
or subsegment='СТО (станція тех. обслуговування)'
or subsegment='Фермерське господарство';

--Коммерческая недвижимость. Сегментация. Продажа-Аренда. Складская недвижимость. OLX
update uvekon.re_advert_load
set id_subsegment=6,id_class_subsegment=14
where agency='OLX'
and subsegment='Склад, ангар';

--Коммерческая недвижимость. Сегментация. Продажа-Аренда. Промышленная недвижимость. DOM.RIA
update uvekon.re_advert_load
set id_subsegment=6,id_class_subsegment=13
where agency='DOM.RIA'
and subsegment='Виробничі приміщення'

--Коммерческая недвижимость. Сегментация. Продажа-Аренда. Складская недвижимость. DOM.RIA
update uvekon.re_advert_load
set id_subsegment=6,id_class_subsegment=14
where agency='DOM.RIA'
and subsegment='Складські приміщення';

--Коммерческая недвижимость. Сегментация. Продажа-Аренда. Свободное назначение... в прочее. OLX
update uvekon.re_advert_load
set status=3
where agency='OLX'
and subsegment='Приміщення вільного призначення'
or subsegment='Окремі будівлі'
or subsegment='Частина будівлі'
or subsegment='Інше';

-- Доп. ключевые слова для сегм. в торговую:
-- %витирина+вітрина+первая линия+перша лінія+фасад+прохідне+проходное+жваве місце+новостр+ЖК%


-- 	[\d.,]+(?=\s* кв.|кв.|кв | кв | м2|м2|м.кв| м.кв| м. кв|м кв| м кв|кв.м| кв.м)
--  [\d]+(?=\s* кв[.]м|кв[.]м| кв[.] м|кв[.] м| кв | квадр| м2|м2|м[.]кв| м[.]кв| м[.] кв|м кв| м кв|кв[.]м| кв[.]м)
--  [\d]+[.,]{1}[\d]+(?=\s* кв[.]м|кв[.]м| кв[.] м|кв[.] м| кв | квадр| м2|м2|м[.]кв| м[.]кв| м[.] кв|м кв| м кв|кв[.]м| кв[.]м)

--  общее условие           [\d.,]+(?=\s* кв.|кв.| кв.м|кв.м| кв. м|кв. м| кв | квадр| м2|м2|м.кв| м.кв| м. кв|м кв| м кв|квм| квм| м/кв|м/кв|кв м| кв м)
--  усл. для целочисл. цен  [\d]+(?=\s* кв.|кв.| кв.м|кв.м| кв. м|кв. м| кв | квадр| м2|м2|м.кв| м.кв| м. кв|м кв| м кв|квм| квм| м/кв|м/кв|кв м| кв м)
--  усл. для дробных цен    [\d]+[.,]{1}[\d]+(?=\s* кв.|кв.| кв.м|кв.м| кв. м|кв. м| кв | квадр| м2|м2|м.кв| м.кв| м. кв|м кв| м кв|квм| квм| м/кв|м/кв|кв м| кв м)

-- Извлечение общей площади жилой и комерческой из текста
UPDATE uvekon.re_advert_load
SET total_area_d=(case 
WHEN lower(advert_text) ~ '[\d]+[.,]{1}[\d]+(?=\s* кв.|кв.| кв.м|кв.м| кв. м|кв. м| кв | квадр| м2|м2|м.кв| м.кв| м. кв|м кв| м кв|квм| квм| м/кв|м/кв|кв м| кв м)' 
THEN cast(replace(substring(lower(advert_text),'[\d]+[.,]{1}[\d]+(?=\s* кв.|кв.| кв.м|кв.м| кв. м|кв. м| кв | квадр| м2|м2|м.кв| м.кв| м. кв|м кв| м кв|квм| квм| м/кв|м/кв|кв м| кв м)'), ',', '.') as decimal(8,2))
ELSE cast(replace(substring(lower(advert_text),'[\d]+(?=\s* кв.|кв.| кв.м|кв.м| кв. м|кв. м| кв | квадр| м2|м2|м.кв| м.кв| м. кв|м кв| м кв|квм| квм| м/кв|м/кв|кв м| кв м)'), ',', '.') as decimal(8,2)) end)
WHERE lower(advert_text) ~ '[\d.,]+(?=\s* кв.|кв.| кв.м|кв.м| кв. м|кв. м| кв | квадр| м2|м2|м.кв| м.кв| м. кв|м кв| м кв|квм| квм| м/кв|м/кв|кв м| кв м)'
AND (total_area_d = 0 OR total_area_d is null)
AND id_segment <> 3;


-- общее условие  			[\d]+(?=\s* га|га| гект|гект| сот|сот) 
-- усл. для пл. в сотках	[\d]+[.,]{1}[\d]+(?=\s* сот|сот)   -->	  [\d]+(?=\s* сот|сот)
-- усл. для пл. в гектарах	[\d]+[.,]{1}[\d]+(?=\s* га|га| гект|гект)   -->	  [\d]+(?=\s* га|га| гект|гект)

-- Извлечение площади земельных участков из текста
UPDATE uvekon.re_advert_load
SET total_area_d=(case 
WHEN lower(advert_text) ~ '[\d]+[.,]{1}[\d]+(?=\s* га|га| гект|гект)' 
THEN cast(replace(substring(lower(advert_text),'[\d]+[.,]{1}[\d]+(?=\s* га|га| гект|гект)'), ',', '.') as decimal(8,2))*100
WHEN lower(advert_text) ~ '[\d]+(?=\s* га|га| гект|гект)' 
THEN cast(replace(substring(lower(advert_text),'[\d]+(?=\s* га|га| гект|гект)'), ',', '.') as decimal(8,2))*100
WHEN lower(advert_text) ~ '[\d]+[.,]{1}[\d]+(?=\s* сот|сот)' 
THEN cast(replace(substring(lower(advert_text),'[\d]+[.,]{1}[\d]+(?=\s* сот|сот)'), ',', '.') as decimal(8,2))
WHEN lower(advert_text) ~ '[\d]+(?=\s* сот|сот)' 
THEN cast(replace(substring(lower(advert_text),'[\d]+(?=\s* сот|сот)'), ',', '.') as decimal(8,2))
ELSE null end)
WHERE lower(advert_text) ~ '[\d]+(?=\s* га|га| гект|гект| сот|сот)'
AND (cast(replace(substring(lower(advert_text),'[\d]+(?=\s* га|га| гект|гект)'), ',', '.') as decimal(8,2))*100 < 10^6 
	OR cast(replace(substring(lower(advert_text),'[\d]+[.,]{1}[\d]+(?=\s* га|га| гект|гект)'), ',', '.') as decimal(8,2))*100 < 10^6
	OR cast(replace(substring(lower(advert_text),'[\d]+[.,]{1}[\d]+(?=\s* сот|сот)'), ',', '.') as decimal(8,2)) < 10^6
	OR cast(replace(substring(lower(advert_text),'[\d]+(?=\s* сот|сот)'), ',', '.') as decimal(8,2)) < 10^6)
AND (total_area_d = 0 OR total_area_d is null)
AND id_segment = 3;

-- Извлечение площади участков для домовладений и коммерции из текста
UPDATE uvekon.re_advert_load
SET land_area_d=(case 
WHEN lower(advert_text) ~ '[\d]+[.,]{1}[\d]+(?=\s* га|га| гект|гект)' 
THEN cast(replace(substring(lower(advert_text),'[\d]+[.,]{1}[\d]+(?=\s* га|га| гект|гект)'), ',', '.') as decimal(12,2))*100
WHEN lower(advert_text) ~ '[\d]+(?=\s* га|га| гект|гект)' 
THEN cast(replace(substring(lower(advert_text),'[\d]+(?=\s* га|га| гект|гект)'), ',', '.') as decimal(12,2))*100
WHEN lower(advert_text) ~ '[\d]+[.,]{1}[\d]+(?=\s* сот|сот)' 
THEN cast(replace(substring(lower(advert_text),'[\d]+[.,]{1}[\d]+(?=\s* сот|сот)'), ',', '.') as decimal(12,2))
WHEN lower(advert_text) ~ '[\d]+(?=\s* сот|сот)' 
THEN cast(replace(substring(lower(advert_text),'[\d]+(?=\s* сот|сот)'), ',', '.') as decimal(12,2))
ELSE null end)
WHERE lower(advert_text) ~ '[\d]+(?=\s* га|га| гект|гект| сот|сот)'
AND cast(replace(substring(lower(advert_text),'[\d]+[.,]{1}[\d]+(?=\s* га|га| гект|гект)'), ',', '.') as decimal(12,2))*100 < 10^10
AND (land_area is null OR land_area_d is null)
AND id_segment <> 3;

-- Заполнение текстового поля пл. участка (для АРМа)
UPDATE uvekon.re_advert_load
SET land_area = land_area_d
WHERE (land_area is null OR land_area = '')
AND land_area_d is not null

-- Жилая недвижимость. Первичный рынок. Сегментация. Продажа квартир. OLX (Перенос с вторички)
UPDATE uvekon.re_advert_load
SET id_segment=1,id_subsegment=1,id_type_oper=1
WHERE agency = 'OLX'
AND type_obj = 'На етапі будівництва'
AND type_offer = 'Бізнес';

SELECT * FROM uvekon.re_advert_load
WHERE lower(advert_text) ~ '[\d]+(?=\s* га|га| гект|гект| сот|сот)'
AND (total_area_d = 0 OR total_area_d is null)
AND id_segment = 3

-- Перенос из социального жилья в бизнес-элит. Милионники.
UPDATE uvekon.re_advert_load
SET id_class_subsegment = 2
WHERE id_segment=1 and id_subsegment = 2 and id_class_subsegment = 1
AND (year_building in ('1996','1997','1998','1999','1999','2000','2001','2002','2003','2004','2005','2006','2007','2008','2009','2010','2011','2012','2013','2014','2015','2016','2017','2018', 'новобудова')
OR type_obj in ('Житловий фонд від 2011 р.','Житловий фонд 2001-2010-і'))
AND (id_region ='80' or koatuu_code='1210100000' or koatuu_code='4610100000'or koatuu_code='5110100000' or koatuu_code='6310100000')
AND price_1sq_meter_usd > 299;

-- Перенос из вторично рынка в первичный по году постройки и цене
UPDATE uvekon.re_advert_load
SET id_subsegment = 1
WHERE id_segment=1 and id_subsegment = 2 
AND year_building in ('2017','2018', 'новобудова')
AND (id_region ='80' or koatuu_code='1210100000' or koatuu_code='4610100000'or koatuu_code='5110100000' or koatuu_code='6310100000')
AND price_1sq_meter_usd < 400;

-- Перенос из социального жилья в бизнес-элит. Остальные.
UPDATE uvekon.re_advert_load
SET id_class_subsegment = 2
WHERE id_segment=1 and id_subsegment = 2 and id_class_subsegment = 1
AND (year_building in ('1996','1997','1998','1999','1999','2000','2001','2002','2003','2004','2005','2006','2007','2008','2009','2010','2011','2012','2013','2014','2015','2016','2017','2018', 'новобудова')
OR type_obj in ('Житловий фонд від 2011 р.','Житловий фонд 2001-2010-і'))
AND not (id_region ='80' or koatuu_code='1210100000' or koatuu_code='4610100000'or koatuu_code='5110100000' or koatuu_code='6310100000')
AND price_1sq_meter_usd > 180;

-- Перенос из бизнес-элит жилья в социальное. Милионники.
UPDATE uvekon.re_advert_load
SET id_class_subsegment = 1
WHERE id_segment=1 and id_subsegment = 2 and id_class_subsegment = 2
AND (year_building in ('1950','1951','1952','1953','1954-1955','1956','1957','1958','1959','1960','1961','1962','1963','1964','1965','1966','1967','1968','1969','1970','1971','1972','1973','1974','1975','1976','1978','1979','1980','1981','1982','1983','1984','1985','1986','1987','1988','1989','1990','1991','1992','1993','1994','1995')
OR type_obj in ('Царський будинок','Сталінка','Хрущовка','Чешка','Гостинка','Совмін','Гуртожиток','Житловий фонд 80-90-і','Житловий фонд 91-2000-і'))
AND (id_region ='80' or koatuu_code='1210100000' or koatuu_code='4610100000'or koatuu_code='5110100000' or koatuu_code='6310100000')
AND price_1sq_meter_usd < 1200;

-- Перенос из бизнес-элит жилья в социальное. Остальные.
UPDATE uvekon.re_advert_load
SET id_class_subsegment = 1
WHERE id_segment=1 and id_subsegment = 2 and id_class_subsegment = 2
AND (year_building in ('1950','1951','1952','1953','1954-1955','1956','1957','1958','1959','1960','1961','1962','1963','1964','1965','1966','1967','1968','1969','1970','1971','1972','1973','1974','1975','1976','1978','1979','1980','1981','1982','1983','1984','1985','1986','1987','1988','1989','1990','1991','1992','1993','1994','1995')
OR type_obj in ('Царський будинок','Сталінка','Хрущовка','Чешка','Гостинка','Совмін','Гуртожиток','Житловий фонд 80-90-і','Житловий фонд 91-2000-і'))
AND not (id_region ='80' or koatuu_code='1210100000' or koatuu_code='4610100000'or koatuu_code='5110100000' or koatuu_code='6310100000');

-- Перенос из вторично рынка в первичный по текстовым фильтрам
SELECT * FROM uvekon.re_advert_load
WHERE id_segment = 1 AND id_subsegment = 2 AND id_type_oper = 1 
AND price_1sq_meter_usd >=150 and price_1sq_meter_usd<=2000
AND lower(advert_text) ~ '(рассрочка!!|розтрочка!!|срок сдачи|термін здачі|сдача -|здача -|сдача дома|здача будинку|окончание строительства|кінець будівництва|ввод в эксплуатацию|ввід в експлуатацію)'
AND status = 1
ORDER BY price_1sq_meter_usd

UPDATE uvekon.re_advert_load
SET id_subsegment = 1
WHERE id_segment = 1 AND id_subsegment = 2 AND id_type_oper = 1 AND status = 1
AND price_1sq_meter_usd >=150 and price_1sq_meter_usd<=2000
AND lower(advert_text) ~ '(рассрочка!!|розтрочка!!|срок сдачи|термін здачі|сдача -|здача -|сдача дома|здача будинку|окончание строительства|кінець будівництва|ввод в эксплуатацию|ввід в експлуатацію)'

-----------------------------
--- ДНЕПР -------------------
UPDATE uvekon.re_advert_load
SET koatuu_code = '1210100000', id_kotuu_district = '12101'
WHERE id_region = '12' AND (name_np like 'Дніпро' OR name_np like 'Дніпро %') AND (id_kotuu_district <> '12101' OR id_kotuu_district IS null);
---------------------------

-----------------------------
--- СЕВАСТОПОЛЬ ------------------
UPDATE uvekon.re_advert_load
SET koatuu_code = '8500000000', id_kotuu_district = '85000', id_region = '85'
WHERE id_region = '01' AND (addr_all like '%Сева%') AND (id_kotuu_district <> '85000' OR id_kotuu_district IS null);
---------------------------

-- Выборка по большим городам для Насти
SELECT * FROM uvekon.re_advert
WHERE koatuu_code in ('4610100000', '1210100000', '5110100000', '6310100000', '2310100000', '8000000000') AND date_relevance = to_date('31.03.2018', 'DD.MM.YYYY')
AND id_agency = 2 AND id_segment = 1 AND id_subsegment = 2 AND id_type_oper = 1 AND is_valid = true

-- Обработка дат новостройки.ЛУН.юа
UPDATE uvekon.re_advert_load_tmp1
SET date_advert = substring(date_advert, '\d{2}\.\d{2}\.\d{4}')
WHERE date_advert is not null

-- выборка агрег инф по квартирам
SELECT * FROM uvekon.re_aggregate_info
WHERE date_relevance in ('2018-03-31', '2018-02-28', '2018-01-31', '2017-12-31', '2017-11-30', '2017-10-31') 
AND level_group = 2 AND id_type_oper = 1 AND id_segment = 1 AND id_subsegment = 2 AND level_poligon = 1
ORDER BY date_relevance desc

-------------------------------
-- Добавление поля геометрии --
SELECT AddGeometryColumn ('uvekon','re_advert_load','geom',4326,'POINT',2);
-- Обновление поля географии --
UPDATE uvekon.re_advert
SET geog = Geography(geom)
WHERE date_relevance IN ('2018-04-30', '2018-05-31')
AND geog is null AND geom is not null;
-- 
UPDATE uvekon.re_advert
SET geog = ST_SetSRID(ST_MakePoint(cast(coordinate_e AS double precision), cast(coordinate_n AS double precision)), 4326)::geography
WHERE date_relevance = '2018-03-31'
AND geog IS NULL 
AND character_length(coordinate_e) > 1 AND character_length(coordinate_n) > 1


-- Заполнение поля геометрии -->
--> новой загрузки -->
UPDATE uvekon.re_advert_load
SET geom = ST_SetSRID(ST_MakePoint(cast(coordinate_e AS double precision), cast(coordinate_n AS double precision)), 4326) 
WHERE coordinate_e <> '' AND character_length(coordinate_e) > 1 AND geom is null;
--> архива -->
UPDATE uvekon.re_advert
SET geom = ST_SetSRID(ST_MakePoint(cast(coordinate_e AS double precision), cast(coordinate_n AS double precision)), 4326) 
WHERE coordinate_e <> '' AND character_length(coordinate_e) > 1 AND geom is null
AND date_relevance = '2018-04-30';
-------------------------------

-- Разбиение обработки справочника пригородов на части
SELECT uvekon.set_suburb_by_koatuu('05'); -- Вінницька
SELECT uvekon.set_suburb_by_koatuu('07'); -- Волинська
SELECT uvekon.set_suburb_by_koatuu('12'); -- Дніпропетровська
SELECT uvekon.set_suburb_by_koatuu('18');
SELECT uvekon.set_suburb_by_koatuu('21');
SELECT uvekon.set_suburb_by_koatuu('23');
SELECT uvekon.set_suburb_by_koatuu('26');
SELECT uvekon.set_suburb_by_koatuu('32');
SELECT uvekon.set_suburb_by_koatuu('35');
SELECT uvekon.set_suburb_by_koatuu('46');
SELECT uvekon.set_suburb_by_koatuu('48');
SELECT uvekon.set_suburb_by_koatuu('51');
SELECT uvekon.set_suburb_by_koatuu('53');
SELECT uvekon.set_suburb_by_koatuu('56');
SELECT uvekon.set_suburb_by_koatuu('59');
SELECT uvekon.set_suburb_by_koatuu('61');
SELECT uvekon.set_suburb_by_koatuu('63');
SELECT uvekon.set_suburb_by_koatuu('65');
SELECT uvekon.set_suburb_by_koatuu('68');
SELECT uvekon.set_suburb_by_koatuu('71');
SELECT uvekon.set_suburb_by_koatuu('73');
SELECT uvekon.set_suburb_by_koatuu('74');

-------------------------------------------
-- Исправление ошибок новостройки.лун.юа --
-------------------------------------------
UPDATE uvekon.re_advert_load_tmp1
SET date_advert=substring(date_advert, '\d{2}\.\d{2}\.\d{4}')

UPDATE uvekon.re_advert_load l
SET price_1sq_meter_uah = (
	SELECT regexp_replace(price_2m2,'[^0-9]','','g')::int FROM uvekon.re_advert_load_tmp1 n
	WHERE l.advert_text = n.jk AND l.total_area = n.total_area2
	AND l.advert_url = n.advert_url
	AND n.price_2m2 is not null AND n.price_2m2 <>''
    AND n.total_area2 is not null AND n.total_area2 <>''
	)
WHERE l.id_segment = 1 AND l.id_subsegment = 1 AND l.id_type_oper = 1 
AND l.agency = 'LUN' AND l.advert_url like '%novostroyki.lun.ua%'
AND l.status = 1 AND l.qt_room = '2';

-- Удаление дублей --------------
DELETE FROM uvekon.re_advert_load_tmp1
WHERE advert_url IN (
SELECT advert_url
FROM uvekon.re_advert_load_tmp1
WHERE price_2m2 is not null AND price_2m2 <>''
    AND total_area2 is not null AND total_area2 <>''
GROUP BY advert_url
HAVING ( COUNT(advert_url) > 1 )
	)
-----------------------------------------
"type" = 'Продажа'  AND  "category" = 'Квартира'   AND  "price/curr" = 'USD'  AND  "sold-pri_1" = 'USD'  
AND "bargaining"    >=  -0.3  AND  "bargaining"  <=  0.3
-----------------------------------------
SELECT
	DISTINCT building_class,
	AVG(price_1sq_meter_usd),
	median(price_1sq_meter_usd),
	count(*)
FROM uvekon.re_advert
WHERE advert_url like 'https://novostroyki.lun.ua%'
AND date_relevance = '2018-05-31'
GROUP BY building_class


WITH sizes AS (
	SELECT 
		(
		CASE 
		WHEN total_area <= 100 THEN '1- до 100 м2'
		WHEN (total_area > 100 AND total_area <= 200) THEN '2 - от 100 до 200 м2'
		WHEN (total_area > 200 AND total_area <= 500) THEN '3 - от 200 до 500 м2'
		WHEN (total_area > 500 AND total_area <= 1000) THEN '4 - от 500 до 1000 м2'
		ELSE '5 - больше 1000 м2' END
		) AS size
	FROM uvekon.re_advert
	WHERE date_relevance = '2018-05-31' 
	AND id_type_oper = 1 AND id_subsegment = 5
	AND advert_text like '%магаз%'
	AND total_area is not null AND total_area > 20
)
SELECT DISTINCT size, COUNT(*) FROM sizes
GROUP BY size
ORDER BY size

INSERT INTO uvekon.re_advert_novostroyki
(
id,	
agency,	
jk,	
category,	
load_script,	
realty_kod,	
date_advert,	
segment,	
region,	
region_district,	
name_np,	
address,	
price_m2,	
price_advert1,	
price_1m2,	
price_advert2,	
price_2m2,	
price_advert3,	
price_3m2,	
price_advert4,	
price_4m2,	
count_apartments,	
qt_floor,	
total_area1,	
total_area2,	
total_area3,	
total_area4,	
wall_material,	
build_year,	
advert_text,	
advert_url,	
coordinate_n,	
coordinate_e,	
street,	
house,	
district,	
mikrodistrict,	
primary_agency,	
status,	
date_insert,	
base_url,	
price_typ,	
addr_all,	
price_advert5,	
price_advert2p,	
price_5m2,	
price_2pm2,	
total_area5,	
total_area2p,	
count_buildings,	
count_sections,	
wall_insulation,	
build_technology,	
room_height,	
heating,	
parking,	
renovation,	
closed_territory,	
developer,	
min_price_m2,	
max_price_m2,	
status_sale,	
problem_object_link,	
status_building_log
)
SELECT (SELECT
           date_relevance
         FROM uvekon.re_aggregate_period
         WHERE type_period = 1
         AND is_work)
         date_relevance,
    id,	
	agency,	
	jk,	
	category,	
	load_script,	
	realty_kod,	
	date_advert,	
	segment,	
	region,	
	region_district,	
	name_np,	
	address,	
	price_m2,	
	price_advert1,	
	price_1m2,	
	price_advert2,	
	price_2m2,	
	price_advert3,	
	price_3m2,	
	price_advert4,	
	price_4m2,	
	count_apartments,	
	qt_floor,	
	total_area1,	
	total_area2,	
	total_area3,	
	total_area4,	
	wall_material,	
	build_year,	
	advert_text,	
	advert_url,	
	coordinate_n,	
	coordinate_e,	
	street,	
	house,	
	district,	
	mikrodistrict,	
	primary_agency,	
	status,	
	date_insert,	
	base_url,	
	price_typ,	
	addr_all,	
	price_advert5,	
	price_advert2p,	
	price_5m2,	
	price_2pm2,	
	total_area5,	
	total_area2p,	
	count_buildings,	
	count_sections,	
	wall_insulation,	
	build_technology,	
	room_height,	
	heating,	
	parking,	
	renovation,	
	closed_territory,	
	developer,	
	min_price_m2,	
	max_price_m2,	
	status_sale,	
	problem_object_link,	
	status_building_log
  FROM uvekon.re_advert_load_novostroyki

id,	
agency,	
jk,	
category,	
load_script,	
realty_kod,	
date_advert,	
segment,	
region,	
region_district,	
name_np,	
address,	
price_m2,	
price_advert1,	
price_1m2,	
price_advert2,	
price_2m2,	
price_advert3,	
price_3m2,	
price_advert4,	
price_4m2,	
count_apartments,	
qt_floor,	
total_area1,	
total_area2,	
total_area3,	
total_area4,	
wall_material,	
build_year,	
advert_text,	
advert_url,	
coordinate_n,	
coordinate_e,	
street,	
house,	
district,	
mikrodistrict,	
primary_agency,	
status,	
date_insert,	
base_url,	
price_typ,	
addr_all,	
price_advert5,	
price_advert2p,	
price_5m2,	
price_2pm2,	
total_area5,	
total_area2p,	
count_buildings,	
count_sections,	
wall_insulation,	
build_technology,	
room_height,	
heating,	
parking,	
renovation,	
closed_territory,	
developer,	
min_price_m2,	
max_price_m2,	
status_sale,	
problem_object_link,	
status_building_log