--------------------------------------------------------------------------------------------
--** Значення коефіцієнтів коригуванння середньої ціни за кв.м. житла відповідно до ... **--
--------------------------------------------------------------------------------------------
--* 1_загальної_площі *--
--------------------------------------------------------------------------------------------

-------------------------------------------
-- Житло радянської забудови (соціальне) --
-------------------------------------------
WITH 
	poligons AS(
	SELECT
		id_sq AS pol_id,
		name_ua AS pol_name,
		center AS city
	FROM uvekon.re_poligons
	WHERE level = 4
	),
	areas AS (
	SELECT 
		(
		CASE 
		WHEN total_area < 30 THEN 1
		WHEN total_area >= 30 AND total_area < 40 THEN 2
		WHEN total_area >= 40 AND total_area < 50 THEN 3
		WHEN total_area >= 50 AND total_area < 65 THEN 4
		WHEN total_area >= 65 AND total_area < 80 THEN 5
		ELSE 6 END
		) AS area_id,
		id_build_type_u,
		id_poligon_level_4,
		price_1sq_meter_usd
	FROM uvekon.re_advert
	WHERE id_type_oper = 1 AND id_subsegment = 2
AND id_build_type_u is not null
	AND id_build_type_u IN (1,2,3,4,5,6,7)
	AND price_1sq_meter_usd >= 100 AND price_1sq_meter_usd <= 5000
	AND date_relevance IN ('2018-06-30','2018-05-31', '2018-04-30')
	AND id_poligon_level_4 IN (SELECT pol_id FROM poligons) 
	),
	microdistrcts AS (
	SELECT 
		DISTINCT id_poligon_level_4,
		id_build_type_u,
		area_id,
		concat(
			replace(to_char(id_poligon_level_4, '9999999999'), ' ', ''),
			replace(to_char(id_build_type_u, '99'), ' ', '')
		) AS hash,
		COUNT(*) AS count,
		AVG(price_1sq_meter_usd) AS avg, 
		median(price_1sq_meter_usd) AS median
	FROM areas
	GROUP BY id_poligon_level_4, id_build_type_u, area_id
	ORDER BY area_id
	),
	area_0 AS (
	SELECT
		id_build_type_u,
		id_poligon_level_4,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE area_id = 1 AND count >= 5
	),
	area_1 AS (
	SELECT
		id_build_type_u,
		id_poligon_level_4,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE area_id = 2 AND count >= 5
	),
	area_2 AS (
	SELECT
		id_build_type_u,
		id_poligon_level_4,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE area_id = 3 AND count >= 5
	),
	area_3 AS (
	SELECT
		id_build_type_u,
		id_poligon_level_4,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE area_id = 4 AND count >= 5
	),
	area_4 AS (
	SELECT
		id_build_type_u,
		id_poligon_level_4,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE area_id = 5 AND count >= 5
	),
	area_5 AS (
	SELECT
		id_build_type_u,
		id_poligon_level_4,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE area_id = 6 AND count >= 5
	),
	K_1 AS (
	SELECT
		DISTINCT a0.hash AS hash,
		a1.id_poligon_level_4 AS poligon,
		a1.id_build_type_u AS build_type,
		a1.count AS quantity,
		a1.avg / a0.avg AS K_1_a,
		a1.median / a0.median AS K_1_m
	FROM area_0 a0, area_1 a1
	WHERE a0.hash = a1.hash
	ORDER BY build_type
	),
	K_2 AS (
	SELECT
		DISTINCT a0.hash AS hash,
		a2.id_poligon_level_4 AS poligon,
		a2.id_build_type_u AS build_type,
		a2.count AS quantity,
		a2.avg / a0.avg AS K_2_a,
		a2.median / a0.median AS K_2_m
	FROM area_0 a0, area_2 a2
	WHERE a0.hash = a2.hash
	ORDER BY build_type
	),
	K_3 AS (
	SELECT
		DISTINCT a0.hash AS hash,
		a3.id_poligon_level_4 AS poligon,
		a3.id_build_type_u AS build_type,
		a3.count AS quantity,
		a3.avg / a0.avg AS K_3_a,
		a3.median / a0.median AS K_3_m
	FROM area_0 a0, area_3 a3
	WHERE a0.hash = a3.hash
	ORDER BY build_type
	),
	K_4 AS (
	SELECT
		DISTINCT a0.hash AS hash,
		a4.id_poligon_level_4 AS poligon,
		a4.id_build_type_u AS build_type,
		a4.count AS quantity,
		a4.avg / a0.avg AS K_4_a,
		a4.median / a0.median AS K_4_m
	FROM area_0 a0, area_4 a4
	WHERE a0.hash = a4.hash
	ORDER BY build_type
	),
	K_5 AS (
	SELECT
		DISTINCT a0.hash AS hash,
		a5.id_poligon_level_4 AS poligon,
		a5.id_build_type_u AS build_type,
		a5.count AS quantity,
		a5.avg / a0.avg AS K_5_a,
		a5.median / a0.median AS K_5_m
	FROM area_0 a0, area_5 a5
	WHERE a0.hash = a5.hash
	ORDER BY build_type
	),
	weighted_K_1_by_poligon AS (
	SELECT
		DISTINCT poligon,
		(SELECT pol_name FROM poligons WHERE pol_id = poligon) AS microdistrict,
		(SELECT city FROM poligons WHERE pol_id = poligon) AS city,
		sum(K_1_a * quantity) / sum(quantity) AS weighted_K_1_a,
		sum(K_1_m * quantity) / sum(quantity) AS weighted_K_1_m,
		sum(quantity) AS quantity
	FROM K_1
	GROUP BY poligon
	),
	weighted_K_2_by_poligon AS (
	SELECT
		DISTINCT poligon,
		(SELECT pol_name FROM poligons WHERE pol_id = poligon) AS microdistrict,
		(SELECT city FROM poligons WHERE pol_id = poligon) AS city,
		sum(K_2_a * quantity) / sum(quantity) AS weighted_K_2_a,
		sum(K_2_m * quantity) / sum(quantity) AS weighted_K_2_m,
		sum(quantity) AS quantity
	FROM K_2
	GROUP BY poligon
	),
	weighted_K_3_by_poligon AS (
	SELECT
		DISTINCT poligon,
		(SELECT pol_name FROM poligons WHERE pol_id = poligon) AS microdistrict,
		(SELECT city FROM poligons WHERE pol_id = poligon) AS city,
		sum(K_3_a * quantity) / sum(quantity) AS weighted_K_3_a,
		sum(K_3_m * quantity) / sum(quantity) AS weighted_K_3_m,
		sum(quantity) AS quantity
	FROM K_3
	GROUP BY poligon
	),
	weighted_K_4_by_poligon AS (
	SELECT
		DISTINCT poligon,
		(SELECT pol_name FROM poligons WHERE pol_id = poligon) AS microdistrict,
		(SELECT city FROM poligons WHERE pol_id = poligon) AS city,
		sum(K_4_a * quantity) / sum(quantity) AS weighted_K_4_a,
		sum(K_4_m * quantity) / sum(quantity) AS weighted_K_4_m,
		sum(quantity) AS quantity
	FROM K_4
	GROUP BY poligon
	),
	weighted_K_5_by_poligon AS (
	SELECT
		DISTINCT poligon,
		(SELECT pol_name FROM poligons WHERE pol_id = poligon) AS microdistrict,
		(SELECT city FROM poligons WHERE pol_id = poligon) AS city,
		sum(K_5_a * quantity) / sum(quantity) AS weighted_K_5_a,
		sum(K_5_m * quantity) / sum(quantity) AS weighted_K_5_m,
		sum(quantity) AS quantity
	FROM K_5
	GROUP BY poligon
	)
