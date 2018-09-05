
----- Создание даных 4-го квартала на основе 3-х последних месяцев

INSERT INTO uvekon.re_aggregate_info
(date_relevance,-- Дата актуальности данных
type_period,
id_type_oper,-- Код операции с недвижимостью
id_segment,-- Код сегмента
id_subsegment,-- Код подсегмента
id_class_subsegment,-- Код класса подсегмента объекта недвижимости
id_size_object,-- Код размерности объекта недвижимости
id_poligon,-- Код полигона
level_poligon,-- Уровень полигона
level_group,-- Уровень греппировки 1 id_type_oper,id_segment; 2 +id_subsegment;3 +id_class_subsegment;4 +id_size_object
price_1sq_meter_uah,-- Средняя арифметическая цена 1 кв.метра в гривне на дату актуальности данных
price_1sq_meter_usd,-- Средняя арифметическая цена 1 кв.метра в долларах на дату актуальности данных
price_object_uah,-- Средняя арифметическая стоимость объекта в гривне на дату актуальности данных
price_object_usd,-- Средняя арифметическая стоимость объекта в долларах на дату актуальности данных
count_advert,-- Количество объявлений в выборке по данному срезу информации  
avg_min_price_usd,-- Среднее минимальное значение цены 1 м2 в $
avg_max_price_usd,-- Среднее максимальное значение цены 1 м2 в $  
min_1sq_meter_usd,-- Минимальное значение цены 1 м2 в $
max_1sq_meter_usd,-- Максимальное значение цены 1 м2 в $  
avg_ln_price_usd,-- техническое - ср. логарифма стоимости
avg_ln_price_1sq_meter_usd,-- техническое - ср. логарифма цены
std_ln_price_usd,-- техническое - стандартное отклонение логарифма стоимости
std_ln_price_1sq_meter_usd,-- техническое - стандартное отклонение логарифма цены
avg_cost_usd_log,-- Средняя стоимость в $ (логонорм.распр.)
avg_price_usd_log,  -- Средняя цена в $ (логонорм.распр.)
median_cost_usd_norm,
median_price_usd_norm,
std_cost_usd_norm,
std_price_usd_norm,
d_int_cost_usd_norm,
d_int_price_usd_norm,
accuracy_cost_norm,
accuracy_price_norm,
median_cost_usd_log,
median_price_usd_log,
moda_coast_usd_log,
moda_price_usd_log,
std_cost_usd_log,
std_price_usd_log,
k_skew_cost_usd_log,
k_skew_price_usd_log,
d_int_cost_usd_log,
d_int_price_usd_log,
accuracy_cost_log,
accuracy_price_log)
  SELECT
    TO_DATE('30.06.2018', 'DD.MM.YYYY'),
    2,
    id_type_oper,
    id_segment,
    id_subsegment,
    id_class_subsegment,
    id_size_object,
    id_poligon,
    level_poligon,
    level_group,
    SUM(price_1sq_meter_uah * count_advert) / SUM(count_advert),-- Средняя арифметическая цена 1 кв.метра в гривне на дату актуальности данных
    SUM(price_1sq_meter_usd * count_advert) / SUM(count_advert),-- Средняя арифметическая цена 1 кв.метра в долларах на дату актуальности данных 
    SUM(price_object_uah * count_advert) / SUM(count_advert),-- Средняя арифметическая стоимость объекта в гривне на дату актуальности данных
    SUM(price_object_usd * count_advert) / SUM(count_advert),-- Средняя арифметическая стоимость объекта в гривне на дату актуальности данных
    SUM(count_advert),-- Количество объявлений в выборке по данному срезу информации 
    SUM(avg_min_price_usd) / COUNT(*),-- Среднее минимальное значение цены 1 м2 в $
    SUM(avg_max_price_usd) / COUNT(*),-- Среднее максимальное значение цены 1 м2 в $  
    MIN(min_1sq_meter_usd),-- Минимальное значение цены 1 м2 в $
    MAX(max_1sq_meter_usd),-- Максимальное значение цены 1 м2 в $
    SUM(avg_ln_price_usd * count_advert) / SUM(count_advert),-- техническое - ср. логарифма стоимости
    SUM(avg_ln_price_1sq_meter_usd * count_advert) / SUM(count_advert),-- техническое - ср. логарифма цены
    SUM(std_ln_price_usd * count_advert) / SUM(count_advert),-- техническое - стандартное отклонение логарифма стоимости
    SUM(std_ln_price_1sq_meter_usd * count_advert) / SUM(count_advert),-- техническое - стандартное отклонение логарифма цены
    SUM(avg_cost_usd_log * count_advert) / SUM(count_advert),
    SUM(avg_price_usd_log * count_advert) / SUM(count_advert),
    SUM(median_cost_usd_norm * count_advert) / SUM(count_advert),
    SUM(median_price_usd_norm * count_advert) / SUM(count_advert),
    SUM(std_cost_usd_norm * count_advert) / SUM(count_advert),
    SUM(std_price_usd_norm * count_advert) / SUM(count_advert),
    SUM(d_int_cost_usd_norm * count_advert) / SUM(count_advert),
    SUM(d_int_price_usd_norm * count_advert) / SUM(count_advert),
    SUM(accuracy_cost_norm * count_advert) / SUM(count_advert),
    SUM(accuracy_price_norm * count_advert) / SUM(count_advert),
    SUM(median_cost_usd_log * count_advert) / SUM(count_advert),
    SUM(median_price_usd_log * count_advert) / SUM(count_advert),
    SUM(moda_coast_usd_log * count_advert) / SUM(count_advert),
    SUM(moda_price_usd_log * count_advert) / SUM(count_advert),
    SUM(std_cost_usd_log * count_advert) / SUM(count_advert),
    SUM(std_price_usd_log * count_advert) / SUM(count_advert),
    SUM(k_skew_cost_usd_log * count_advert) / SUM(count_advert),
    SUM(k_skew_price_usd_log * count_advert) / SUM(count_advert),
    SUM(d_int_cost_usd_log * count_advert) / SUM(count_advert),
    SUM(d_int_price_usd_log * count_advert) / SUM(count_advert),
    SUM(accuracy_cost_log * count_advert) / SUM(count_advert),
    SUM(accuracy_price_log * count_advert) / SUM(count_advert)
  FROM uvekon.re_aggregate_info
  WHERE date_relevance BETWEEN TO_DATE('30.04.2018', 'DD.MM.YYYY') AND TO_DATE('30.06.2018', 'DD.MM.YYYY')
  AND type_period = 1
  GROUP BY id_type_oper,
           id_segment,
           id_subsegment,
           id_class_subsegment,
           id_size_object,
           id_poligon,
           level_poligon,
           level_group;

