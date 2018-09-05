-- Заполнение интегрированых даных: 1 level   4 gr --
insert into uvekon.re_aggregate_info (
  date_relevance, -- Дата актуальности данных
  id_type_oper, -- Код операции с недвижимостью
  id_segment, -- Код сегмента
  id_subsegment, -- Код подсегмента
  id_class_subsegment, -- Код класса подсегмента объекта недвижимости
  id_size_object, -- Код размерности объекта недвижимости
  id_poligon, -- Код полигона
  price_1sq_meter_uah , -- Средняя цена 1 кв.метра в гривне на дату актуальности данных
  price_1sq_meter_usd, -- Средняя цена 1 кв.метра в долларах на дату актуальности данных
  price_object_uah, -- Средняя цена объекта в гривне на дату актуальности данных
  price_object_usd, -- Средняя цена объекта в долларах на дату актуальности данных
  count_advert,
  level_group,
  min_1sq_meter_usd,
  max_1sq_meter_usd,
  level_poligon)
select
  date_relevance,
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_class_subsegment, -- Код класса подсегмента (РАСЧЕТНАЯ)
  id_size_object, -- Код размера объекта (РАСЧЕТНОЕ)
  u.id_poligon_level_1,
  sum(price_1sq_meter_uah)/count(*) price_1sq_meter_uah,
  sum(price_1sq_meter_usd)/count(*) price_1sq_meter_usd,
  sum(price_uah)/count(*) price_object_uah,
  sum(price_usd)/count(*) price_object_usd,
  count(*),
  4,
  min(price_1sq_meter_usd),
  max(price_1sq_meter_usd),
  1
from uvekon.re_advert u
 where 1=1
 and u.price_advert is not null
-- and u.price_advert <>0
 --and u.koatuu_code is not null
 and u.is_valid=true
 and date_relevance=(select date_relevance from uvekon.re_aggregate_period where type_period=1 and is_work)
group by id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_size_object, -- Код размера объекта (РАСЧЕТНОЕ)
  id_class_subsegment, -- Код класса подсегмента (РАСЧЕТНАЯ)
  id_poligon_level_1,
  date_relevance;
  
-- Заполнение интегрированых даных: 2 level -- 4 gr 
insert into uvekon.re_aggregate_info (
  date_relevance, -- Дата актуальности данных
  id_type_oper, -- Код операции с недвижимостью
  id_segment, -- Код сегмента
  id_subsegment, -- Код подсегмента
  id_class_subsegment, -- Код класса подсегмента объекта недвижимости
  id_size_object, -- Код размерности объекта недвижимости
  id_poligon, -- Код полигона
  price_1sq_meter_uah , -- Средняя цена 1 кв.метра в гривне на дату актуальности данных
  price_1sq_meter_usd, -- Средняя цена 1 кв.метра в долларах на дату актуальности данных
  price_object_uah, -- Средняя цена объекта в гривне на дату актуальности данных
  price_object_usd, -- Средняя цена объекта в долларах на дату актуальности данных
  count_advert,
  level_group,
  min_1sq_meter_usd,
  max_1sq_meter_usd,
  level_poligon)
select date_relevance,
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_class_subsegment, -- Код класса подсегмента (РАСЧЕТНАЯ)
  id_size_object, -- Код размера объекта (РАСЧЕТНОЕ)
  id_poligon_level_2,
  sum(price_1sq_meter_uah)/count(*) price_1sq_meter_uah,
  sum(price_1sq_meter_usd)/count(*) price_1sq_meter_usd,
  sum(price_uah)/count(*) price_object_uah,
  sum(price_usd)/count(*) price_object_usd,
  count(*),
  4,
  min(price_1sq_meter_usd),
  max(price_1sq_meter_usd),
  2
from uvekon.re_advert u
 where 1=1
 and u.price_advert is not null
-- and u.price_advert <>0
-- and u.koatuu_code is not null
 and u.is_valid=true
 and date_relevance=(select date_relevance from uvekon.re_aggregate_period where type_period=1 and is_work)
group by id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_size_object, -- Код размера объекта (РАСЧЕТНОЕ)
  id_class_subsegment, -- Код класса подсегмента (РАСЧЕТНАЯ)
  id_poligon_level_2,
  date_relevance;

