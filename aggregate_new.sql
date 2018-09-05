-- для медианы добавил кастомную анрегатную функцию в postgres - median() при помощи скрипта --
/* 
BEGIN;

-- median
-- http://wiki.postgresql.org/wiki/Aggregate_Median

CREATE OR REPLACE FUNCTION median(anyarray)
   RETURNS float8 AS
$$
  WITH q AS
  (
     SELECT val
     FROM unnest($1) val
     WHERE val IS NOT NULL
     ORDER BY 1
  ),
  cnt AS
  (
    SELECT COUNT(*) AS c FROM q
  )
  SELECT AVG(val)::float8
  FROM
  (
    SELECT val FROM q
    LIMIT  2 - MOD((SELECT c FROM cnt), 2)
    OFFSET GREATEST(CEIL((SELECT c FROM cnt) / 2.0) - 1,0)
  ) q2;
$$
LANGUAGE sql IMMUTABLE;

DROP AGGREGATE IF EXISTS median(numeric); -- old method
DROP AGGREGATE IF EXISTS median(anyelement);
CREATE AGGREGATE median(anyelement) (
  SFUNC=array_append,
  STYPE=anyarray,
  FINALFUNC=median,
  INITCOND='{}'
);

COMMIT;

*/

-- Заполнение интегрированых даных: 1 level   4 gr

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
  median_cost_usd_norm, -- Медиана стоимости(норм.) ***
  median_price_usd_norm, -- Медиана цены м2(норм.) ***
  std_cost_usd_norm, -- стандартное отклонение стоимости (норм.) ***
  std_price_usd_norm, -- стандартное отклонение цены м2 (норм.) ***
  count_advert,
  level_group,
  min_1sq_meter_usd,
  max_1sq_meter_usd,
  avg_ln_price_usd, -- техническое - ср. логарифма стоимости ***
  avg_ln_price_1sq_meter_usd, -- техническое - ср. логарифма цены м2 ***
  std_ln_price_usd, -- техническое - стандартное отклонение логарифма стоимости ***
  std_ln_price_1sq_meter_usd, -- техническое - стандартное отклонение логарифма цены м2 ***
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
  median(price_usd), -- ***
  median(price_1sq_meter_usd), -- ***
  stddev(price_usd), -- ***
  stddev(price_1sq_meter_usd), -- ***
  count(*),
  4,
  min(price_1sq_meter_usd),
  max(price_1sq_meter_usd),
  sum(ln_price_usd)/count(*) ln_price_usd, -- ***
  sum(ln_price_1sq_meter_usd)/count(*) ln_price_1sq_meter_usd, -- ***
  stddev(ln_price_usd), -- ***
  stddev(ln_price_1sq_meter_usd), -- ***
  1
from uvekon.re_advert u
 where 1=1
 and u.price_advert is not null
 and u.ln_price_usd <> 0 -- ***
 and u.ln_price_1sq_meter_usd <> 0 -- ***
 and u.is_valid=true
 and date_relevance=(select date_relevance from uvekon.re_aggregate_period where type_period=1 and is_work)
group by id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_size_object, -- Код размера объекта (РАСЧЕТНОЕ)
  id_class_subsegment, -- Код класса подсегмента (РАСЧЕТНАЯ)
  id_poligon_level_1,
  date_relevance;

 -- Заполнение интегрированых даных: 2 level   4 gr
 
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
  median_cost_usd_norm, -- Медиана стоимости(норм.) ***
  median_price_usd_norm, -- Медиана цены м2(норм.) ***
  std_cost_usd_norm, -- стандартное отклонение стоимости (норм.) ***
  std_price_usd_norm, -- стандартное отклонение цены м2 (норм.) ***
  count_advert,
  level_group,
  min_1sq_meter_usd,
  max_1sq_meter_usd,
  avg_ln_price_usd, -- техническое - ср. логарифма стоимости ***
  avg_ln_price_1sq_meter_usd, -- техническое - ср. логарифма цены м2 ***
  std_ln_price_usd, -- техническое - стандартное отклонение логарифма стоимости ***
  std_ln_price_1sq_meter_usd, -- техническое - стандартное отклонение логарифма цены м2 ***
  level_poligon)
select
  date_relevance,
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_class_subsegment, -- Код класса подсегмента (РАСЧЕТНАЯ)
  id_size_object, -- Код размера объекта (РАСЧЕТНОЕ)
  u.id_poligon_level_2,
  sum(price_1sq_meter_uah)/count(*) price_1sq_meter_uah,
  sum(price_1sq_meter_usd)/count(*) price_1sq_meter_usd,
  sum(price_uah)/count(*) price_object_uah,
  sum(price_usd)/count(*) price_object_usd,
  median(price_usd), -- ***
  median(price_1sq_meter_usd), -- ***
  stddev(price_usd), -- ***
  stddev(price_1sq_meter_usd), -- ***
  count(*),
  4,
  min(price_1sq_meter_usd),
  max(price_1sq_meter_usd),
  sum(ln_price_usd)/count(*) ln_price_usd, -- ***
  sum(ln_price_1sq_meter_usd)/count(*) ln_price_1sq_meter_usd, -- ***
  stddev(ln_price_usd), -- ***
  stddev(ln_price_1sq_meter_usd), -- ***
  2
from uvekon.re_advert u
 where 1=1
 and u.price_advert is not null
 and u.ln_price_usd <> 0 -- ***
 and u.ln_price_1sq_meter_usd <> 0 -- ***
 and u.is_valid=true
 and date_relevance=(select date_relevance from uvekon.re_aggregate_period where type_period=1 and is_work)
group by id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_size_object, -- Код размера объекта (РАСЧЕТНОЕ)
  id_class_su
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  ance;

  -- Заполнение интегрированых даных: 3 level   4 gr
  
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
  median_cost_usd_norm, -- Медиана стоимости(норм.) ***
  median_price_usd_norm, -- Медиана цены м2(норм.) ***
  std_cost_usd_norm, -- стандартное отклонение стоимости (норм.) ***
  std_price_usd_norm, -- стандартное отклонение цены м2 (норм.) ***
  count_advert,
  level_group,
  min_1sq_meter_usd,
  max_1sq_meter_usd,
  avg_ln_price_usd, -- техническое - ср. логарифма стоимости ***
  avg_ln_price_1sq_meter_usd, -- техническое - ср. логарифма цены м2 ***
  std_ln_price_usd, -- техническое - стандартное отклонение логарифма стоимости ***
  std_ln_price_1sq_meter_usd, -- техническое - стандартное отклонение логарифма цены м2 ***
  level_poligon)