---------------------------------------
--- рост за месяц  (12 относительно 11)
update uvekon.re_aggregate_info a0
  set perc_incr_month=(  
   select (a1.price_1sq_meter_usd-a2.price_1sq_meter_usd)/a2.price_1sq_meter_usd*100 perc
   from uvekon.re_aggregate_info a1,uvekon.re_aggregate_info a2
   where a0.id_re_agg_sq=a1.id_re_agg_sq      
   and COALESCE(a1.id_type_oper,0)=COALESCE(a2.id_type_oper,0)
   and COALESCE(a1.id_segment,0)=COALESCE(a2.id_segment,0)
   and COALESCE(a1.id_subsegment,0)=COALESCE(a2.id_subsegment,0)
   and COALESCE(a1.id_class_subsegment,0)=COALESCE(a2.id_class_subsegment,0)
   and COALESCE(a1.id_size_object,0)=COALESCE(a2.id_size_object,0)
   and COALESCE(a1.id_poligon,0)=COALESCE(a2.id_poligon,0)
   and COALESCE(a1.level_group,0)=COALESCE(a2.level_group,0)
   and a1.type_period=a2.type_period
   and a1.date_relevance='2018-03-31'
   and a2.date_relevance='2018-02-28'
   and a2.price_1sq_meter_usd<>0
  )
  where a0.date_relevance='2018-03-31'
  and type_period=1
  and price_1sq_meter_usd<>0
  and id_poligon is not null
  AND perc_incr_month is not null
  AND count_advert > 2 AND level_group in (1,2) and level_poligon in (1,2)
  
 ------------------------------------------
UPDATE uvekon.re_aggregate_info i
SET median_cost_usd_norm =(
	select median(price_usd) median
	from uvekon.re_advert u
	where 1=1
	and u.price_usd is not null
	and u.is_valid=true
	and date_relevance = '2017-12-31'
	group by id_segment,
		id_subsegment,
		id_type_oper,
		id_size_object,
		id_class_subsegment,
		id_poligon_level_1,
		date_relevance
)  
WHERE i.date_relevance in ('2017-12-31')
AND price_usd is not null
AND count_advert > 2