-- Заполнение интегрированых даных: 3 level ---- 4 gr
insert into uvekon.re_aggregate_info (
  date_relevance, -- Дата актуальности данных
  id_type_oper, -- Код операции с недвижимостью
  id_segment, -- Код сегмента
  id_subsegment, -- Код подсегмента
  id_class_subsegment, -- Код класса подсегмента объекта недвижимости
  id_size_object, -- Код размерности объекта недвижимости
  id_poligon, -- Код полигона
  price_1sq_meter_uah , -- Средняя цена 1 кв.метра в гривне на дату актуальности данных
  price_1sq_meter_usd, -- Средняя цена 1 кв.метра в долларах на дату актуальности данных
  price_object_uah, -- Средняя цена объекта в гривне на дату актуальности данных
  price_object_usd, -- Средняя цена объекта в долларах на дату актуальности данных
  count_advert,
  level_group,
  min_1sq_meter_usd,
  max_1sq_meter_usd,
  level_poligon)
select date_relevance,
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_class_subsegment, -- Код класса подсегмента (РАСЧЕТНАЯ)
  id_size_object, -- Код размера объекта (РАСЧЕТНОЕ)
  id_poligon_level_3,
  sum(price_1sq_meter_uah)/count(*) price_1sq_meter_uah,
  sum(price_1sq_meter_usd)/count(*) price_1sq_meter_usd,
  sum(price_uah)/count(*) price_object_uah,
  sum(price_usd)/count(*) price_object_usd,
  count(*),
  4,
  min(price_1sq_meter_usd),
  max(price_1sq_meter_usd),
  3
from uvekon.re_advert u
 where 1=1
 and u.price_advert is not null
-- and u.price_advert <>0
-- and u.koatuu_code is not null
 and u.is_valid=true
 and date_relevance=(select date_relevance from uvekon.re_aggregate_period where type_period=1 and is_work)
group by id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_size_object, -- Код размера объекта (РАСЧЕТНОЕ)
  id_class_subsegment, -- Код класса подсегмента (РАСЧЕТНАЯ)
  id_poligon_level_3,
  date_relevance;

-- Заполнение интегрированых даных: 4 level ---- 4 gr
insert into uvekon.re_aggregate_info (
  date_relevance, -- Дата актуальности данных
  id_type_oper, -- Код операции с недвижимостью
  id_segment, -- Код сегмента
  id_subsegment, -- Код подсегмента
  id_class_subsegment, -- Код класса подсегмента объекта недвижимости
  id_size_object, -- Код размерности объекта недвижимости
  id_poligon, -- Код полигона
  price_1sq_meter_uah , -- Средняя цена 1 кв.метра в гривне на дату актуальности данных
  price_1sq_meter_usd, -- Средняя цена 1 кв.метра в долларах на дату актуальности данных
  price_object_uah, -- Средняя цена объекта в гривне на дату актуальности данных
  price_object_usd, -- Средняя цена объекта в долларах на дату актуальности данных
  count_advert,
  level_group,
  min_1sq_meter_usd,
  max_1sq_meter_usd,
  level_poligon)
select date_relevance,
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_class_subsegment, -- Код класса подсегмента (РАСЧЕТНАЯ)
  id_size_object, -- Код размера объекта (РАСЧЕТНОЕ)
  id_poligon_level_4,
  sum(price_1sq_meter_uah)/count(*) price_1sq_meter_uah,
  sum(price_1sq_meter_usd)/count(*) price_1sq_meter_usd,
  sum(price_uah)/count(*) price_object_uah,
  sum(price_usd)/count(*) price_object_usd,
  count(*),
  4,
  min(price_1sq_meter_usd),
  max(price_1sq_meter_usd),
  4
from uvekon.re_advert u
 where 1=1
 and u.price_advert is not null
 and u.is_valid=true
 and date_relevance=(select date_relevance from uvekon.re_aggregate_period where type_period=1 and is_work)
group by id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_size_object, -- Код размера объекта (РАСЧЕТНОЕ)
  id_class_subsegment, -- Код класса подсегмента (РАСЧЕТНАЯ)
  id_poligon_level_4,
  date_relevance;

-- Заполнение интегрированых даных: 1 level  3 gr
insert into uvekon.re_aggregate_info (
  date_relevance, -- Дата актуальности данных
  id_type_oper, -- Код операции с недвижимостью
  id_segment, -- Код сегмента
  id_subsegment, -- Код подсегмента
  id_class_subsegment, -- Код класса подсегмента объекта недвижимости
  id_poligon, -- Код полигона
  price_1sq_meter_uah , -- Средняя цена 1 кв.метра в гривне на дату актуальности данных
  price_1sq_meter_usd, -- Средняя цена 1 кв.метра в долларах на дату актуальности данных
  price_object_uah, -- Средняя цена объекта в гривне на дату актуальности данных
  price_object_usd, -- Средняя цена объекта в долларах на дату актуальности данных
  count_advert,
  level_group,
  min_1sq_meter_usd,
  max_1sq_meter_usd,
  level_poligon)
