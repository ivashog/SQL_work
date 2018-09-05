-- Количество валидной продажи по облцентрам --
WITH report_cities AS (
	SELECT substring(koatuu_code, '\d{5}') AS city_koatuu, name, district
	FROM uvekon.re_dic_koatuu 
	WHERE locality_form = 1 AND locality_status = 1
	)
SELECT DISTINCT
	(SELECT name FROM report_cities WHERE district = id_kotuu_district) AS city,
	count(*) OVER (PARTITION BY id_kotuu_district ORDER BY id_kotuu_district ASC) AS sec_apart_count
FROM uvekon.re_advert_load
WHERE id_kotuu_district IN (SELECT city_koatuu FROM report_cities) AND status = 1 AND id_type_oper = 1;

-- Количество валидной выборки по сегм, подсег и типу опер - по облцентрам *новая выгрузка
WITH report_cities AS (
	SELECT substring(koatuu_code, '\d{5}') AS city_koatuu, name, district
	FROM uvekon.re_dic_koatuu 
	WHERE locality_form = 1 AND locality_status = 1
	),
	segments AS (
	SELECT id_segment AS id_segm, name_ua AS segm
	FROM uvekon.re_dic_segment						
	),
	subsegments AS (
	SELECT id_subsegment AS id_subs, name_ua
	FROM uvekon.re_dic_subsegment
	),
	type_oper AS (
	SELECT id_type_oper AS id_type, name_ua AS type_op
	FROM uvekon.re_dic_type_oper
	)
SELECT DISTINCT
	(SELECT name FROM report_cities WHERE district = id_kotuu_district) AS city,
	(SELECT segm FROM segments WHERE id_segm = id_segment) AS segment,
	(SELECT name_ua FROM subsegments WHERE id_subs = id_subsegment) AS subsegment,
	(SELECT type_op FROM type_oper WHERE id_type = id_type_oper) AS type_operation,
	count(*) OVER (PARTITION BY id_kotuu_district, id_segment, id_subsegment, id_type_oper ORDER BY id_kotuu_district, id_segment, id_subsegment, id_type_oper ASC) AS sec_apart_count
FROM uvekon.re_advert_load
WHERE id_kotuu_district IN (SELECT city_koatuu FROM report_cities) AND status = 1;

-- Количество валидной выборки по сегм, подсег и типу опер - по облцентрам *архив
WITH report_cities AS (
	SELECT koatuu_code AS city_koatuu, name
	FROM uvekon.re_dic_koatuu 
	WHERE locality_form = 1 AND locality_status = 1
	),
	segments AS (
	SELECT id_segment AS id_segm, name_ua AS segm
	FROM uvekon.re_dic_segment						
	),
	subsegments AS (
	SELECT id_subsegment AS id_subs, name_ua
	FROM uvekon.re_dic_subsegment
	),
	type_oper AS (
	SELECT id_type_oper AS id_type, name_ua AS type_op
	FROM uvekon.re_dic_type_oper
	)
SELECT DISTINCT
	(SELECT name FROM report_cities WHERE city_koatuu = koatuu_code) AS city,
	(SELECT segm FROM segments WHERE id_segm = id_segment) AS segment,
	(SELECT name_ua FROM subsegments WHERE id_subs = id_subsegment) AS subsegment,
	(SELECT type_op FROM type_oper WHERE id_type = id_type_oper) AS type_operation,
	count(*) OVER (PARTITION BY koatuu_code, id_subsegment, id_type_oper ORDER BY koatuu_code, id_subsegment, id_type_oper ASC) AS advert_count
FROM uvekon.re_advert
WHERE koatuu_code IN (SELECT city_koatuu FROM report_cities) AND is_valid = true AND date_relevance = '2018-01-31'


--Для Киева и Севастополя--*новая
WITH segments AS (
	SELECT id_segment AS id_segm, name_ua AS segm
	FROM uvekon.re_dic_segment						
	),
	subsegments AS (
	SELECT id_subsegment AS id_subs, name_ua
	FROM uvekon.re_dic_subsegment
	),
	type_oper AS (
	SELECT id_type_oper AS id_type, name_ua AS type_op
	FROM uvekon.re_dic_type_oper
	)