SELECT
	'30 - 40 м2' AS K_name,
	sum(weighted_K_1_a * quantity) / sum(quantity) AS weighted_K_a,
	sum(weighted_K_1_m * quantity) / sum(quantity) AS weighted_K_m,
	sum(quantity) AS K_quantity,
	stddev(weighted_K_1_a) AS std_K_a,
	stddev(weighted_K_1_m) AS std_K_m
FROM weighted_K_1_by_poligon
UNION ALL
SELECT
	'40 - 50 м2' AS K_name,
	sum(weighted_K_2_a * quantity) / sum(quantity) AS weighted_K_a,
	sum(weighted_K_2_m * quantity) / sum(quantity) AS weighted_K_m,
	sum(quantity) AS K_quantity,
	stddev(weighted_K_2_a) AS std_K_a,
	stddev(weighted_K_2_m) AS std_K_m
FROM weighted_K_2_by_poligon
UNION ALL
SELECT
	'50 - 65 м2' AS K_name,
	sum(weighted_K_3_a * quantity) / sum(quantity) AS weighted_K_a,
	sum(weighted_K_3_m * quantity) / sum(quantity) AS weighted_K_m,
	sum(quantity) AS K_quantity,
	stddev(weighted_K_3_a) AS std_K_a,
	stddev(weighted_K_3_m) AS std_K_m