select
  date_relevance,
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_class_subsegment, -- Код класса подсегмента (РАСЧЕТНАЯ)
  id_size_object, -- Код размера объекта (РАСЧЕТНОЕ)
  u.id_poligon_level_3,
  sum(price_1sq_meter_uah)/count(*) price_1sq_meter_uah,
  sum(price_1sq_meter_usd)/count(*) price_1sq_meter_usd,
  sum(price_uah)/count(*) price_object_uah,
  sum(price_usd)/count(*) price_object_usd,
  median(price_usd), -- ***
  median(price_1sq_meter_usd), -- ***
  stddev(price_usd), -- ***
  stddev(price_1sq_meter_usd), -- ***
  count(*),
  4,
  min(price_1sq_meter_usd),
  max(price_1sq_meter_usd),
  sum(ln_price_usd)/count(*) ln_price_usd, -- ***
  sum(ln_price_1sq_meter_usd)/count(*) ln_price_1sq_meter_usd, -- ***
  stddev(ln_price_usd), -- ***
  stddev(ln_price_1sq_meter_usd), -- ***
  3
from uvekon.re_advert u
 where 1=1
 and u.price_advert is not null
 and u.ln_price_usd <> 0 -- ***
 and u.ln_price_1sq_meter_usd <> 0 -- ***
 and u.is_valid=true
 and date_relevance=(select date_relevance from uvekon.re_aggregate_period where type_period=1 and is_work)
group by id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_size_object, -- Код размера объекта (РАСЧЕТНОЕ)
  id_class_subsegment, -- Код класса подсегмента (РАСЧЕТНАЯ)
  id_poligon_level_3,
  date_relevance;
  
   -- Заполнение интегрированых даных: 4 level   4 gr
   
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
  median_cost_usd_norm, -- Медиана стоимости(норм.) ***
  median_price_usd_norm, -- Медиана цены м2(норм.) ***
  std_cost_usd_norm, -- стандартное отклонение стоимости (норм.) ***
  std_price_usd_norm, -- стандартное отклонение цены м2 (норм.) ***
  count_advert,
  level_group,
  min_1sq_meter_usd,
  max_1sq_meter_usd,
  avg_ln_price_usd, -- техническое - ср. логарифма стоимости ***
  avg_ln_price_1sq_meter_usd, -- техническое - ср. логарифма цены м2 ***
  std_ln_price_usd, -- техническое - стандартное отклонение логарифма стоимости ***
  std_ln_price_1sq_meter_usd, -- техническое - стандартное отклонение логарифма цены м2 ***
  level_poligon)
select
  date_relevance,
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_class_subsegment, -- Код класса подсегмента (РАСЧЕТНАЯ)
  id_size_object, -- Код размера объекта (РАСЧЕТНОЕ)
  u.id_poligon_level_4,
  sum(price_1sq_meter_uah)/count(*) price_1sq_meter_uah,
  sum(price_1sq_meter_usd)/count(*) price_1sq_meter_usd,
  sum(price_uah)/count(*) price_object_uah,
  sum(price_usd)/count(*) price_object_usd,
  median(price_usd), -- ***
  median(price_1sq_meter_usd), -- ***
  stddev(price_usd), -- ***
  stddev(price_1sq_meter_usd), -- ***
  count(*),
  4,
  min(price_1sq_meter_usd),
  max(price_1sq_meter_usd),
  sum(ln_price_usd)/count(*) ln_price_usd, -- ***
  sum(ln_price_1sq_meter_usd)/count(*) ln_price_1sq_meter_usd, -- ***
  stddev(ln_price_usd), -- ***
  stddev(ln_price_1sq_meter_usd), -- ***
  4
from uvekon.re_advert u
 where 1=1
 and u.price_advert is not null
 and u.ln_price_usd <> 0 -- ***
 and u.ln_price_1sq_meter_usd <> 0 -- ***
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
  median_cost_usd_norm, -- Медиана стоимости(норм.) ***
  median_price_usd_norm, -- Медиана цены м2(норм.) ***
  std_cost_usd_norm, -- стандартное отклонение стоимости (норм.) ***
  std_price_usd_norm, -- стандартное отклонение цены м2 (норм.) ***
  count_advert,
  level_group,
  min_1sq_meter_usd,
  max_1sq_meter_usd,
  avg_ln_price_usd, -- техническое - ср. логарифма стоимости ***
  avg_ln_price_1sq_meter_usd, -- техническое - ср. логарифма цены м2 ***
  std_ln_price_usd, -- техническое - стандартное отклонение логарифма стоимости ***
  std_ln_price_1sq_meter_usd, -- техническое - стандартное отклонение логарифма цены м2 ***
  level_poligon)
select
  date_relevance,
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_class_subsegment, -- Код класса подсегмента (РАСЧЕТНАЯ)
  u.id_poligon_level_1,
  sum(price_1sq_meter_uah)/count(*) price_1sq_meter_uah,
  sum(price_1sq_meter_usd)/count(*) price_1sq_meter_usd,
  sum(price_uah)/count(*) price_object_uah,
  sum(price_usd)/count(*) price_object_usd,
  median(price_usd), -- ***
  median(price_1sq_meter_usd), -- ***
  stddev(price_usd), -- ***
  stddev(price_1sq_meter_usd), -- ***
  count(*),
  3,
  min(price_1sq_meter_usd),
  max(price_1sq_meter_usd),
  sum(ln_price_usd)/count(*) ln_price_usd, -- ***
  sum(ln_price_1sq_meter_usd)/count(*) ln_price_1sq_meter_usd, -- ***
  stddev(ln_price_usd), -- ***
  stddev(ln_price_1sq_meter_usd), -- ***
  1
from uvekon.re_advert u
 where 1=1
 and u.price_advert is not null
 and u.ln_price_usd <> 0 -- ***
 and u.ln_price_1sq_meter_usd <> 0 -- ***
 and u.is_valid=true
 and date_relevance=(select date_relevance from uvekon.re_aggregate_period where type_period=1 and is_work)
group by id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_class_subsegment, -- Код класса подсегмента (РАСЧЕТНАЯ)
  id_poligon_level_1,
  date_relevance;
  