SELECT DISTINCT
	id_region AS city,
	(SELECT segm FROM segments WHERE id_segm = id_segment) AS segment,
	(SELECT name_ua FROM subsegments WHERE id_subs = id_subsegment) AS subsegment,
	(SELECT type_op FROM type_oper WHERE id_type = id_type_oper) AS type_operation,
	count(*) OVER (PARTITION BY id_region, id_subsegment, id_type_oper ORDER BY id_region, id_subsegment, id_type_oper ASC) AS advert_count
FROM uvekon.re_advert_load
WHERE id_region IN ('80', '85') AND status = 1

--Для Киева и Севастополя--*архив
WITH kyiv_sev_koatuu AS (
	SELECT koatuu_code AS city_koatuu, name AS city_name, substring(koatuu_code, '\d{2}') AS id_reg
	FROM uvekon.re_dic_koatuu 
	WHERE substring(koatuu_code, '\d{1}') = '8'
	),
	segments AS (
	SELECT id_segment AS id_segm, name_ua AS segm
	FROM uvekon.re_dic_segment						
	),
	subsegments AS (
	SELECT id_subsegment AS id_subs, name_ua
	FROM uvekon.re_dic_subsegment
	),
	type_oper AS (
	SELECT id_type_oper AS id_type, name_ua AS type_op
	FROM uvekon.re_dic_type_oper
	)
SELECT DISTINCT
	(SELECT id_reg FROM kyiv_sev_koatuu WHERE city_koatuu = koatuu_code) AS city,
	(SELECT segm FROM segments WHERE id_segm = id_segment) AS segment,
	(SELECT name_ua FROM subsegments WHERE id_subs = id_subsegment) AS subsegment,
	(SELECT type_op FROM type_oper WHERE id_type = id_type_oper) AS type_operation,
	count(*) OVER (PARTITION BY koatuu_code, id_subsegment, id_type_oper ORDER BY koatuu_code, id_subsegment, id_type_oper ASC) AS advert_count
FROM uvekon.re_advert
WHERE koatuu_code IN (SELECT city_koatuu FROM kyiv_sev_koatuu) AND is_valid = true AND date_relevance = '2018-01-31'


-- Количество валидной выборки по сегм, подсег и типу опер - по областям *архив --
WITH report_regions AS (
	SELECT
		id_sq AS pol_id,
		name_ua AS name,
		center AS city
	FROM uvekon.re_poligons
	WHERE level = 1
	),
	segments AS (
	SELECT id_segment AS id_segm, name_ua AS segm
	FROM uvekon.re_dic_segment						
	),
	subsegments AS (
	SELECT id_subsegment AS id_subs, name_ua
	FROM uvekon.re_dic_subsegment
	),
	type_oper AS (
	SELECT id_type_oper AS id_type, name_ua AS type_op
	FROM uvekon.re_dic_type_oper
	)
SELECT DISTINCT
	(SELECT name FROM report_regions WHERE pol_id = id_poligon_level_1) AS region,
	(SELECT segm FROM segments WHERE id_segm = id_segment) AS segment,
	(SELECT name_ua FROM subsegments WHERE id_subs = id_subsegment) AS subsegment,
	(SELECT type_op FROM type_oper WHERE id_type = id_type_oper) AS type_operation,
	count(*) OVER (PARTITION BY id_poligon_level_1, id_subsegment, id_type_oper ORDER BY id_poligon_level_1, id_subsegment, id_type_oper ASC) AS advert_count
FROM uvekon.re_advert
WHERE id_poligon_level_1 is not null AND is_valid = true AND date_relevance = '2018-05-31'
AND concat(replace(to_char(id_subsegment, '99'), ' ', ''), replace(to_char(id_type_oper, '9'), ' ', '')) NOT IN ('71', '12', '32', '72', '82', '92', '1', '2')
ORDER BY region, type_operation DESC, segment, subsegment
