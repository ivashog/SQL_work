--------------------------------------------------------------------------------------------
--** Значення коефіцієнтів коригуванння середньої ціни за кв.м. житла відповідно до ... **--
--------------------------------------------------------------------------------------------
--* 6_наявності_меблів *--
--------------------------------------------------------------------------------------------

WITH poligons AS(
	SELECT
		id_sq AS pol_id,
		name_ua AS pol_name,
		center AS city
	FROM uvekon.re_poligons
	WHERE level = 4
	),
	furnishing AS (
	SELECT 
		price_1sq_meter_usd,
		id_poligon_level_4,
		id_build_type_u,
		(
		CASE 
		WHEN furnishing = 'Так' THEN 1
		WHEN furnishing = 'Ні' THEN 0
		ELSE null END
		) AS furnishing_id
	FROM uvekon.re_advert
	WHERE id_type_oper = 1 AND id_subsegment = 2
	AND furnishing <> '' AND furnishing is not null
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
		furnishing_id,
		concat(
			replace(to_char(id_poligon_level_4, '9999999999'), ' ', ''),
			replace(to_char(id_build_type_u, '99'), ' ', '')
		) AS hash,
		COUNT(*) AS count,
		AVG(price_1sq_meter_usd) AS avg, 
		median(price_1sq_meter_usd) AS median
	FROM furnishing
	GROUP BY id_poligon_level_4, id_build_type_u, furnishing_id
	ORDER BY furnishing_id
	),
	isFurnishing AS ( -- з меблюванням
	SELECT
		id_build_type_u,
		id_poligon_level_4,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE furnishing_id = 1 AND count >= 5
	),
	isNotFurnishing AS ( -- без меблювання
	SELECT
		id_build_type_u,
		id_poligon_level_4,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE furnishing_id = 0 AND count >= 5
	),
	K_furnishing AS (
	SELECT
		DISTINCT f2.hash AS hash,
		f2.id_poligon_level_4 AS poligon,
		f2.id_build_type_u AS build_type,
		f2.count AS quantity,
		f2.avg / f1.avg AS K_f_a,
		f2.median / f1.median AS K_f_m
	FROM isFurnishing f1, isNotFurnishing f2
	WHERE f1.hash = f2.hash
	ORDER BY build_type
	),
	WAK_furnishing AS (
	SELECT
		DISTINCT poligon,
		sum(K_f_a * quantity) / sum(quantity) AS WAK_f_a,
		sum(K_f_m * quantity) / sum(quantity) AS WAK_f_m,
		sum(quantity) AS quantity
	FROM K_furnishing
	GROUP BY poligon
	)
SELECT
	'кв. без меблів до кв. з меблюванням' AS name,
	sum(WAK_f_a * quantity) / sum(quantity) AS WAK_f_a,
	sum(WAK_f_m * quantity) / sum(quantity) AS WAK_f_m,
	sum(quantity) AS quantity,
	stddev(WAK_f_a) AS std_WAK_f_a,
	stddev(WAK_f_m) AS std_WAK_f_m
FROM WAK_furnishing;