select date_relevance,
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_class_subsegment, -- Код класса подсегмента (РАСЧЕТНАЯ)
  id_poligon_level_1,
  sum(price_1sq_meter_uah)/count(*) price_1sq_meter_uah,
  sum(price_1sq_meter_usd)/count(*) price_1sq_meter_usd,
  sum(price_uah)/count(*) price_object_uah,
  sum(price_usd)/count(*) price_object_usd,
  count(*),
  3,
  min(price_1sq_meter_usd),
  max(price_1sq_meter_usd),
  1
from uvekon.re_advert u
 where 1=1
 and u.price_advert is not null
-- and u.price_advert <>0
-- and u.koatuu_code is not null
 and u.is_valid=true
 and date_relevance=TO_DATE('31.07.2017','DD.MM.YYYY')
group by id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
 -- id_size_object, -- Код размера объекта (РАСЧЕТНОЕ)
  id_class_subsegment, -- Код класса подсегмента (РАСЧЕТНАЯ)
  id_poligon_level_1,
  date_relevance;

 -- Заполнение интегрированых даных: 2 level --- 3 gr
insert into uvekon.re_aggregate_info (
  date_relevance, -- Дата актуальности данных
  id_type_oper, -- Код операции с недвижимостью
  id_segment, -- Код сегмента
  id_subsegment, -- Код подсегмента
  id_class_subsegment, -- Код класса подсегмента объекта недвижимости
  id_poligon, -- Код полигона
  price_1sq_meter_uah , -- Средняя цена 1 кв.метра в гривне на дату актуальности данных
  price_1sq_meter_usd, -- Средняя цена 1 кв.метра в долларах на дату актуальности данных
  price_object_uah, -- Средняя цена объекта в гривне на дату актуальности данных
  price_object_usd, -- Средняя цена объекта в долларах на дату актуальности данных
  count_advert,
  level_group,
  min_1sq_meter_usd,
  max_1sq_meter_usd,
  level_poligon)
select date_relevance,
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_class_subsegment, -- Код класса подсегмента (РАСЧЕТНАЯ)
  id_poligon_level_2,
  sum(price_1sq_meter_uah)/count(*) price_1sq_meter_uah,
  sum(price_1sq_meter_usd)/count(*) price_1sq_meter_usd,
  sum(price_uah)/count(*) price_object_uah,
  sum(price_usd)/count(*) price_object_usd,
  count(*),
  3,
  min(price_1sq_meter_usd),
  max(price_1sq_meter_usd),
  2
from uvekon.re_advert u
 where 1=1
 and u.price_advert is not null
-- and u.price_advert <>0
-- and u.koatuu_code is not null
 and u.is_valid=true
 and date_relevance=(select date_relevance from uvekon.re_aggregate_period where type_period=1 and is_work)
group by id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
--  id_size_object, -- Код размера объекта (РАСЧЕТНОЕ)
  id_class_subsegment, -- Код класса подсегмента (РАСЧЕТНАЯ)
  id_poligon_level_2,
  date_relevance;

-- Заполнение интегрированых даных: 3 level ---- 3 gr
insert into uvekon.re_aggregate_info (
  date_relevance, -- Дата актуальности данных
  id_type_oper, -- Код операции с недвижимостью
  id_segment, -- Код сегмента
  id_subsegment, -- Код подсегмента
  id_class_subsegment, -- Код класса подсегмента объекта недвижимости
  id_poligon, -- Код полигона
  price_1sq_meter_uah , -- Средняя цена 1 кв.метра в гривне на дату актуальности данных
  price_1sq_meter_usd, -- Средняя цена 1 кв.метра в долларах на дату актуальности данных
  price_object_uah, -- Средняя цена объекта в гривне на дату актуальности данных
  price_object_usd, -- Средняя цена объекта в долларах на дату актуальности данных
  count_advert,
  level_group,
  min_1sq_meter_usd,
  max_1sq_meter_usd,
  level_poligon)