-- Заполнение интегрированых даных: 2 level  3 gr
  
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
  median_cost_usd_norm, -- Медиана стоимости(норм.) ***
  median_price_usd_norm, -- Медиана цены м2(норм.) ***
  std_cost_usd_norm, -- стандартное отклонение стоимости (норм.) ***
  std_price_usd_norm, -- стандартное отклонение цены м2 (норм.) ***
  count_advert,
  level_group,
  min_1sq_meter_usd,
  max_1sq_meter_usd,
  avg_ln_price_usd, -- техническое - ср. логарифма стоимости ***
  avg_ln_price_1sq_meter_usd, -- техническое - ср. логарифма цены м2 ***
  std_ln_price_usd, -- техническое - стандартное отклонение логарифма стоимости ***
  std_ln_price_1sq_meter_usd, -- техническое - стандартное отклонение логарифма цены м2 ***
  level_poligon)
select
  date_relevance,
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_class_subsegment, -- Код класса подсегмента (РАСЧЕТНАЯ)
  u.id_poligon_level_2,
  sum(price_1sq_meter_uah)/count(*) price_1sq_meter_uah,
  sum(price_1sq_meter_usd)/count(*) price_1sq_meter_usd,
  sum(price_uah)/count(*) price_object_uah,
  sum(price_usd)/count(*) price_object_usd,
  median(price_usd), -- ***
  median(price_1sq_meter_usd), -- ***
  stddev(price_usd), -- ***
  stddev(price_1sq_meter_usd), -- ***
  count(*),
  3,
  min(price_1sq_meter_usd),
  max(price_1sq_meter_usd),
  sum(ln_price_usd)/count(*) ln_price_usd, -- ***
  sum(ln_price_1sq_meter_usd)/count(*) ln_price_1sq_meter_usd, -- ***
  stddev(ln_price_usd), -- ***
  stddev(ln_price_1sq_meter_usd), -- ***
  2
from uvekon.re_advert u
 where 1=1
 and u.price_advert is not null
 and u.ln_price_usd <> 0 -- ***
 and u.ln_price_1sq_meter_usd <> 0 -- ***
 and u.is_valid=true
 and date_relevance=(select date_relevance from uvekon.re_aggregate_period where type_period=1 and is_work)
group by id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_class_subsegment, -- Код класса подсегмента (РАСЧЕТНАЯ)
  id_poligon_level_2,
  date_relevance;
  
   -- Заполнение интегрированых даных: 3 level  3 gr
   
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
  median_cost_usd_norm, -- Медиана стоимости(норм.) ***
  median_price_usd_norm, -- Медиана цены м2(норм.) ***
  std_cost_usd_norm, -- стандартное отклонение стоимости (норм.) ***
  std_price_usd_norm, -- стандартное отклонение цены м2 (норм.) ***
  count_advert,
  level_group,
  min_1sq_meter_usd,
  max_1sq_meter_usd,
  avg_ln_price_usd, -- техническое - ср. логарифма стоимости ***
  avg_ln_price_1sq_meter_usd, -- техническое - ср. логарифма цены м2 ***
  std_ln_price_usd, -- техническое - стандартное отклонение логарифма стоимости ***
  std_ln_price_1sq_meter_usd, -- техническое - стандартное отклонение логарифма цены м2 ***
  level_poligon)
select
  date_relevance,
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_class_subsegment, -- Код класса подсегмента (РАСЧЕТНАЯ)
  u.id_poligon_level_3,
  sum(price_1sq_meter_uah)/count(*) price_1sq_meter_uah,
  sum(price_1sq_meter_usd)/count(*) price_1sq_meter_usd,
  sum(price_uah)/count(*) price_object_uah,
  sum(price_usd)/count(*) price_object_usd,
  median(price_usd), -- ***
  median(price_1sq_meter_usd), -- ***
  stddev(price_usd), -- ***
  stddev(price_1sq_meter_usd), -- ***
  count(*),
  3,
  min(price_1sq_meter_usd),
  max(price_1sq_meter_usd),
  sum(ln_price_usd)/count(*) ln_price_usd, -- ***
  sum(ln_price_1sq_meter_usd)/count(*) ln_price_1sq_meter_usd, -- ***
  stddev(ln_price_usd), -- ***
  stddev(ln_price_1sq_meter_usd), -- ***
  3
from uvekon.re_advert u
 where 1=1
 and u.price_advert is not null
 and u.ln_price_usd <> 0 -- ***
 and u.ln_price_1sq_meter_usd <> 0 -- ***
 and u.is_valid=true
 and date_relevance=(select date_relevance from uvekon.re_aggregate_period where type_period=1 and is_work)
group by id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_class_subsegment, -- Код класса подсегмента (РАСЧЕТНАЯ)
  id_poligon_level_3,
  date_relevance;
  
-- Заполнение интегрированых даных: 4 level  3 gr

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
  median_cost_usd_norm, -- Медиана стоимости(норм.) ***
  median_price_usd_norm, -- Медиана цены м2(норм.) ***
  std_cost_usd_norm, -- стандартное отклонение стоимости (норм.) ***
  std_price_usd_norm, -- стандартное отклонение цены м2 (норм.) ***
  count_advert,
  level_group,
  min_1sq_meter_usd,
  max_1sq_meter_usd,
  avg_ln_price_usd, -- техническое - ср. логарифма стоимости ***
  avg_ln_price_1sq_meter_usd, -- техническое - ср. логарифма цены м2 ***
  std_ln_price_usd, -- техническое - стандартное отклонение логарифма стоимости ***
  std_ln_price_1sq_meter_usd, -- техническое - стандартное отклонение логарифма цены м2 ***
  level_poligon)
select
  date_relevance,
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_class_subsegment, -- Код класса подсегмента (РАСЧЕТНАЯ)
  u.id_poligon_level_4,
  sum(price_1sq_meter_uah)/count(*) price_1sq_meter_uah,
  sum(price_1sq_meter_usd)/count(*) price_1sq_meter_usd,
  sum(price_uah)/count(*) price_object_uah,
  sum(price_usd)/count(*) price_object_usd,
  median(price_usd), -- ***
  median(price_1sq_meter_usd), -- ***
  stddev(price_usd), -- ***
  stddev(price_1sq_meter_usd), -- ***
  count(*),
  3,
  min(price_1sq_meter_usd),
  max(price_1sq_meter_usd),
  sum(ln_price_usd)/count(*) ln_price_usd, -- ***
  sum(ln_price_1sq_meter_usd)/count(*) ln_price_1sq_meter_usd, -- ***
  stddev(ln_price_usd), -- ***
  stddev(ln_price_1sq_meter_usd), -- ***
  4
