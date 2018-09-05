-- Создание представления 
SELECT ai.id_re_agg_sq,
    ai.date_relevance,
    ai.id_type_oper,
    ai.id_segment,
    ai.id_subsegment,
    ai.id_class_subsegment,
    ai.id_size_object,
    ai.id_poligon,
    ai.price_1sq_meter_uah,
    ai.price_1sq_meter_usd,
    ai.price_object_uah,
    ai.price_object_usd,
    ai.count_advert,
    ai.perc_incr_month,
    ai.perc_incr_quarter,
    ai.perc_incr_year,
    ai.level_group,
    ai.avg_min_price_usd AS avg_min_1sq_meter_usd,
    ai.avg_max_price_usd AS avg_max_1sq_meter_usd,
    ai.min_1sq_meter_usd,
    ai.max_1sq_meter_usd,
    ai.median_cost_usd_norm,
    ai.median_price_usd_norm,
    ai.level_poligon,
    pol.name_ua AS name_poligon,
    pol.id_region,
    pol.region,
    pol.id_district,
    pol.district,
    pol.koatuu,
    d_koatuu.name AS koatuu_name,
    d_to.name AS type_oper_name,
    d_seg.name AS segment_name,
    d_sseg.name AS subsegment_name,
    d_cl_subseg.name AS class_subsegment_name,
    d_sobj.name AS size_object_name,
    ai.type_period,
	concat(
		replace(to_char(ai.id_type_oper, '999'), ' ', ''),
		replace(to_char(ai.id_segment, '999'), ' ', ''),
		replace(to_char(ai.id_subsegment, '999'), ' ', ''),
		replace(to_char(ai.id_poligon, '999'), ' ', ''))
	AS id_agregate
   FROM uvekon.re_aggregate_info ai
     JOIN uvekon.re_poligons pol ON ai.id_poligon = pol.id_sq
     LEFT JOIN uvekon.re_dic_koatuu d_koatuu ON d_koatuu.koatuu_code::text = pol.koatuu::text
     LEFT JOIN uvekon.v_re_dic_segment d_seg ON ai.id_segment = d_seg.id_segment
     LEFT JOIN uvekon.v_re_dic_size_object d_sobj ON ai.id_size_object = d_sobj.id_size_object
     LEFT JOIN uvekon.v_re_dic_subsegment d_sseg ON ai.id_subsegment = d_sseg.id_subsegment
     LEFT JOIN uvekon.v_re_dic_class_subsegment d_cl_subseg ON d_cl_subseg.id_class_subsegment = ai.id_class_subsegment
     LEFT JOIN uvekon.v_re_dic_type_oper d_to ON ai.id_type_oper = d_to.id_type_oper;

-- Область
SELECT 
	id_agregate,
	type_period, date_relevance, type_oper_name, segment_name, subsegment_name,
	level_poligon, name_poligon, district, region, 
	price_1sq_meter_usd, median_price_usd_norm, count_advert
FROM uvekon.v_form_aggregate_info_new
WHERE id_poligon = 25 AND date_relevance = to_date('31.12.2017', 'DD.MM.YYYY') 
AND level_group = 2 AND level_poligon = 1 AND count_advert > 2 AND type_period = 2
AND id_subsegment NOT IN (7,9,10) AND id_subsegment IS NOT NULL 
AND left(id_agregate, 3) IN ('111', '112', '113', '124', '125', '126', '138', '212', '224', '225', '226')
ORDER BY id_type_oper, id_segment, id_subsegment;

-- Райони та міста обл. значення
SELECT 
	id_agregate,
	type_period, date_relevance, type_oper_name, segment_name, subsegment_name,
	level_poligon, name_poligon, district, region, 
	price_1sq_meter_usd, median_price_usd_norm, count_advert
FROM uvekon.v_form_aggregate_info_new
WHERE id_region = 25 AND date_relevance = to_date('31.12.2017', 'DD.MM.YYYY') 
AND level_group = 2 AND level_poligon = 2 AND count_advert > 2 AND type_period = 2
AND id_subsegment NOT IN (7,9,10) AND id_subsegment IS NOT NULL 
AND left(id_agregate, 3) IN ('111', '112', '113', '124', '125', '126', '138', '212', '224', '225', '226')
ORDER BY id_type_oper, id_segment, id_subsegment, koatuu;


-- Місцеві ради (райони в містах обл. знач, міські, селищні та сільські ради)
SELECT 
	id_agregate,
	type_period, date_relevance, type_oper_name, segment_name, subsegment_name,
	level_poligon, name_poligon, district, region, 
	price_1sq_meter_usd, median_price_usd_norm, count_advert