select date_relevance,
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_class_subsegment, -- Код класса подсегмента (РАСЧЕТНАЯ)
  id_poligon_level_3,
  sum(price_1sq_meter_uah)/count(*) price_1sq_meter_uah,
  sum(price_1sq_meter_usd)/count(*) price_1sq_meter_usd,
  sum(price_uah)/count(*) price_object_uah,
  sum(price_usd)/count(*) price_object_usd,
  count(*),
  3,
  min(price_1sq_meter_usd),
  max(price_1sq_meter_usd),
  3
from uvekon.re_advert u
 where 1=1
 and u.price_advert is not null
-- and u.price_advert <>0
-- and u.koatuu_code is not null
 and u.is_valid=true
 and date_relevance=(select date_relevance from uvekon.re_aggregate_period where type_period=1 and is_work)
group by id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
 -- id_size_object, -- Код размера объекта (РАСЧЕТНОЕ)
  id_class_subsegment, -- Код класса подсегмента (РАСЧЕТНАЯ)
  id_poligon_level_3,
  date_relevance;

-- Заполнение интегрированых даных: 4 level ---- 3 gr
insert into uvekon.re_aggregate_info (
  date_relevance, -- Дата актуальности данных
  id_type_oper, -- Код операции с недвижимостью
  id_segment, -- Код сегмента
  id_subsegment, -- Код подсегмента
  id_class_subsegment, -- Код класса подсегмента объекта недвижимости
  id_poligon, -- Код полигона
  price_1sq_meter_uah , -- Средняя цена 1 кв.метра в гривне на дату актуальности данных
  price_1sq_meter_usd, -- Средняя цена 1 кв.метра в долларах на дату актуальности данных
  price_object_uah, -- Средняя цена объекта в гривне на дату актуальности данных
  price_object_usd, -- Средняя цена объекта в долларах на дату актуальности данных
  count_advert,
  level_group,
  min_1sq_meter_usd,
  max_1sq_meter_usd,
  level_poligon)
select date_relevance,
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_class_subsegment, -- Код класса подсегмента (РАСЧЕТНАЯ)
  id_poligon_level_4,
  sum(price_1sq_meter_uah)/count(*) price_1sq_meter_uah,
  sum(price_1sq_meter_usd)/count(*) price_1sq_meter_usd,
  sum(price_uah)/count(*) price_object_uah,
  sum(price_usd)/count(*) price_object_usd,
  count(*),
  3,
  min(price_1sq_meter_usd),
  max(price_1sq_meter_usd),
  4
from uvekon.re_advert u
 where 1=1
 and u.price_advert is not null
 and u.is_valid=true
 and date_relevance=(select date_relevance from uvekon.re_aggregate_period where type_period=1 and is_work)
group by id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_class_subsegment, -- Код класса подсегмента (РАСЧЕТНАЯ)
  id_poligon_level_4,
  date_relevance;

-- Заполнение интегрированых даных: 1 level  2 gr
insert into uvekon.re_aggregate_info (
  date_relevance, -- Дата актуальности данных
  id_type_oper, -- Код операции с недвижимостью
  id_segment, -- Код сегмента
  id_subsegment, -- Код подсегмента
  id_poligon, -- Код полигона
  price_1sq_meter_uah , -- Средняя цена 1 кв.метра в гривне на дату актуальности данных
  price_1sq_meter_usd, -- Средняя цена 1 кв.метра в долларах на дату актуальности данных
  price_object_uah, -- Средняя цена объекта в гривне на дату актуальности данных
  price_object_usd, -- Средняя цена объекта в долларах на дату актуальности данных
  count_advert,
  level_group,
  min_1sq_meter_usd,
  max_1sq_meter_usd,
  level_poligon)
select date_relevance,
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_poligon_level_1,
  sum(price_1sq_meter_uah)/count(*) price_1sq_meter_uah,
  sum(price_1sq_meter_usd)/count(*) price_1sq_meter_usd,
  sum(price_uah)/count(*) price_object_uah,
  sum(price_usd)/count(*) price_object_usd,
  count(*),
  2,
  min(price_1sq_meter_usd),
  max(price_1sq_meter_usd),
  1
from uvekon.re_advert u
 where 1=1
 and u.price_advert is not null
 and u.is_valid=true
 and date_relevance=(select date_relevance from uvekon.re_aggregate_period where type_period=1 and is_work)
group by id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ) 
  id_poligon_level_1,
  date_relevance;

