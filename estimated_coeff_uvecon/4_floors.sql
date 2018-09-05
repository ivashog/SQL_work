--------------------------------------------------------------------------------------------
--** Значення коефіцієнтів коригуванння середньої ціни за кв.м. житла відповідно до ... **--
--------------------------------------------------------------------------------------------
--* 4_поверху_розташування *--
--------------------------------------------------------------------------------------------

WITH poligons AS(
	SELECT
		id_sq AS pol_id,
		name_ua AS pol_name,
		center AS city
	FROM uvekon.re_poligons
	WHERE level = 4
	),
	floors AS (
	SELECT 
		(
		CASE 
		WHEN floor = 1 THEN 2
		WHEN floor = qt_floor THEN 3
		ELSE 1 END
		) AS floor_id,
		id_build_type_u,
		id_poligon_level_4,
		price_1sq_meter_usd
	FROM uvekon.re_advert
	WHERE id_type_oper = 1 AND id_subsegment = 2
	AND floor is not null
	AND price_1sq_meter_usd >= 100 AND price_1sq_meter_usd <= 5000
	AND id_build_type_u is not null AND id_poligon_level_4 is not null
	AND date_relevance IN ('2018-06-30','2018-05-31', '2018-04-30')
	AND id_poligon_level_4 IN (SELECT pol_id FROM poligons) 
	),
	microdistrcts AS (
	SELECT 
		DISTINCT id_poligon_level_4,
		id_build_type_u,
		floor_id,
		concat(
			replace(to_char(id_poligon_level_4, '9999999999'), ' ', ''),
			replace(to_char(id_build_type_u, '99'), ' ', '')
		) AS hash,
		COUNT(*) AS count,
		AVG(price_1sq_meter_usd) AS avg, 
		median(price_1sq_meter_usd) AS median
	FROM floors
	GROUP BY id_poligon_level_4, id_build_type_u, floor_id
	ORDER BY floor_id
	),
	nth_floor AS (
	SELECT
		id_build_type_u,
		id_poligon_level_4,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE floor_id = 1 AND count > 5
	),
	first_floor AS (
	SELECT
		id_build_type_u,
		id_poligon_level_4,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE floor_id = 2 AND count >= 5
	),
	last_floor AS (
	SELECT
		id_build_type_u,
		id_poligon_level_4,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE floor_id = 3 AND count >= 5
	),
	K_first AS (
	SELECT
		DISTINCT nth.hash AS hash,
		first.id_poligon_level_4 AS poligon,
		first.id_build_type_u AS build_type,
		first.count AS quantity,
		first.avg / nth.avg AS K_first_a,
        first.median / nth.median AS K_first_m
	FROM nth_floor nth, first_floor first
	WHERE nth.hash = first.hash
	ORDER BY build_type
	),
	K_last AS (
	SELECT
		DISTINCT nth.hash AS hash,
		last.id_poligon_level_4 AS poligon,
		last.id_build_type_u AS build_type,
		last.count AS quantity,
		last.avg / nth.avg AS K_last_a,
        last.median / nth.median AS K_last_m
	FROM nth_floor nth, last_floor last
	WHERE nth.hash = last.hash
	ORDER BY build_type
	),
	weighted_K_first_by_poligon AS (
	SELECT
		DISTINCT poligon,
		(SELECT pol_name FROM poligons WHERE pol_id = poligon) AS microdistrict,
		(SELECT city FROM poligons WHERE pol_id = poligon) AS city,
		sum(K_first_a * quantity) / sum(quantity) AS weighted_K_first_a,
        sum(K_first_m * quantity) / sum(quantity) AS weighted_K_first_m,
		sum(quantity) AS quantity
	FROM K_first
	GROUP BY poligon
	),
	weighted_K_last_by_poligon AS (
	SELECT
		DISTINCT poligon,
		(SELECT pol_name FROM poligons WHERE pol_id = poligon) AS microdistrict,
		(SELECT city FROM poligons WHERE pol_id = poligon) AS city,
		sum(K_last_a * quantity) / sum(quantity) AS weighted_K_last_a,
        sum(K_last_m * quantity) / sum(quantity) AS weighted_K_last_m,
		sum(quantity) AS quantity
	FROM K_last
	GROUP BY poligon
	)
SELECT
	'Перший поверх' AS K_name,
	sum(first.weighted_K_first_a * first.quantity) / sum(first.quantity) AS weighted_K_a,
    sum(first.weighted_K_first_m * first.quantity) / sum(first.quantity) AS weighted_K_m,
	sum(first.quantity) AS K_quantity,
	stddev(first.weighted_K_first_a) AS std_K_a,
    stddev(first.weighted_K_first_m) AS std_K_m
FROM weighted_K_first_by_poligon first
UNION ALL
SELECT
	'Останній поверх' AS K_name,
	sum(last.weighted_K_last_a * last.quantity) / sum(last.quantity) AS weighted_K_a,
    sum(last.weighted_K_last_m * last.quantity) / sum(last.quantity) AS weighted_K_m,
	sum(last.quantity) AS K_quantity,
	stddev(last.weighted_K_last_a) AS std_K,
    stddev(last.weighted_K_last_m) AS std_K_m
FROM weighted_K_last_by_poligon last;