from uvekon.re_advert u
 where 1=1
 and u.price_advert is not null
 and u.ln_price_usd <> 0 -- ***
 and u.ln_price_1sq_meter_usd <> 0 -- ***
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
  median_cost_usd_norm, -- Медиана стоимости(норм.) ***
  median_price_usd_norm, -- Медиана цены м2(норм.) ***
  std_cost_usd_norm, -- стандартное отклонение стоимости (норм.) ***
  std_price_usd_norm, -- стандартное отклонение цены м2 (норм.) ***
  count_advert,
  level_group,
  min_1sq_meter_usd,
  max_1sq_meter_usd,
  avg_ln_price_usd, -- техническое - ср. логарифма стоимости ***
  avg_ln_price_1sq_meter_usd, -- техническое - ср. логарифма цены м2 ***
  std_ln_price_usd, -- техническое - стандартное отклонение логарифма стоимости ***
  std_ln_price_1sq_meter_usd, -- техническое - стандартное отклонение логарифма цены м2 ***
  level_poligon)
select
  date_relevance,
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  u.id_poligon_level_1,
  sum(price_1sq_meter_uah)/count(*) price_1sq_meter_uah,
  sum(price_1sq_meter_usd)/count(*) price_1sq_meter_usd,
  sum(price_uah)/count(*) price_object_uah,
  sum(price_usd)/count(*) price_object_usd,
  median(price_usd), -- ***
  median(price_1sq_meter_usd), -- ***
  stddev(price_usd), -- ***
  stddev(price_1sq_meter_usd), -- ***
  count(*),
  2,
  min(price_1sq_meter_usd),
  max(price_1sq_meter_usd),
  sum(ln_price_usd)/count(*) ln_price_usd, -- ***
  sum(ln_price_1sq_meter_usd)/count(*) ln_price_1sq_meter_usd, -- ***
  stddev(ln_price_usd), -- ***
  stddev(ln_price_1sq_meter_usd), -- ***
  1
from uvekon.re_advert u
 where 1=1
 and u.price_advert is not null
 and u.ln_price_usd <> 0 -- ***
 and u.ln_price_1sq_meter_usd <> 0 -- ***
 and u.is_valid=true
 and date_relevance=(select date_relevance from uvekon.re_aggregate_period where type_period=1 and is_work)
group by id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_poligon_level_1,
  date_relevance;
  
-- Заполнение интегрированых даных: 2 level  2 gr

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
  median_cost_usd_norm, -- Медиана стоимости(норм.) ***
  median_price_usd_norm, -- Медиана цены м2(норм.) ***
  std_cost_usd_norm, -- стандартное отклонение стоимости (норм.) ***
  std_price_usd_norm, -- стандартное отклонение цены м2 (норм.) ***
  count_advert,
  level_group,
  min_1sq_meter_usd,
  max_1sq_meter_usd,
  avg_ln_price_usd, -- техническое - ср. логарифма стоимости ***
  avg_ln_price_1sq_meter_usd, -- техническое - ср. логарифма цены м2 ***
  std_ln_price_usd, -- техническое - стандартное отклонение логарифма стоимости ***
  std_ln_price_1sq_meter_usd, -- техническое - стандартное отклонение логарифма цены м2 ***
  level_poligon)
select
  date_relevance,
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  u.id_poligon_level_2,
  sum(price_1sq_meter_uah)/count(*) price_1sq_meter_uah,
  sum(price_1sq_meter_usd)/count(*) price_1sq_meter_usd,
  sum(price_uah)/count(*) price_object_uah,
  sum(price_usd)/count(*) price_object_usd,
  median(price_usd), -- ***
  median(price_1sq_meter_usd), -- ***
  stddev(price_usd), -- ***
  stddev(price_1sq_meter_usd), -- ***
  count(*),
  2,
  min(price_1sq_meter_usd),
  max(price_1sq_meter_usd),
  sum(ln_price_usd)/count(*) ln_price_usd, -- ***
  sum(ln_price_1sq_meter_usd)/count(*) ln_price_1sq_meter_usd, -- ***
  stddev(ln_price_usd), -- ***
  stddev(ln_price_1sq_meter_usd), -- ***
  2
from uvekon.re_advert u
 where 1=1
 and u.price_advert is not null
 and u.ln_price_usd <> 0 -- ***
 and u.ln_price_1sq_meter_usd <> 0 -- ***
 and u.is_valid=true
 and date_relevance=(select date_relevance from uvekon.re_aggregate_period where type_period=1 and is_work)
group by id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_poligon_level_2,
  date_relevance;
  
-- Заполнение интегрированых даных: 3 level  2 gr

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
  median_cost_usd_norm, -- Медиана стоимости(норм.) ***
  median_price_usd_norm, -- Медиана цены м2(норм.) ***
  std_cost_usd_norm, -- стандартное отклонение стоимости (норм.) ***
  std_price_usd_norm, -- стандартное отклонение цены м2 (норм.) ***
  count_advert,
  level_group,
  min_1sq_meter_usd,
  max_1sq_meter_usd,
  avg_ln_price_usd, -- техническое - ср. логарифма стоимости ***
  avg_ln_price_1sq_meter_usd, -- техническое - ср. логарифма цены м2 ***
  std_ln_price_usd, -- техническое - стандартное отклонение логарифма стоимости ***
  std_ln_price_1sq_meter_usd, -- техническое - стандартное отклонение логарифма цены м2 ***
  level_poligon)
select
  date_relevance,
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  u.id_poligon_level_3,
  sum(price_1sq_meter_uah)/count(*) price_1sq_meter_uah,
  sum(price_1sq_meter_usd)/count(*) price_1sq_meter_usd,
  sum(price_uah)/count(*) price_object_uah,
  sum(price_usd)/count(*) price_object_usd,
  median(price_usd), -- ***
  median(price_1sq_meter_usd), -- ***
  stddev(price_usd), -- ***
  stddev(price_1sq_meter_usd), -- ***
  count(*),
  2,
  min(price_1sq_meter_usd),
  max(price_1sq_meter_usd),
  sum(ln_price_usd)/count(*) ln_price_usd, -- ***
  sum(ln_price_1sq_meter_usd)/count(*) ln_price_1sq_meter_usd, -- ***
  stddev(ln_price_usd), -- ***
  stddev(ln_price_1sq_meter_usd), -- ***
  3