-- Заполнение интегрированых даных: 2 level --- 2 gr
insert into uvekon.re_aggregate_info (
  date_relevance, -- Дата актуальности данных
  id_type_oper, -- Код операции с недвижимостью
  id_segment, -- Код сегмента
  id_subsegment, -- Код подсегмента
  id_poligon, -- Код полигона
  price_1sq_meter_uah , -- Средняя цена 1 кв.метра в гривне на дату актуальности данных
  price_1sq_meter_usd, -- Средняя цена 1 кв.метра в долларах на дату актуальности данных
  price_object_uah, -- Средняя цена объекта в гривне на дату актуальности данных
  price_object_usd, -- Средняя цена объекта в долларах на дату актуальности данных
  count_advert,
  level_group,
  min_1sq_meter_usd,
  max_1sq_meter_usd,
  level_poligon)
select date_relevance,
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_poligon_level_2,
  sum(price_1sq_meter_uah)/count(*) price_1sq_meter_uah,
  sum(price_1sq_meter_usd)/count(*) price_1sq_meter_usd,
  sum(price_uah)/count(*) price_object_uah,
  sum(price_usd)/count(*) price_object_usd,
  count(*),
  2,
  min(price_1sq_meter_usd),
  max(price_1sq_meter_usd),
  2
from uvekon.re_advert u
 where 1=1
 and u.price_advert is not null
 and u.is_valid=true
 and date_relevance=(select date_relevance from uvekon.re_aggregate_period where type_period=1 and is_work)
group by id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_poligon_level_2,
  date_relevance;

 -- Заполнение интегрированых даных: 3 level ---- 2 gr
insert into uvekon.re_aggregate_info (
  date_relevance, -- Дата актуальности данных
  id_type_oper, -- Код операции с недвижимостью
  id_segment, -- Код сегмента
  id_subsegment, -- Код подсегмента
  id_poligon, -- Код полигона
  price_1sq_meter_uah , -- Средняя цена 1 кв.метра в гривне на дату актуальности данных
  price_1sq_meter_usd, -- Средняя цена 1 кв.метра в долларах на дату актуальности данных
  price_object_uah, -- Средняя цена объекта в гривне на дату актуальности данных
  price_object_usd, -- Средняя цена объекта в долларах на дату актуальности данных
  count_advert,
  level_group,
  min_1sq_meter_usd,
  max_1sq_meter_usd,
  level_poligon)
select date_relevance,
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_poligon_level_3,
  sum(price_1sq_meter_uah)/count(*) price_1sq_meter_uah,
  sum(price_1sq_meter_usd)/count(*) price_1sq_meter_usd,
  sum(price_uah)/count(*) price_object_uah,
  sum(price_usd)/count(*) price_object_usd,
  count(*),
  2,
  min(price_1sq_meter_usd),
  max(price_1sq_meter_usd),
  3
from uvekon.re_advert u
 where 1=1
 and u.price_advert is not null
 and u.is_valid=true
 and date_relevance=(select date_relevance from uvekon.re_aggregate_period where type_period=1 and is_work)
group by id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_poligon_level_3,
  date_relevance;

-- Заполнение интегрированых даных: 4 level ---- 2 gr
insert into uvekon.re_aggregate_info (
  date_relevance, -- Дата актуальности данных
  id_type_oper, -- Код операции с недвижимостью
  id_segment, -- Код сегмента
  id_subsegment, -- Код подсегмента
  id_poligon, -- Код полигона
  price_1sq_meter_uah , -- Средняя цена 1 кв.метра в гривне на дату актуальности данных
  price_1sq_meter_usd, -- Средняя цена 1 кв.метра в долларах на дату актуальности данных
  price_object_uah, -- Средняя цена объекта в гривне на дату актуальности данных
  price_object_usd, -- Средняя цена объекта в долларах на дату актуальности данных
  count_advert,
  level_group,
  min_1sq_meter_usd,
  max_1sq_meter_usd,
  level_poligon)
select date_relevance,
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_poligon_level_4,
  sum(price_1sq_meter_uah)/count(*) price_1sq_meter_uah,
  sum(price_1sq_meter_usd)/count(*) price_1sq_meter_usd,
  sum(price_uah)/count(*) price_object_uah,
  sum(price_usd)/count(*) price_object_usd,
  count(*),
  2,
  min(price_1sq_meter_usd),
  max(price_1sq_meter_usd),
  4
from uvekon.re_advert u
 where 1=1
 and u.price_advert is not null
 and u.is_valid=true
 and date_relevance=(select date_relevance from uvekon.re_aggregate_period where type_period=1 and is_work)