FROM weighted_K_3_by_poligon
UNION ALL
SELECT
	'65 - 80 м2' AS K_name,
	sum(weighted_K_4_a * quantity) / sum(quantity) AS weighted_K_a,
	sum(weighted_K_4_m * quantity) / sum(quantity) AS weighted_K_m,
	sum(quantity) AS K_quantity,
	stddev(weighted_K_4_a) AS std_K_a,
	stddev(weighted_K_4_m) AS std_K_m
FROM weighted_K_4_by_poligon
UNION ALL
SELECT
	'> 80 м2' AS K_name,
	sum(weighted_K_5_a * quantity) / sum(quantity) AS weighted_K_a,
	sum(weighted_K_5_m * quantity) / sum(quantity) AS weighted_K_m,
	sum(quantity) AS K_quantity,
	stddev(weighted_K_5_a) AS std_K_a,
	stddev(weighted_K_5_m) AS std_K_m
FROM weighted_K_5_by_poligon;

-------------------
-- Сучасне житло --
-------------------
WITH 
	poligons AS(
	SELECT
		id_sq AS pol_id,
		name_ua AS pol_name,
		center AS city
	FROM uvekon.re_poligons
	WHERE level = 4
	),
	areas AS (
	SELECT 
		(
		CASE 
		WHEN total_area < 30 THEN 1
		WHEN total_area >= 30 AND total_area < 50 THEN 2
		WHEN total_area >= 50 AND total_area < 65 THEN 3
		WHEN total_area >= 65 AND total_area < 90 THEN 4
		WHEN total_area >= 90 AND total_area < 120 THEN 5
		ELSE 6 END
		) AS area_id,
		id_build_type_u,
		id_poligon_level_4,
		price_1sq_meter_usd
	FROM uvekon.re_advert
	WHERE id_type_oper = 1 AND id_subsegment = 2
AND id_build_type_u is not null
	AND id_build_type_u IN (8,9,10)
	AND price_1sq_meter_usd >= 100 AND price_1sq_meter_usd <= 5000
	AND date_relevance IN ('2018-06-30', '2018-05-31', '2018-04-30')
	AND id_poligon_level_4 IN (SELECT pol_id FROM poligons) 
	),
	microdistrcts AS (
	SELECT 
		DISTINCT id_poligon_level_4,
		id_build_type_u,
		area_id,
		concat(
			replace(to_char(id_poligon_level_4, '9999999999'), ' ', ''),
			replace(to_char(id_build_type_u, '99'), ' ', '')
		) AS hash,
		COUNT(*) AS count,
		AVG(price_1sq_meter_usd) AS avg, 
		median(price_1sq_meter_usd) AS median
	FROM areas
	GROUP BY id_poligon_level_4, id_build_type_u, area_id
	ORDER BY area_id
	),
	area_0 AS (
	SELECT
		id_build_type_u,
		id_poligon_level_4,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE area_id = 1 AND count >= 5
	),
	area_1 AS (
	SELECT
		id_build_type_u,
		id_poligon_level_4,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE area_id = 2 AND count >= 5
	),
	area_2 AS (
	SELECT
		id_build_type_u,
		id_poligon_level_4,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE area_id = 3 AND count >= 5
	),
	area_3 AS (
	SELECT
		id_build_type_u,
		id_poligon_level_4,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE area_id = 4 AND count >= 5
	),
	area_4 AS (
	SELECT
		id_build_type_u,
		id_poligon_level_4,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE area_id = 5 AND count >= 5
	),
	area_5 AS (
	SELECT
		id_build_type_u,
		id_poligon_level_4,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE area_id = 6 AND count >= 5
	),
	K_1 AS (
	SELECT
		DISTINCT a0.hash AS hash,
		a1.id_poligon_level_4 AS poligon,
		a1.id_build_type_u AS build_type,
		a1.count AS quantity,
		a1.avg / a0.avg AS K_1_a,
		a1.median / a0.median AS K_1_m
	FROM area_0 a0, area_1 a1
	WHERE a0.hash = a1.hash
	ORDER BY build_type
	),
	K_2 AS (
	SELECT
		DISTINCT a0.hash AS hash,
		a2.id_poligon_level_4 AS poligon,
		a2.id_build_type_u AS build_type,
		a2.count AS quantity,
		a2.avg / a0.avg AS K_2_a,
		a2.median / a0.median AS K_2_m
	FROM area_0 a0, area_2 a2
	WHERE a0.hash = a2.hash
	ORDER BY build_type
	),
	K_3 AS (
	SELECT
		DISTINCT a0.hash AS hash,
		a3.id_poligon_level_4 AS poligon,
		a3.id_build_type_u AS build_type,
		a3.count AS quantity,
		a3.avg / a0.avg AS K_3_a,
		a3.median / a0.median AS K_3_m
	FROM area_0 a0, area_3 a3
	WHERE a0.hash = a3.hash
	ORDER BY build_type
	),
	K_4 AS (
	SELECT
		DISTINCT a0.hash AS hash,
		a4.id_poligon_level_4 AS poligon,
		a4.id_build_type_u AS build_type,
		a4.count AS quantity,
		a4.avg / a0.avg AS K_4_a,
		a4.median / a0.median AS K_4_m
	FROM area_0 a0, area_4 a4
	WHERE a0.hash = a4.hash
	ORDER BY build_type
	),
	K_5 AS (
	SELECT
		DISTINCT a0.hash AS hash,
		a5.id_poligon_level_4 AS poligon,
		a5.id_build_type_u AS build_type,
		a5.count AS quantity,
		a5.avg / a0.avg AS K_5_a,
		a5.median / a0.median AS K_5_m
	FROM area_0 a0, area_5 a5
	WHERE a0.hash = a5.hash
	ORDER BY build_type
	),
	weighted_K_1_by_poligon AS (
	SELECT
		DISTINCT poligon,
		(SELECT pol_name FROM poligons WHERE pol_id = poligon) AS microdistrict,
		(SELECT city FROM poligons WHERE pol_id = poligon) AS city,
		sum(K_1_a * quantity) / sum(quantity) AS weighted_K_1_a,
		sum(K_1_m * quantity) / sum(quantity) AS weighted_K_1_m,
		sum(quantity) AS quantity
	FROM K_1
	GROUP BY poligon
	),
	weighted_K_2_by_poligon AS (
	SELECT
		DISTINCT poligon,
		(SELECT pol_name FROM poligons WHERE pol_id = poligon) AS microdistrict,
		(SELECT city FROM poligons WHERE pol_id = poligon) AS city,
		sum(K_2_a * quantity) / sum(quantity) AS weighted_K_2_a,
		sum(K_2_m * quantity) / sum(quantity) AS weighted_K_2_m,
		sum(quantity) AS quantity
	FROM K_2
	GROUP BY poligon
	),
	weighted_K_3_by_poligon AS (
	SELECT
		DISTINCT poligon,
		(SELECT pol_name FROM poligons WHERE pol_id = poligon) AS microdistrict,
		(SELECT city FROM poligons WHERE pol_id = poligon) AS city,
		sum(K_3_a * quantity) / sum(quantity) AS weighted_K_3_a,
		sum(K_3_m * quantity) / sum(quantity) AS weighted_K_3_m,
		sum(quantity) AS quantity
	FROM K_3
	GROUP BY poligon
	),
	weighted_K_4_by_poligon AS (
	SELECT
		DISTINCT poligon,
		(SELECT pol_name FROM poligons WHERE pol_id = poligon) AS microdistrict,
		(SELECT city FROM poligons WHERE pol_id = poligon) AS city,
		sum(K_4_a * quantity) / sum(quantity) AS weighted_K_4_a,
		sum(K_4_m * quantity) / sum(quantity) AS weighted_K_4_m,
		sum(quantity) AS quantity
	FROM K_4
	GROUP BY poligon
	),
	weighted_K_5_by_poligon AS (
	SELECT
		DISTINCT poligon,
		(SELECT pol_name FROM poligons WHERE pol_id = poligon) AS microdistrict,
		(SELECT city FROM poligons WHERE pol_id = poligon) AS city,
		sum(K_5_a * quantity) / sum(quantity) AS weighted_K_5_a,
		sum(K_5_m * quantity) / sum(quantity) AS weighted_K_5_m,
		sum(quantity) AS quantity
	FROM K_5
	GROUP BY poligon
	)