from uvekon.re_advert u
 where 1=1
 and u.price_advert is not null
 and u.ln_price_usd <> 0 -- ***
 and u.ln_price_1sq_meter_usd <> 0 -- ***
 and u.is_valid=true
 and date_relevance=(select date_relevance from uvekon.re_aggregate_period where type_period=1 and is_work)
group by id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_poligon_level_3,
  date_relevance;
  
  -- Заполнение интегрированых даных: 4 level  2 gr
  
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
  median_cost_usd_norm, -- Медиана стоимости(норм.) ***
  median_price_usd_norm, -- Медиана цены м2(норм.) ***
  std_cost_usd_norm, -- стандартное отклонение стоимости (норм.) ***
  std_price_usd_norm, -- стандартное отклонение цены м2 (норм.) ***
  count_advert,
  level_group,
  min_1sq_meter_usd,
  max_1sq_meter_usd,
  avg_ln_price_usd, -- техническое - ср. логарифма стоимости ***
  avg_ln_price_1sq_meter_usd, -- техническое - ср. логарифма цены м2 ***
  std_ln_price_usd, -- техническое - стандартное отклонение логарифма стоимости ***
  std_ln_price_1sq_meter_usd, -- техническое - стандартное отклонение логарифма цены м2 ***
  level_poligon)
select
  date_relevance,
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  u.id_poligon_level_4,
  sum(price_1sq_meter_uah)/count(*) price_1sq_meter_uah,
  sum(price_1sq_meter_usd)/count(*) price_1sq_meter_usd,
  sum(price_uah)/count(*) price_object_uah,
  sum(price_usd)/count(*) price_object_usd,
  median(price_usd), -- ***
  median(price_1sq_meter_usd), -- ***
  stddev(price_usd), -- ***
  stddev(price_1sq_meter_usd), -- ***
  count(*),
  2,
  min(price_1sq_meter_usd),
  max(price_1sq_meter_usd),
  sum(ln_price_usd)/count(*) ln_price_usd, -- ***
  sum(ln_price_1sq_meter_usd)/count(*) ln_price_1sq_meter_usd, -- ***
  stddev(ln_price_usd), -- ***
  stddev(ln_price_1sq_meter_usd), -- ***
  4
from uvekon.re_advert u
 where 1=1
 and u.price_advert is not null
 and u.ln_price_usd <> 0 -- ***
 and u.ln_price_1sq_meter_usd <> 0 -- ***
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
  median_cost_usd_norm, -- Медиана стоимости(норм.) ***
  median_price_usd_norm, -- Медиана цены м2(норм.) ***
  std_cost_usd_norm, -- стандартное отклонение стоимости (норм.) ***
  std_price_usd_norm, -- стандартное отклонение цены м2 (норм.) ***
  count_advert,
  level_group,
  min_1sq_meter_usd,
  max_1sq_meter_usd,
  avg_ln_price_usd, -- техническое - ср. логарифма стоимости ***
  avg_ln_price_1sq_meter_usd, -- техническое - ср. логарифма цены м2 ***
  std_ln_price_usd, -- техническое - стандартное отклонение логарифма стоимости ***
  std_ln_price_1sq_meter_usd, -- техническое - стандартное отклонение логарифма цены м2 ***
  level_poligon)
select
  date_relevance,
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  u.id_poligon_level_1,
  sum(price_1sq_meter_uah)/count(*) price_1sq_meter_uah,
  sum(price_1sq_meter_usd)/count(*) price_1sq_meter_usd,
  sum(price_uah)/count(*) price_object_uah,
  sum(price_usd)/count(*) price_object_usd,
  median(price_usd), -- ***
  median(price_1sq_meter_usd), -- ***
  stddev(price_usd), -- ***
  stddev(price_1sq_meter_usd), -- ***
  count(*),
  1,
  min(price_1sq_meter_usd),
  max(price_1sq_meter_usd),
  sum(ln_price_usd)/count(*) ln_price_usd, -- ***
  sum(ln_price_1sq_meter_usd)/count(*) ln_price_1sq_meter_usd, -- ***
  stddev(ln_price_usd), -- ***
  stddev(ln_price_1sq_meter_usd), -- ***
  1
from uvekon.re_advert u
 where 1=1
 and u.price_advert is not null
 and u.ln_price_usd <> 0 -- ***
 and u.ln_price_1sq_meter_usd <> 0 -- ***
 and u.is_valid=true
 and date_relevance=(select date_relevance from uvekon.re_aggregate_period where type_period=1 and is_work)
group by id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_poligon_level_1,
  date_relevance;
  
-- Заполнение интегрированых даных: 2 level  1 gr

insert into uvekon.re_aggregate_info (
  date_relevance, -- Дата актуальности данных
  id_type_oper, -- Код операции с недвижимостью
  id_segment, -- Код сегмента
  id_poligon, -- Код полигона
  price_1sq_meter_uah , -- Средняя цена 1 кв.метра в гривне на дату актуальности данных
  price_1sq_meter_usd, -- Средняя цена 1 кв.метра в долларах на дату актуальности данных
  price_object_uah, -- Средняя цена объекта в гривне на дату актуальности данных
  price_object_usd, -- Средняя цена объекта в долларах на дату актуальности данных
  median_cost_usd_norm, -- Медиана стоимости(норм.) ***
  median_price_usd_norm, -- Медиана цены м2(норм.) ***
  std_cost_usd_norm, -- стандартное отклонение стоимости (норм.) ***
  std_price_usd_norm, -- стандартное отклонение цены м2 (норм.) ***
  count_advert,
  level_group,
  min_1sq_meter_usd,
  max_1sq_meter_usd,
  avg_ln_price_usd, -- техническое - ср. логарифма стоимости ***
  avg_ln_price_1sq_meter_usd, -- техническое - ср. логарифма цены м2 ***
  std_ln_price_usd, -- техническое - стандартное отклонение логарифма стоимости ***
  std_ln_price_1sq_meter_usd, -- техническое - стандартное отклонение логарифма цены м2 ***
  level_poligon)