group by id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ) 
  id_poligon_level_4,
  date_relevance;

-- Заполнение интегрированых даных: 1 level  1 gr
insert into uvekon.re_aggregate_info (
  date_relevance, -- Дата актуальности данных
  id_type_oper, -- Код операции с недвижимостью
  id_segment, -- Код сегмента
  id_poligon, -- Код полигона
  price_1sq_meter_uah , -- Средняя цена 1 кв.метра в гривне на дату актуальности данных
  price_1sq_meter_usd, -- Средняя цена 1 кв.метра в долларах на дату актуальности данных
  price_object_uah, -- Средняя цена объекта в гривне на дату актуальности данных
  price_object_usd, -- Средняя цена объекта в долларах на дату актуальности данных
  count_advert,
  level_group,
  min_1sq_meter_usd,
  max_1sq_meter_usd,
  level_poligon)
select date_relevance,
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_poligon_level_1,
  sum(price_1sq_meter_uah)/count(*) price_1sq_meter_uah,
  sum(price_1sq_meter_usd)/count(*) price_1sq_meter_usd,
  sum(price_uah)/count(*) price_object_uah,
  sum(price_usd)/count(*) price_object_usd,
  count(*),
  1,
  min(price_1sq_meter_usd),
  max(price_1sq_meter_usd),
  1
from uvekon.re_advert u
 where 1=1
 and u.price_advert is not null
 and u.is_valid=true
 and date_relevance=(select date_relevance from uvekon.re_aggregate_period where type_period=1 and is_work)
group by id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_poligon_level_1,
  date_relevance;

 -- Заполнение интегрированых даных: 2 level --- 1 gr
 insert into uvekon.re_aggregate_info (
  date_relevance, -- Дата актуальности данных
  id_type_oper, -- Код операции с недвижимостью
  id_segment, -- Код сегмента
  id_poligon, -- Код полигона
  price_1sq_meter_uah , -- Средняя цена 1 кв.метра в гривне на дату актуальности данных
  price_1sq_meter_usd, -- Средняя цена 1 кв.метра в долларах на дату актуальности данных
  price_object_uah, -- Средняя цена объекта в гривне на дату актуальности данных
  price_object_usd, -- Средняя цена объекта в долларах на дату актуальности данных
  count_advert,
  level_group,
  min_1sq_meter_usd,
  max_1sq_meter_usd,
  level_poligon)
select date_relevance,
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_poligon_level_2,
  sum(price_1sq_meter_uah)/count(*) price_1sq_meter_uah,
  sum(price_1sq_meter_usd)/count(*) price_1sq_meter_usd,
  sum(price_uah)/count(*) price_object_uah,
  sum(price_usd)/count(*) price_object_usd,
  count(*),
  1,
  min(price_1sq_meter_usd),
  max(price_1sq_meter_usd),
  2
from uvekon.re_advert u
 where 1=1
 and u.price_advert is not null
 and u.is_valid=true
 and date_relevance=(select date_relevance from uvekon.re_aggregate_period where type_period=1 and is_work)
group by id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_poligon_level_2,
  date_relevance;

 -- Заполнение интегрированых даных: 3 level ---- 1 gr
 insert into uvekon.re_aggregate_info (
  date_relevance, -- Дата актуальности данных
  id_type_oper, -- Код операции с недвижимостью
  id_segment, -- Код сегмента
  id_poligon, -- Код полигона
  price_1sq_meter_uah , -- Средняя цена 1 кв.метра в гривне на дату актуальности данных
  price_1sq_meter_usd, -- Средняя цена 1 кв.метра в долларах на дату актуальности данных
  price_object_uah, -- Средняя цена объекта в гривне на дату актуальности данных
  price_object_usd, -- Средняя цена объекта в долларах на дату актуальности данных
  count_advert,
  level_group,
  min_1sq_meter_usd,
  max_1sq_meter_usd,
  level_poligon)
select date_relevance,
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_poligon_level_3,
  sum(price_1sq_meter_uah)/count(*) price_1sq_meter_uah,
  sum(price_1sq_meter_usd)/count(*) price_1sq_meter_usd,
  sum(price_uah)/count(*) price_object_uah,
  sum(price_usd)/count(*) price_object_usd,
  count(*),
  1,
  min(price_1sq_meter_usd),
  max(price_1sq_meter_usd),
  3