SELECT
	'30 - 50 м2' AS K_name,
	sum(weighted_K_1_a * quantity) / sum(quantity) AS weighted_K_a,
	sum(weighted_K_1_m * quantity) / sum(quantity) AS weighted_K_m,
	sum(quantity) AS K_quantity,
	stddev(weighted_K_1_a) AS std_K_a,
	stddev(weighted_K_1_m) AS std_K_m
FROM weighted_K_1_by_poligon
UNION ALL
SELECT
	'50 - 65 м2' AS K_name,
	sum(weighted_K_2_a * quantity) / sum(quantity) AS weighted_K_a,
	sum(weighted_K_2_m * quantity) / sum(quantity) AS weighted_K_m,
	sum(quantity) AS K_quantity,
	stddev(weighted_K_2_a) AS std_K_a,
	stddev(weighted_K_2_m) AS std_K_m
FROM weighted_K_2_by_poligon
UNION ALL
SELECT
	'65 - 90 м2' AS K_name,
	sum(weighted_K_3_a * quantity) / sum(quantity) AS weighted_K_a,
	sum(weighted_K_3_m * quantity) / sum(quantity) AS weighted_K_m,
	sum(quantity) AS K_quantity,
	stddev(weighted_K_3_a) AS std_K_a,
	stddev(weighted_K_3_m) AS std_K_m
FROM weighted_K_3_by_poligon
UNION ALL
SELECT
	'90 - 120 м2' AS K_name,
	sum(weighted_K_4_a * quantity) / sum(quantity) AS weighted_K_a,
	sum(weighted_K_4_m * quantity) / sum(quantity) AS weighted_K_m,
	sum(quantity) AS K_quantity,
	stddev(weighted_K_4_a) AS std_K_a,
	stddev(weighted_K_4_m) AS std_K_m
FROM weighted_K_4_by_poligon
UNION ALL
SELECT
	'>= 120 м2' AS K_name,
	sum(weighted_K_5_a * quantity) / sum(quantity) AS weighted_K_a,
	sum(weighted_K_5_m * quantity) / sum(quantity) AS weighted_K_m,
	sum(quantity) AS K_quantity,
	stddev(weighted_K_5_a) AS std_K_a,
	stddev(weighted_K_5_m) AS std_K_m
FROM weighted_K_5_by_poligon;