select
  date_relevance,
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  u.id_poligon_level_2,
  sum(price_1sq_meter_uah)/count(*) price_1sq_meter_uah,
  sum(price_1sq_meter_usd)/count(*) price_1sq_meter_usd,
  sum(price_uah)/count(*) price_object_uah,
  sum(price_usd)/count(*) price_object_usd,
  median(price_usd), -- ***
  median(price_1sq_meter_usd), -- ***
  stddev(price_usd), -- ***
  stddev(price_1sq_meter_usd), -- ***
  count(*),
  1,
  min(price_1sq_meter_usd),
  max(price_1sq_meter_usd),
  sum(ln_price_usd)/count(*) ln_price_usd, -- ***
  sum(ln_price_1sq_meter_usd)/count(*) ln_price_1sq_meter_usd, -- ***
  stddev(ln_price_usd), -- ***
  stddev(ln_price_1sq_meter_usd), -- ***
  2
from uvekon.re_advert u
 where 1=1
 and u.price_advert is not null
 and u.ln_price_usd <> 0 -- ***
 and u.ln_price_1sq_meter_usd <> 0 -- ***
 and u.is_valid=true
 and date_relevance=(select date_relevance from uvekon.re_aggregate_period where type_period=1 and is_work)
group by id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_poligon_level_2,
  date_relevance;
  
 -- Заполнение интегрированых даных: 3 level  1 gr

insert into uvekon.re_aggregate_info (
  date_relevance, -- Дата актуальности данных
  id_type_oper, -- Код операции с недвижимостью
  id_segment, -- Код сегмента
  id_poligon, -- Код полигона
  price_1sq_meter_uah , -- Средняя цена 1 кв.метра в гривне на дату актуальности данных
  price_1sq_meter_usd, -- Средняя цена 1 кв.метра в долларах на дату актуальности данных
  price_object_uah, -- Средняя цена объекта в гривне на дату актуальности данных
  price_object_usd, -- Средняя цена объекта в долларах на дату актуальности данных
  median_cost_usd_norm, -- Медиана стоимости(норм.) ***
  median_price_usd_norm, -- Медиана цены м2(норм.) ***
  std_cost_usd_norm, -- стандартное отклонение стоимости (норм.) ***
  std_price_usd_norm, -- стандартное отклонение цены м2 (норм.) ***
  count_advert,
  level_group,
  min_1sq_meter_usd,
  max_1sq_meter_usd,
  avg_ln_price_usd, -- техническое - ср. логарифма стоимости ***
  avg_ln_price_1sq_meter_usd, -- техническое - ср. логарифма цены м2 ***
  std_ln_price_usd, -- техническое - стандартное отклонение логарифма стоимости ***
  std_ln_price_1sq_meter_usd, -- техническое - стандартное отклонение логарифма цены м2 ***
  level_poligon)
select
  date_relevance,
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  u.id_poligon_level_3,
  sum(price_1sq_meter_uah)/count(*) price_1sq_meter_uah,
  sum(price_1sq_meter_usd)/count(*) price_1sq_meter_usd,
  sum(price_uah)/count(*) price_object_uah,
  sum(price_usd)/count(*) price_object_usd,
  median(price_usd), -- ***
  median(price_1sq_meter_usd), -- ***
  stddev(price_usd), -- ***
  stddev(price_1sq_meter_usd), -- ***
  count(*),
  1,
  min(price_1sq_meter_usd),
  max(price_1sq_meter_usd),
  sum(ln_price_usd)/count(*) ln_price_usd, -- ***
  sum(ln_price_1sq_meter_usd)/count(*) ln_price_1sq_meter_usd, -- ***
  stddev(ln_price_usd), -- ***
  stddev(ln_price_1sq_meter_usd), -- ***
  3
from uvekon.re_advert u
 where 1=1
 and u.price_advert is not null
 and u.ln_price_usd <> 0 -- ***
 and u.ln_price_1sq_meter_usd <> 0 -- ***
 and u.is_valid=true
 and date_relevance=(select date_relevance from uvekon.re_aggregate_period where type_period=1 and is_work)
group by id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_poligon_level_3,
  date_relevance;
  
-- Заполнение интегрированых даных: 4 level  1 gr

insert into uvekon.re_aggregate_info (
  date_relevance, -- Дата актуальности данных
  id_type_oper, -- Код операции с недвижимостью
  id_segment, -- Код сегмента
  id_poligon, -- Код полигона
  price_1sq_meter_uah , -- Средняя цена 1 кв.метра в гривне на дату актуальности данных
  price_1sq_meter_usd, -- Средняя цена 1 кв.метра в долларах на дату актуальности данных
  price_object_uah, -- Средняя цена объекта в гривне на дату актуальности данных
  price_object_usd, -- Средняя цена объекта в долларах на дату актуальности данных
  median_cost_usd_norm, -- Медиана стоимости(норм.) ***
  median_price_usd_norm, -- Медиана цены м2(норм.) ***
  std_cost_usd_norm, -- стандартное отклонение стоимости (норм.) ***
  std_price_usd_norm, -- стандартное отклонение цены м2 (норм.) ***
  count_advert,
  level_group,
  min_1sq_meter_usd,
  max_1sq_meter_usd,
  avg_ln_price_usd, -- техническое - ср. логарифма стоимости ***
  avg_ln_price_1sq_meter_usd, -- техническое - ср. логарифма цены м2 ***
  std_ln_price_usd, -- техническое - стандартное отклонение логарифма стоимости ***
  std_ln_price_1sq_meter_usd, -- техническое - стандартное отклонение логарифма цены м2 ***
  level_poligon)
select
  date_relevance,
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  u.id_poligon_level_4,
  sum(price_1sq_meter_uah)/count(*) price_1sq_meter_uah,
  sum(price_1sq_meter_usd)/count(*) price_1sq_meter_usd,
  sum(price_uah)/count(*) price_object_uah,
  sum(price_usd)/count(*) price_object_usd,
  median(price_usd), -- ***
  median(price_1sq_meter_usd), -- ***
  stddev(price_usd), -- ***
  stddev(price_1sq_meter_usd), -- ***
  count(*),
  1,
  min(price_1sq_meter_usd),
  max(price_1sq_meter_usd),
  sum(ln_price_usd)/count(*) ln_price_usd, -- ***
  sum(ln_price_1sq_meter_usd)/count(*) ln_price_1sq_meter_usd, -- ***
  stddev(ln_price_usd), -- ***
  stddev(ln_price_1sq_meter_usd), -- ***
  4