from uvekon.re_advert u
 where 1=1
 and u.price_advert is not null
 and u.is_valid=true
 and date_relevance=(select date_relevance from uvekon.re_aggregate_period where type_period=1 and is_work)
group by id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_poligon_level_3,
  date_relevance;
  
  -- Заполнение интегрированых даных: 4 level ---- 1 gr
 insert into uvekon.re_aggregate_info (
  date_relevance, -- Дата актуальности данных
  id_type_oper, -- Код операции с недвижимостью
  id_segment, -- Код сегмента
  id_poligon, -- Код полигона
  price_1sq_meter_uah , -- Средняя цена 1 кв.метра в гривне на дату актуальности данных
  price_1sq_meter_usd, -- Средняя цена 1 кв.метра в долларах на дату актуальности данных
  price_object_uah, -- Средняя цена объекта в гривне на дату актуальности данных
  price_object_usd, -- Средняя цена объекта в долларах на дату актуальности данных
  count_advert,
  level_group,
  min_1sq_meter_usd,
  max_1sq_meter_usd,
  level_poligon)
select date_relevance,
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_poligon_level_4,
  sum(price_1sq_meter_uah)/count(*) price_1sq_meter_uah,
  sum(price_1sq_meter_usd)/count(*) price_1sq_meter_usd,
  sum(price_uah)/count(*) price_object_uah,
  sum(price_usd)/count(*) price_object_usd,
  count(*),
  1,
  min(price_1sq_meter_usd),
  max(price_1sq_meter_usd),
  4
from uvekon.re_advert u
 where 1=1
 and u.price_advert is not null
 and u.is_valid=true
 and date_relevance=(select date_relevance from uvekon.re_aggregate_period where type_period=1 and is_work)
group by id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_poligon_level_4,
  date_relevance;


 -- Заполнение интегрированых даных: 1  level ---- 5 gr
 insert into uvekon.re_aggregate_info (
  date_relevance, -- Дата актуальности данных
  id_type_oper, -- Код операции с недвижимостью
  id_segment, -- Код сегмента
  id_subsegment, -- Код подсегмента
  id_size_object, -- Код размерности объекта недвижимости
  id_poligon, -- Код полигона
  price_1sq_meter_uah , -- Средняя цена 1 кв.метра в гривне на дату актуальности данных
  price_1sq_meter_usd, -- Средняя цена 1 кв.метра в долларах на дату актуальности данных
  price_object_uah, -- Средняя цена объекта в гривне на дату актуальности данных
  price_object_usd, -- Средняя цена объекта в долларах на дату актуальности данных
  count_advert,
  level_group,
  min_1sq_meter_usd,
  max_1sq_meter_usd,
  level_poligon)
select
  date_relevance,
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)  
  id_size_object, -- Код размера объекта (РАСЧЕТНОЕ)
  u.id_poligon_level_1,
  sum(price_1sq_meter_uah)/count(*) price_1sq_meter_uah,
  sum(price_1sq_meter_usd)/count(*) price_1sq_meter_usd,
  sum(price_uah)/count(*) price_object_uah,
  sum(price_usd)/count(*) price_object_usd,
  count(*),
  5,
  min(price_1sq_meter_usd),
  max(price_1sq_meter_usd),
  1
from uvekon.re_advert u
 where 1=1
 and u.price_advert is not null
 and u.is_valid=true
 and date_relevance=(select date_relevance from uvekon.re_aggregate_period where type_period=1 and is_work)
group by id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_size_object, -- Код размера объекта (РАСЧЕТНОЕ)  
  id_poligon_level_1,
  date_relevance;

-- Заполнение интегрированых даных: 2  level ---- 5 gr
insert into uvekon.re_aggregate_info (
  date_relevance, -- Дата актуальности данных
  id_type_oper, -- Код операции с недвижимостью
  id_segment, -- Код сегмента
  id_subsegment, -- Код подсегмента  
  id_size_object, -- Код размерности объекта недвижимости
  id_poligon, -- Код полигона
  price_1sq_meter_uah , -- Средняя цена 1 кв.метра в гривне на дату актуальности данных
  price_1sq_meter_usd, -- Средняя цена 1 кв.метра в долларах на дату актуальности данных
  price_object_uah, -- Средняя цена объекта в гривне на дату актуальности данных
  price_object_usd, -- Средняя цена объекта в долларах на дату актуальности данных
  count_advert,
  level_group,
  min_1sq_meter_usd,
  max_1sq_meter_usd,
  level_poligon)
