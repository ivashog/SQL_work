--------------------------------------------------------------------------------------------
--** Значення коефіцієнтів коригуванння середньої ціни за кв.м. житла відповідно до ... **--
--------------------------------------------------------------------------------------------
--* 8_видових_характеристик *--
--------------------------------------------------------------------------------------------

WITH poligons AS(
	SELECT
		id_sq AS pol_id,
		name_ua AS pol_name,
		center AS city
	FROM uvekon.re_poligons
	WHERE level = 4
	),
	panoramic_views AS (
	SELECT 
		price_1sq_meter_usd,
		id_poligon_level_4,
		id_build_type_u,
		(
		CASE 
		WHEN ((comfort LIKE '%Панорамні вікна%' 
			 OR (lower(advert_text) like '%панорамны%' 
			 OR lower(advert_text) like '%панорамни%'
			 OR lower(advert_text) like '%панорамні%'))
			 AND floor >= 5) THEN 2
		ELSE 1 END
		) AS panoramic_id
	FROM uvekon.re_advert
	WHERE id_type_oper = 1 AND id_subsegment = 2
	AND comfort <> '' AND comfort is not null AND floor is not null
	AND price_1sq_meter_usd >= 100 AND price_1sq_meter_usd <= 5000
	AND id_build_type_u is not null
	AND date_relevance IN ('2018-06-30',
						   '2018-05-31',
						   '2018-04-30')
	),
	microdistrcts AS (
	SELECT 
		DISTINCT id_poligon_level_4,
		id_build_type_u,
		panoramic_id,
		concat(
			replace(to_char(id_poligon_level_4, '9999999999'), ' ', ''),
			replace(to_char(id_build_type_u, '99'), ' ', '')
		) AS hash,
		COUNT(*) AS count,
		AVG(price_1sq_meter_usd) AS avg, 
		median(price_1sq_meter_usd) AS median
	FROM panoramic_views
	GROUP BY id_poligon_level_4, id_build_type_u, panoramic_id
	ORDER BY panoramic_id
	),
	is_panoramic AS ( -- з панорамним видом
	SELECT
		id_build_type_u,
		id_poligon_level_4,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE panoramic_id = 2 AND count >= 5
	),
	is_not_panoramic AS ( -- без панорамного виду
	SELECT
		id_build_type_u,
		id_poligon_level_4,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE panoramic_id = 1 AND count >= 5
	),
	K_panoramic AS (
	SELECT
		DISTINCT p2.hash AS hash,
		p2.id_poligon_level_4 AS poligon,
		p2.id_build_type_u AS build_type,
		p2.count AS quantity,
		p2.avg / p1.avg AS K_p_a,
		p2.median / p1.median AS K_p_m
	FROM is_panoramic p2, is_not_panoramic p1
	WHERE p1.hash = p2.hash
	ORDER BY build_type
	),
	WAK_panoramic AS (
	SELECT
		DISTINCT poligon,
		sum(K_p_a * quantity) / sum(quantity) AS WAK_p_a,
		sum(K_p_m * quantity) / sum(quantity) AS WAK_p_m,
		sum(quantity) AS quantity
	FROM K_panoramic
	GROUP BY poligon
	)
SELECT
	'кв. з панорамним видом до кв. без виду' AS name,
	sum(WAK_p_a * quantity) / sum(quantity) AS WAK_p_a,
	sum(WAK_p_m * quantity) / sum(quantity) AS WAK_p_m,
	sum(quantity) AS quantity,
	stddev(WAK_p_a) AS std_WAK_p_a,
	stddev(WAK_p_m) AS std_WAK_p_m
FROM WAK_panoramic;