from uvekon.re_advert u
 where 1=1
 and u.price_advert is not null
 and u.ln_price_usd <> 0 -- ***
 and u.ln_price_1sq_meter_usd <> 0 -- ***
 and u.is_valid=true
 and date_relevance=(select date_relevance from uvekon.re_aggregate_period where type_period=1 and is_work)
group by id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_poligon_level_4,
  date_relevance;
  
  
 -- Заполнение интегрированых даных: 1 level  5 gr

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
  median_cost_usd_norm, -- Медиана стоимости(норм.) ***
  median_price_usd_norm, -- Медиана цены м2(норм.) ***
  std_cost_usd_norm, -- стандартное отклонение стоимости (норм.) ***
  std_price_usd_norm, -- стандартное отклонение цены м2 (норм.) ***
  count_advert,
  level_group,
  min_1sq_meter_usd,
  max_1sq_meter_usd,
  avg_ln_price_usd, -- техническое - ср. логарифма стоимости ***
  avg_ln_price_1sq_meter_usd, -- техническое - ср. логарифма цены м2 ***
  std_ln_price_usd, -- техническое - стандартное отклонение логарифма стоимости ***
  std_ln_price_1sq_meter_usd, -- техническое - стандартное отклонение логарифма цены м2 ***
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
  median(price_usd), -- ***
  median(price_1sq_meter_usd), -- ***
  stddev(price_usd), -- ***
  stddev(price_1sq_meter_usd), -- ***
  count(*),
  5,
  min(price_1sq_meter_usd),
  max(price_1sq_meter_usd),
  sum(ln_price_usd)/count(*) ln_price_usd, -- ***
  sum(ln_price_1sq_meter_usd)/count(*) ln_price_1sq_meter_usd, -- ***
  stddev(ln_price_usd), -- ***
  stddev(ln_price_1sq_meter_usd), -- ***
  1
from uvekon.re_advert u
 where 1=1
 and u.price_advert is not null
 and u.ln_price_usd <> 0 -- ***
 and u.ln_price_1sq_meter_usd <> 0 -- ***
 and u.is_valid=true
 and date_relevance=(select date_relevance from uvekon.re_aggregate_period where type_period=1 and is_work)
group by id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_size_object, -- Код размера объекта (РАСЧЕТНОЕ)
  id_poligon_level_1,
  date_relevance;
  
  -- Заполнение интегрированых даных: 2 level  5 gr

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
  median_cost_usd_norm, -- Медиана стоимости(норм.) ***
  median_price_usd_norm, -- Медиана цены м2(норм.) ***
  std_cost_usd_norm, -- стандартное отклонение стоимости (норм.) ***
  std_price_usd_norm, -- стандартное отклонение цены м2 (норм.) ***
  count_advert,
  level_group,
  min_1sq_meter_usd,
  max_1sq_meter_usd,
  avg_ln_price_usd, -- техническое - ср. логарифма стоимости ***
  avg_ln_price_1sq_meter_usd, -- техническое - ср. логарифма цены м2 ***
  std_ln_price_usd, -- техническое - стандартное отклонение логарифма стоимости ***
  std_ln_price_1sq_meter_usd, -- техническое - стандартное отклонение логарифма цены м2 ***
  level_poligon)
select
  date_relevance,
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_size_object, -- Код размера объекта (РАСЧЕТНОЕ)
  u.id_poligon_level_2,
  sum(price_1sq_meter_uah)/count(*) price_1sq_meter_uah,
  sum(price_1sq_meter_usd)/count(*) price_1sq_meter_usd,
  sum(price_uah)/count(*) price_object_uah,
  sum(price_usd)/count(*) price_object_usd,
  median(price_usd), -- ***
  median(price_1sq_meter_usd), -- ***
  stddev(price_usd), -- ***
  stddev(price_1sq_meter_usd), -- ***
  count(*),
  5,
  min(price_1sq_meter_usd),
  max(price_1sq_meter_usd),
  sum(ln_price_usd)/count(*) ln_price_usd, -- ***
  sum(ln_price_1sq_meter_usd)/count(*) ln_price_1sq_meter_usd, -- ***
  stddev(ln_price_usd), -- ***
  stddev(ln_price_1sq_meter_usd), -- ***
  2
from uvekon.re_advert u
 where 1=1
 and u.price_advert is not null
 and u.ln_price_usd <> 0 -- ***
 and u.ln_price_1sq_meter_usd <> 0 -- ***
 and u.is_valid=true
 and date_relevance=(select date_relevance from uvekon.re_aggregate_period where type_period=1 and is_work)
group by id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_size_object, -- Код размера объекта (РАСЧЕТНОЕ)
  id_poligon_level_2,
  date_relevance;
  
-- Заполнение интегрированых даных: 3 level  5 gr

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
  median_cost_usd_norm, -- Медиана стоимости(норм.) ***
  median_price_usd_norm, -- Медиана цены м2(норм.) ***
  std_cost_usd_norm, -- стандартное отклонение стоимости (норм.) ***
  std_price_usd_norm, -- стандартное отклонение цены м2 (норм.) ***
  count_advert,
  level_group,
  min_1sq_meter_usd,
  max_1sq_meter_usd,
  avg_ln_price_usd, -- техническое - ср. логарифма стоимости ***
  avg_ln_price_1sq_meter_usd, -- техническое - ср. логарифма цены м2 ***
  std_ln_price_usd, -- техническое - стандартное отклонение логарифма стоимости ***
  std_ln_price_1sq_meter_usd, -- техническое - стандартное отклонение логарифма цены м2 ***
  level_poligon)
select
  date_relevance,
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_size_object, -- Код размера объекта (РАСЧЕТНОЕ)
  u.id_poligon_level_3,
  sum(price_1sq_meter_uah)/count(*) price_1sq_meter_uah,
  sum(price_1sq_meter_usd)/count(*) price_1sq_meter_usd,
  sum(price_uah)/count(*) price_object_uah,
  sum(price_usd)/count(*) price_object_usd,
  median(price_usd), -- ***
  median(price_1sq_meter_usd), -- ***
  stddev(price_usd), -- ***
  stddev(price_1sq_meter_usd), -- ***
  count(*),
  5,
  min(price_1sq_meter_usd),
  max(price_1sq_meter_usd),
  sum(ln_price_usd)/count(*) ln_price_usd, -- ***
  sum(ln_price_1sq_meter_usd)/count(*) ln_price_1sq_meter_usd, -- ***
  stddev(ln_price_usd), -- ***
  stddev(ln_price_1sq_meter_usd), -- ***
  3