select date_relevance,
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)  
  id_size_object, -- Код размера объекта (РАСЧЕТНОЕ)
  id_poligon_level_2,
  sum(price_1sq_meter_uah)/count(*) price_1sq_meter_uah,
  sum(price_1sq_meter_usd)/count(*) price_1sq_meter_usd,
  sum(price_uah)/count(*) price_object_uah,
  sum(price_usd)/count(*) price_object_usd,
  count(*),
  5,
  min(price_1sq_meter_usd),
  max(price_1sq_meter_usd),
  2
from uvekon.re_advert u
 where 1=1
 and u.price_advert is not null
 and u.is_valid=true
 and date_relevance=(select date_relevance from uvekon.re_aggregate_period where type_period=1 and is_work)
group by id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_size_object, -- Код размера объекта (РАСЧЕТНОЕ)  
  id_poligon_level_2,
  date_relevance;
  
-- Заполнение интегрированых даных: 3  level ---- 5 gr
insert into uvekon.re_aggregate_info (
  date_relevance, -- Дата актуальности данных
  id_type_oper, -- Код операции с недвижимостью
  id_segment, -- Код сегмента
  id_subsegment, -- Код подсегмента
  id_size_object, -- Код размерности объекта недвижимости
  id_poligon, -- Код полигона
  price_1sq_meter_uah , -- Средняя цена 1 кв.метра в гривне на дату актуальности данных
  price_1sq_meter_usd, -- Средняя цена 1 кв.метра в долларах на дату актуальности данных
  price_object_uah, -- Средняя цена объекта в гривне на дату актуальности данных
  price_object_usd, -- Средняя цена объекта в долларах на дату актуальности данных
  count_advert,
  level_group,
  min_1sq_meter_usd,
  max_1sq_meter_usd,
  level_poligon)
select date_relevance,
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)  
  id_size_object, -- Код размера объекта (РАСЧЕТНОЕ)
  id_poligon_level_3,
  sum(price_1sq_meter_uah)/count(*) price_1sq_meter_uah,
  sum(price_1sq_meter_usd)/count(*) price_1sq_meter_usd,
  sum(price_uah)/count(*) price_object_uah,
  sum(price_usd)/count(*) price_object_usd,
  count(*),
  5,
  min(price_1sq_meter_usd),
  max(price_1sq_meter_usd),
  3
from uvekon.re_advert u
 where 1=1
 and u.price_advert is not null
 and u.is_valid=true
 and date_relevance=(select date_relevance from uvekon.re_aggregate_period where type_period=1 and is_work)
group by id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_size_object, -- Код размера объекта (РАСЧЕТНОЕ)
  id_poligon_level_3,
  date_relevance;

-- Заполнение интегрированых даных: 4  level ---- 5 gr
insert into uvekon.re_aggregate_info (
  date_relevance, -- Дата актуальности данных
  id_type_oper, -- Код операции с недвижимостью
  id_segment, -- Код сегмента
  id_subsegment, -- Код подсегмента  
  id_size_object, -- Код размерности объекта недвижимости
  id_poligon, -- Код полигона
  price_1sq_meter_uah , -- Средняя цена 1 кв.метра в гривне на дату актуальности данных
  price_1sq_meter_usd, -- Средняя цена 1 кв.метра в долларах на дату актуальности данных
  price_object_uah, -- Средняя цена объекта в гривне на дату актуальности данных
  price_object_usd, -- Средняя цена объекта в долларах на дату актуальности данных
  count_advert,
  level_group,
  min_1sq_meter_usd,
  max_1sq_meter_usd,
  level_poligon)
select date_relevance,
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)  
  id_size_object, -- Код размера объекта (РАСЧЕТНОЕ)
  id_poligon_level_4,
  sum(price_1sq_meter_uah)/count(*) price_1sq_meter_uah,
  sum(price_1sq_meter_usd)/count(*) price_1sq_meter_usd,
  sum(price_uah)/count(*) price_object_uah,
  sum(price_usd)/count(*) price_object_usd,
  count(*),
  5,
  min(price_1sq_meter_usd),
  max(price_1sq_meter_usd),
  4
from uvekon.re_advert u
 where 1=1
 and u.price_advert is not null
 and u.is_valid=true
 and date_relevance=(select date_relevance from uvekon.re_aggregate_period where type_period=1 and is_work)
group by id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_size_object, -- Код размера объекта (РАСЧЕТНОЕ)
  id_poligon_level_4,
  date_relevance;