FROM uvekon.v_form_aggregate_info_new
WHERE id_region = 25 AND date_relevance = to_date('31.12.2017', 'DD.MM.YYYY') 
AND level_group = 2 AND level_poligon = 3 AND count_advert > 2 AND type_period = 2
AND id_subsegment NOT IN (7,9,10) AND id_subsegment IS NOT NULL 
AND left(id_agregate, 3) IN ('111', '112', '113', '124', '125', '126', '138', '212', '224', '225', '226')
ORDER BY id_type_oper, id_segment, id_subsegment, koatuu;

-- Мікрорайони (обласних центрів та великих міст)
SELECT 
	id_agregate,
	type_period, date_relevance, type_oper_name, segment_name, subsegment_name,
	level_poligon, name_poligon, district, region, 
	price_1sq_meter_usd, median_price_usd_norm, count_advert
FROM uvekon.v_form_aggregate_info_new
WHERE id_region = 25 AND date_relevance = to_date('31.12.2017', 'DD.MM.YYYY') 
AND level_group = 2 AND level_poligon = 4 AND count_advert > 2 AND type_period = 2
AND id_subsegment NOT IN (7,9,10) AND id_subsegment IS NOT NULL 
AND left(id_agregate, 3) IN ('111', '112', '113', '124', '125', '126', '138', '212', '224', '225', '226')
ORDER BY id_type_oper, id_segment, id_subsegment, name_poligon;

----
concat(replace(to_char(id_type_oper, '999'), ' ', ''),replace(to_char(id_segment, '999'), ' ', ''),replace(to_char(id_subsegment, '999'), ' ', ''))

----

SELECT 
	a1.id_agregate, a2.id_agregate
	a1.type_period, a1.date_relevance, a2.date_relevance, a1.type_oper_name, a1.segment_name, a1.subsegment_name,
	a1.level_poligon, a1.name_poligon, a1.district, a1.region, 
	a1.price_1sq_meter_usd, a1.count_advert, 
	a2.price_1sq_meter_usd, a2.count_advert
FROM uvekon.v_form_aggregate_info_new a1 FULL JOIN uvekon.v_form_aggregate_info_new a2
ON a1.id_agregate = a2.id_agregate
WHERE a1.id_poligon = a2.id_poligon = 25
AND a1.date_relevance = to_date('31.12.2017', 'DD.MM.YYYY')
AND a2.date_relevance = to_date('31.03.2018', 'DD.MM.YYYY') 
AND a1.level_group = 2 AND a1.level_poligon = 1 AND a1.count_advert > 2 AND a1.type_period = 2
AND a1.id_subsegment NOT IN (7,9,10) AND a1.id_subsegment IS NOT NULL 
AND left(a1.id_agregate, 3) IN ('111', '112', '113', '124', '125', '126', '138', '212', '224', '225', '226')
ORDER BY a1.id_type_oper, a1.id_segment, a1.id_subsegment;

-------------

SELECT 
	id_agregate AS id1,
	type_period, date_relevance, type_oper_name, segment_name, subsegment_name,
	level_poligon AS level1, name_poligon AS name1, district AS district1, region AS region1, 
	price_1sq_meter_usd AS price1, median_price_usd_norm AS median1, count_advert AS count1
FROM uvekon.v_form_aggregate_info_new
WHERE id_poligon = 25 AND date_relevance = to_date('31.12.2017', 'DD.MM.YYYY') 
AND level_group = 2 AND level_poligon = 1 AND count_advert > 2 AND type_period = 2
AND id_subsegment NOT IN (7,9,10) AND id_subsegment IS NOT NULL 
AND left(id_agregate, 3) IN ('111', '112', '113', '124', '125', '126', '138', '212', '224', '225', '226')
UNION ALL
SELECT 
	id_agregate AS id2,
	level_poligon AS level2, name_poligon AS name2, district AS district2, region AS region2, 
	price_1sq_meter_usd AS price2, median_price_usd_norm AS median2, count_advert AS count2
FROM uvekon.v_form_aggregate_info_new
WHERE id_poligon = 25 AND date_relevance = to_date('31.03.2018', 'DD.MM.YYYY') 
AND level_group = 2 AND level_poligon = 1 AND count_advert > 2 AND type_period = 2
AND id_subsegment NOT IN (7,9,10) AND id_subsegment IS NOT NULL 
AND left(id_agregate, 3) IN ('111', '112', '113', '124', '125', '126', '138', '212', '224', '225', '226')