from uvekon.re_advert u
 where 1=1
 and u.price_advert is not null
 and u.ln_price_usd <> 0 -- ***
 and u.ln_price_1sq_meter_usd <> 0 -- ***
 and u.is_valid=true
 and date_relevance=(select date_relevance from uvekon.re_aggregate_period where type_period=1 and is_work)
group by id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_size_object, -- Код размера объекта (РАСЧЕТНОЕ)
  id_poligon_level_3,
  date_relevance;
  
 -- Заполнение интегрированых даных: 4 level  5 gr

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
  median_cost_usd_norm, -- Медиана стоимости(норм.) ***
  median_price_usd_norm, -- Медиана цены м2(норм.) ***
  std_cost_usd_norm, -- стандартное отклонение стоимости (норм.) ***
  std_price_usd_norm, -- стандартное отклонение цены м2 (норм.) ***
  count_advert,
  level_group,
  min_1sq_meter_usd,
  max_1sq_meter_usd,
  avg_ln_price_usd, -- техническое - ср. логарифма стоимости ***
  avg_ln_price_1sq_meter_usd, -- техническое - ср. логарифма цены м2 ***
  std_ln_price_usd, -- техническое - стандартное отклонение логарифма стоимости ***
  std_ln_price_1sq_meter_usd, -- техническое - стандартное отклонение логарифма цены м2 ***
  level_poligon)
select
  date_relevance,
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_size_object, -- Код размера объекта (РАСЧЕТНОЕ)
  u.id_poligon_level_4,
  sum(price_1sq_meter_uah)/count(*) price_1sq_meter_uah,
  sum(price_1sq_meter_usd)/count(*) price_1sq_meter_usd,
  sum(price_uah)/count(*) price_object_uah,
  sum(price_usd)/count(*) price_object_usd,
  median(price_usd), -- ***
  median(price_1sq_meter_usd), -- ***
  stddev(price_usd), -- ***
  stddev(price_1sq_meter_usd), -- ***
  count(*),
  5,
  min(price_1sq_meter_usd),
  max(price_1sq_meter_usd),
  sum(ln_price_usd)/count(*) ln_price_usd, -- ***
  sum(ln_price_1sq_meter_usd)/count(*) ln_price_1sq_meter_usd, -- ***
  stddev(ln_price_usd), -- ***
  stddev(ln_price_1sq_meter_usd), -- ***
  4
from uvekon.re_advert u
 where 1=1
 and u.price_advert is not null
 and u.ln_price_usd <> 0 -- ***
 and u.ln_price_1sq_meter_usd <> 0 -- ***
 and u.is_valid=true
 and date_relevance=(select date_relevance from uvekon.re_aggregate_period where type_period=1 and is_work)
group by id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_size_object, -- Код размера объекта (РАСЧЕТНОЕ)
  id_poligon_level_4,
  date_relevance;
  
  
  
  
  
------------------------- 
-- Копирование в архив --
-------------------------
insert into uvekon.re_advert
  (date_relevance,id_agency,realty_kod,date_advert,
  id_segment,id_subsegment,id_class_subsegment,
  id_size_object,id_type_oper,price_advert,  
  currency_advert,price_uah, price_usd,
  qt_room,floor,qt_floor,
  total_area,
  living_area,kitchen_area,land_area,
  id_wall_material,
  advert_text,
  advert_url,
  coordinate_n, coordinate_e,
  koatuu_code,street,house,
  coordinate_set_way,
  id_district,
  primary_agency,
  is_valid,
  price_1sq_meter_uah, price_1sq_meter_usd,time_exposition,
  year_building,
  number_of_views,
  distance_to_city,
  bathroom, heating, renovation, comfort, communications, 
  infrastructure, landscape, furnishing, household_appliances,
  multimedia, apartment_layout, building_class, cadastral_number,
  buildings_on_land, wall_insulation, roof_type, room_height, type_offer
)
select  
  (select date_relevance from uvekon.re_aggregate_period where type_period=1 and is_work) date_relevance, 
  (select id_agency from uvekon.re_agency where agency=name) id_agency,  
  realty_kod,date_advert_d,
  id_segment,id_subsegment,id_class_subsegment,
  id_size_object,id_type_oper,
  price_advert_d,COALESCE(currency_advert_d,0) currency_advert_d,price_uah,price_usd,
  (case when qt_room is null then 1
        when qt_room ='' then 1
   else 
  CAST(qt_room AS integer)
   end
  ) qt_room,
  (case when floor is  null then null
        when floor ='' then null 
        when floor='—' then null 
   else CAST(floor AS integer)  end) floor, 
  (case when qt_floor is  null then null
        when qt_floor ='' then null 
   else CAST(qt_floor AS integer)  end) qt_floor, 
  total_area_d,
  (case when living_area is  null then null
        when living_area ='' then null         
   else CAST(replace(living_area,',','.') AS double precision) end) living_area,
  (case when kitchen_area is  null then null
        when kitchen_area ='' then null   
   else CAST(replace(kitchen_area,',','.') AS double precision) end) kitchen_area, 
  land_area_d,  
  id_wall_material, 
  advert_text,
  advert_url,
  coordinate_n, coordinate_e,
  koatuu_code,street,house,
  coordinate_set_way,
  (select id_district_sq from uvekon.re_dic_district  where id_kotuu_district=id_district_koatuu and type_district in (1,2) ) id_district,    
  primary_agency,
  true,
  price_1sq_meter_uah, price_1sq_meter_usd, time_exposition,
  year_building,
  number_of_views,
  distance_to_city,  
  bathroom, heating, renovation, comfort, communications, 
  infrastructure, landscape, furnishing, household_appliances,
  multimedia, apartment_layout, building_class, cadastral_number,
  buildings_on_land, wall_insulation, roof_type, room_height, type_offer
from uvekon.re_advert_load u
where 1=1 
and status in (1);
