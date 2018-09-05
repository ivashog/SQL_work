--------------------------------------------------------------------------------------------
--** Значення коефіцієнтів коригуванння середньої ціни за кв.м. житла відповідно до ... **--
--------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------
--* 1_загальної_площі *--

-------------------------------------------
-- Житло радянської забудови (соціальне) --
-------------------------------------------

WITH 
	poligons AS(-- выборка полигонов для всех микрорайонов
	SELECT
		id_sq AS pol_id,
		name_ua AS pol_name,
		center AS city
	FROM uvekon.re_poligons
	WHERE level = 4
	),
	areas AS (-- выборка и категоризация цен по плошадям
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
	AND date_relevance IN ('2018-05-31', '2018-04-30')
	AND id_poligon_level_4 IN (SELECT pol_id FROM poligons) 
	),
	microdistrcts AS (-- агрегирование цен по микрорайонам
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
FROM weighted_K_5_by_poligon
-------------------
-- Сучасне житло --
-------------------
WITH 
	poligons AS(-- выборка полигонов для всех микрорайонов
	SELECT
		id_sq AS pol_id,
		name_ua AS pol_name,
		center AS city
	FROM uvekon.re_poligons
	WHERE level = 4
	),
	areas AS (-- выборка и категоризация цен по плошадям
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
	AND date_relevance IN ('2018-05-31', '2018-04-30')
	AND id_poligon_level_4 IN (SELECT pol_id FROM poligons) 
	),
	microdistrcts AS (-- агрегирование цен по микрорайонам
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
FROM weighted_K_5_by_poligon

------------------------------------------------------------------------
--* 2_типу_забудови *--
------------------------------------------------------------------------
WITH 
	cities AS (-- выборка полигонов для всех микрорайонов
	SELECT
		id_sq AS city_id,
		name_ua AS name,
		center AS city
	FROM uvekon.re_poligons
	WHERE level = 3
	AND (koatuu IN (SELECT
				  		koatuu_code
				   FROM uvekon.re_dic_koatuu
				   WHERE locality_form IN (1,5)
			  )
	OR koatuu is null)
	),
	build_types AS (-- выборка цен по типу дома
	SELECT 
		id_build_type_u,
		id_poligon_level_3,
		price_1sq_meter_usd
	FROM uvekon.re_advert
	WHERE id_type_oper = 1 AND id_subsegment = 2
	AND id_build_type_u is not null
	AND price_1sq_meter_usd >= 100 AND price_1sq_meter_usd <= 5000
	AND date_relevance IN ('2018-05-31', '2018-04-30')
	AND id_poligon_level_3 IN (SELECT city_id FROM cities) --(SELECT pol_id FROM poligons WHERE city = 'Одеса') 
	),
	build_types_by_cities AS (
	SELECT 
		DISTINCT id_poligon_level_3,
		(SELECT city FROM cities WHERE city_id = id_poligon_level_3) AS city,
		id_build_type_u,
		COUNT(*) AS count,
		AVG(price_1sq_meter_usd) AS avg, 
		median(price_1sq_meter_usd) AS median
	FROM build_types
	GROUP BY id_poligon_level_3, id_build_type_u
	ORDER BY id_build_type_u
	),
	build_types_1 AS (
	SELECT
  		id_poligon_level_3,
  		city,
  		count, avg, median
  	FROM build_types_by_cities
  	WHERE id_build_type_u = 1 AND count >= 3
	),
	build_types_2 AS (
	SELECT
  		id_poligon_level_3,
  		city,
  		count, avg, median
  	FROM build_types_by_cities
  	WHERE id_build_type_u = 2 AND count >= 3
	),
	build_types_3 AS (
	SELECT
  		id_poligon_level_3,
  		city,
  		count, avg, median
  	FROM build_types_by_cities
  	WHERE id_build_type_u = 3 AND count >= 3
	),
	build_types_4 AS (
	SELECT
  		id_poligon_level_3,
  		city,
  		count, avg, median
  	FROM build_types_by_cities
  	WHERE id_build_type_u = 4 AND count >= 3
	),
	build_types_5 AS (
	SELECT
  		id_poligon_level_3,
  		city,
  		count, avg, median
  	FROM build_types_by_cities
  	WHERE id_build_type_u = 5 AND count >= 3
	),
	build_types_6 AS (
	SELECT
  		id_poligon_level_3,
  		city,
  		count, avg, median
  	FROM build_types_by_cities
  	WHERE id_build_type_u = 6 AND count >= 3
	),
	build_types_7 AS (
	SELECT
  		id_poligon_level_3,
  		city,
  		count, avg, median
  	FROM build_types_by_cities
  	WHERE id_build_type_u = 7 AND count >= 3
	),
	build_types_8 AS (
	SELECT
  		id_poligon_level_3,
  		city,
  		count, avg, median
  	FROM build_types_by_cities
  	WHERE id_build_type_u = 8 AND count >= 3
	),
	build_types_9 AS (
	SELECT
  		id_poligon_level_3,
  		city,
  		count, avg, median
  	FROM build_types_by_cities
  	WHERE id_build_type_u = 9 AND count >= 3
	),
	build_types_10 AS (
	SELECT
  		id_poligon_level_3,
  		city,
  		count, avg, median
  	FROM build_types_by_cities
  	WHERE id_build_type_u = 10 AND count >= 3
	),
	K_build_10_9 AS (
	SELECT
  		b9.id_poligon_level_3 AS poligon,
  		b9.city AS city,
  		b9.count AS quantity,
  		b9.avg / b10.avg AS K_10_9_a,
  		b9.median / b10.median AS K_10_9_m
  	FROM build_types_10 b10, build_types_9 b9 
  	WHERE b9.id_poligon_level_3 = b10.id_poligon_level_3
	),
	K_build_10_8 AS (
	SELECT
  		b8.id_poligon_level_3 AS poligon,
  		b8.city AS city,
  		b8.count AS quantity,
  		b8.avg / b10.avg AS K_10_8_a,
  		b8.median / b10.median AS K_10_8_m
  	FROM build_types_10 b10, build_types_8 b8 
  	WHERE b8.id_poligon_level_3 = b10.id_poligon_level_3
	),
	K_build_10_7 AS (
	SELECT
  		b7.id_poligon_level_3 AS poligon,
  		b7.city AS city,
  		b7.count AS quantity,
  		b7.avg / b10.avg AS K_10_7_a,
  		b7.median / b10.median AS K_10_7_m
  	FROM build_types_10 b10, build_types_7 b7 
  	WHERE b7.id_poligon_level_3 = b10.id_poligon_level_3
	),
	K_build_10_6 AS (
	SELECT
  		b6.id_poligon_level_3 AS poligon,
  		b6.city AS city,
  		b6.count AS quantity,
  		b6.avg / b10.avg AS K_10_6_a,
  		b6.median / b10.median AS K_10_6_m
  	FROM build_types_10 b10, build_types_6 b6 
  	WHERE b6.id_poligon_level_3 = b10.id_poligon_level_3
	),
	K_build_10_5 AS (
	SELECT
  		b5.id_poligon_level_3 AS poligon,
  		b5.city AS city,
  		b5.count AS quantity,
  		b5.avg / b10.avg AS K_10_5_a,
  		b5.median / b10.median AS K_10_5_m
  	FROM build_types_10 b10, build_types_5 b5 
  	WHERE b5.id_poligon_level_3 = b10.id_poligon_level_3
	),
	K_build_10_4 AS (
	SELECT
  		b4.id_poligon_level_3 AS poligon,
  		b4.city AS city,
  		b4.count AS quantity,
  		b4.avg / b10.avg AS K_10_4_a,
  		b4.median / b10.median AS K_10_4_m
  	FROM build_types_10 b10, build_types_4 b4 
  	WHERE b4.id_poligon_level_3 = b10.id_poligon_level_3
	),
	K_build_10_3 AS (
	SELECT
  		b3.id_poligon_level_3 AS poligon,
  		b3.city AS city,
  		b3.count AS quantity,
  		b3.avg / b10.avg AS K_10_3_a,
  		b3.median / b10.median AS K_10_3_m
  	FROM build_types_10 b10, build_types_3 b3 
  	WHERE b3.id_poligon_level_3 = b10.id_poligon_level_3
	),
	K_build_10_2 AS (
	SELECT
  		b2.id_poligon_level_3 AS poligon,
  		b2.city AS city,
  		b2.count AS quantity,
  		b2.avg / b10.avg AS K_10_2_a,
  		b2.median / b10.median AS K_10_2_m
  	FROM build_types_10 b10, build_types_2 b2 
  	WHERE b2.id_poligon_level_3 = b10.id_poligon_level_3
	),
	K_build_10_1 AS (
	SELECT
  		b1.id_poligon_level_3 AS poligon,
  		b1.city AS city,
  		b1.count AS quantity,
  		b1.avg / b10.avg AS K_10_1_a,
  		b1.median / b10.median AS K_10_1_m
  	FROM build_types_10 b10, build_types_1 b1
  	WHERE b1.id_poligon_level_3 = b10.id_poligon_level_3
	)
SELECT
	'10 до 9' AS name,
	sum(K_10_9_a * quantity) / sum(quantity) AS WAK_10_9_a,
	sum(K_10_9_m * quantity) / sum(quantity) AS WAK_10_9_m,
	sum(quantity) AS quantity,
	stddev(K_10_9_a) AS std_WAK_10_9_a,
	stddev(K_10_9_m) AS std_WAK_10_9_m
FROM K_build_10_9
UNION ALL
SELECT
	'10 до 8' AS name,
	sum(K_10_8_a * quantity) / sum(quantity) AS WAK_10_9_a,
	sum(K_10_8_m * quantity) / sum(quantity) AS WAK_10_9_m,
	sum(quantity) AS quantity,
	stddev(K_10_8_a) AS std_WAK_10_9_a,
	stddev(K_10_8_m) AS std_WAK_10_9_m
FROM K_build_10_8
UNION ALL	
SELECT
	'10 до 7' AS name,
	sum(K_10_7_a * quantity) / sum(quantity) AS WAK_10_9_a,
	sum(K_10_7_m * quantity) / sum(quantity) AS WAK_10_9_m,
	sum(quantity) AS quantity,
	stddev(K_10_7_a) AS std_WAK_10_9_a,
	stddev(K_10_7_m) AS std_WAK_10_9_m
FROM K_build_10_7
UNION ALL
SELECT
	'10 до 6' AS name,
	sum(K_10_6_a * quantity) / sum(quantity) AS WAK_10_9_a,
	sum(K_10_6_m * quantity) / sum(quantity) AS WAK_10_9_m,
	sum(quantity) AS quantity,
	stddev(K_10_6_a) AS std_WAK_10_9_a,
	stddev(K_10_6_m) AS std_WAK_10_9_m
FROM K_build_10_6
UNION ALL
SELECT
	'10 до 5' AS name,
	sum(K_10_5_a * quantity) / sum(quantity) AS WAK_10_9_a,
	sum(K_10_5_m * quantity) / sum(quantity) AS WAK_10_9_m,
	sum(quantity) AS quantity,
	stddev(K_10_5_a) AS std_WAK_10_9_a,
	stddev(K_10_5_m) AS std_WAK_10_9_m
FROM K_build_10_5
UNION ALL
SELECT
	'10 до 4' AS name,
	sum(K_10_4_a * quantity) / sum(quantity) AS WAK_10_9_a,
	sum(K_10_4_m * quantity) / sum(quantity) AS WAK_10_9_m,
	sum(quantity) AS quantity,
	stddev(K_10_4_a) AS std_WAK_10_9_a,
	stddev(K_10_4_m) AS std_WAK_10_9_m
FROM K_build_10_4
UNION ALL
SELECT
	'10 до 3' AS name,
	sum(K_10_3_a * quantity) / sum(quantity) AS WAK_10_9_a,
	sum(K_10_3_m * quantity) / sum(quantity) AS WAK_10_9_m,
	sum(quantity) AS quantity,
	stddev(K_10_3_a) AS std_WAK_10_9_a,
	stddev(K_10_3_m) AS std_WAK_10_9_m
FROM K_build_10_3
UNION ALL
SELECT
	'10 до 2' AS name,
	sum(K_10_2_a * quantity) / sum(quantity) AS WAK_10_9_a,
	sum(K_10_2_m * quantity) / sum(quantity) AS WAK_10_9_m,
	sum(quantity) AS quantity,
	stddev(K_10_2_a) AS std_WAK_10_9_a,
	stddev(K_10_2_m) AS std_WAK_10_9_m
FROM K_build_10_2
UNION ALL
SELECT
	'10 до 1' AS name,
	sum(K_10_1_a * quantity) / sum(quantity) AS WAK_10_9_a,
	sum(K_10_1_m * quantity) / sum(quantity) AS WAK_10_9_m,
	sum(quantity) AS quantity,
	stddev(K_10_1_a) AS std_WAK_10_9_a,
	stddev(K_10_1_m) AS std_WAK_10_9_m
FROM K_build_10_1



--------------------------------------------------------------------
--* 3_матеріалу_стін_будинку *--
--------------------------------------------------------------------

--------------------------------------------------------------------
-- Житло радянської забудови (соціальне) --
--------------------------------------------------------------------
WITH 
	poligons AS(-- выборка полигонов для всех микрорайонов
	SELECT
		id_sq AS pol_id,
		name_ua AS pol_name,
		center AS city
	FROM uvekon.re_poligons
	WHERE level = 4
	),
	wall_materials AS (-- выборка и категоризация цен по материалу стен
	SELECT 
		id_wall_material,
		id_poligon_level_4,
		price_1sq_meter_usd
	FROM uvekon.re_advert
	WHERE id_type_oper = 1 AND id_subsegment = 2
	AND id_wall_material is not null
	AND id_build_type_u is not null
	AND id_build_type_u IN (1,2,3,4,5,6,7)
	AND price_1sq_meter_usd >= 100 AND price_1sq_meter_usd <= 5000
	AND date_relevance IN ('2018-06-30','2018-05-31', '2018-04-30')
	AND id_poligon_level_4 IN (SELECT pol_id FROM poligons)--(SELECT pol_id FROM poligons) 
	),
	microdistricts AS (
	SELECT 
		DISTINCT id_poligon_level_4,
		(SELECT city FROM poligons WHERE pol_id = id_poligon_level_4) AS city,
		id_wall_material,
		COUNT(*) AS count,
		AVG(price_1sq_meter_usd) AS avg, 
		median(price_1sq_meter_usd) AS median
	FROM wall_materials
	GROUP BY id_poligon_level_4, id_wall_material
	ORDER BY id_wall_material
	),
	wall_type_1 AS (
	SELECT
		id_poligon_level_4,
		city,
		count, avg, median
	FROM microdistricts
	WHERE id_wall_material = 1 AND count >= 5	
	),
	wall_type_2 AS (
	SELECT
		id_poligon_level_4,
		city,
		count, avg, median
	FROM microdistricts
	WHERE id_wall_material = 2 AND count >= 5
	),
	wall_type_3 AS (
	SELECT
		id_poligon_level_4,
		city,
		count, avg, median
	FROM microdistricts
	WHERE id_wall_material = 4 AND count >= 5
	),
	wall_type_4 AS (
	SELECT
		id_poligon_level_4,
		city,
		count, avg, median
	FROM microdistricts
	WHERE id_wall_material = 5 AND count >= 5
	),
	K_type_2_1 AS ( -- Панель до цегли
	SELECT
		t2.id_poligon_level_4 AS poligon,
		t2.city AS city,
		t2.count AS quantity,
		t2.avg / t1.avg AS K_2_1_a,
		t2.median / t1.median AS K_2_1_m
	FROM wall_type_1 t1, wall_type_2 t2
	WHERE t2.id_poligon_level_4 = t1.id_poligon_level_4
	ORDER BY poligon
	),
	K_type_3_1 AS ( -- Моноліт до цегли
	SELECT
		t3.id_poligon_level_4 AS poligon,
		t3.city AS city,
		t3.count AS quantity,
		t3.avg / t1.avg AS K_3_1_a,
		t3.median / t1.median AS K_3_1_m
	FROM wall_type_1 t1, wall_type_3 t3
	WHERE t3.id_poligon_level_4 = t1.id_poligon_level_4
	ORDER BY poligon
	),
	K_type_4_1 AS ( -- Блок до цегли
	SELECT
		t4.id_poligon_level_4 AS poligon,
		t4.city AS city,
		t4.count AS quantity,
		t4.avg / t1.avg AS K_4_1_a,
		t4.median / t1.median AS K_4_1_m
	FROM wall_type_1 t1, wall_type_4 t4
	WHERE t4.id_poligon_level_4 = t1.id_poligon_level_4
	ORDER BY poligon
	),
	WAK_2_1_by_city AS (
	SELECT
		DISTINCT city,
		sum(K_2_1_a * quantity) / sum(quantity) AS WAK_2_1_a,
		sum(K_2_1_m * quantity) / sum(quantity) AS WAK_2_1_m,
		sum(quantity) AS quantity
	FROM K_type_2_1
	GROUP BY city
	),
	WAK_3_1_by_city AS (
	SELECT
		DISTINCT city,
		sum(K_3_1_a * quantity) / sum(quantity) AS WAK_3_1_a,
		sum(K_3_1_m * quantity) / sum(quantity) AS WAK_3_1_m,
		sum(quantity) AS quantity
	FROM K_type_3_1
	GROUP BY city
	),
	WAK_4_1_by_city AS (
	SELECT
		DISTINCT city,
		sum(K_4_1_a * quantity) / sum(quantity) AS WAK_4_1_a,
		sum(K_4_1_m * quantity) / sum(quantity) AS WAK_4_1_m,
		sum(quantity) AS quantity
	FROM K_type_4_1
	GROUP BY city
	)
SELECT
	'Панель до цегли' AS name,
	sum(WAK_2_1_a * quantity) / sum(quantity) AS WAK_2_1_a,
	sum(WAK_2_1_m * quantity) / sum(quantity) AS WAK_2_1_m,
	sum(quantity) AS quantity,
	stddev(WAK_2_1_a) AS std_WAK_2_1_a,
	stddev(WAK_2_1_m) AS std_WAK_2_1_m
FROM WAK_2_1_by_city
UNION ALL
SELECT
	'Моноліт до цегли' AS name,
	sum(WAK_3_1_a * quantity) / sum(quantity) AS WAK_3_1_a,
	sum(WAK_3_1_m * quantity) / sum(quantity) AS WAK_3_1_m,
	sum(quantity) AS quantity,
	stddev(WAK_3_1_a) AS std_WAK_3_1_a,
	stddev(WAK_3_1_m) AS std_WAK_3_1_m
FROM WAK_3_1_by_city
UNION ALL
SELECT
	'Блок до цегли' AS name,
	sum(WAK_4_1_a * quantity) / sum(quantity) AS WAK_4_1_a,
	sum(WAK_4_1_m * quantity) / sum(quantity) AS WAK_4_1_m,
	sum(quantity) AS quantity,
	stddev(WAK_4_1_a) AS std_WAK_4_1_a,
	stddev(WAK_4_1_m) AS std_WAK_4_1_m
FROM WAK_4_1_by_city

--------------------------------------------------------------------
-- Cучасне житло --
--------------------------------------------------------------------	
WITH 
	poligons AS(-- выборка полигонов для всех микрорайонов
	SELECT
		id_sq AS pol_id,
		name_ua AS pol_name,
		center AS city
	FROM uvekon.re_poligons
	WHERE level = 4
	),
	wall_materials AS (-- выборка и категоризация цен по материалу стен
	SELECT 
		id_wall_material,
		id_poligon_level_4,
		price_1sq_meter_usd
	FROM uvekon.re_advert
	WHERE id_type_oper = 1 AND id_subsegment = 2
	AND id_wall_material is not null
	AND id_build_type_u is not null
	AND id_build_type_u IN (8,9,10)
	AND price_1sq_meter_usd >= 100 AND price_1sq_meter_usd <= 5000
	AND date_relevance IN ('2018-05-31', '2018-04-30')
	AND id_poligon_level_4 IN (SELECT pol_id FROM poligons)--(SELECT pol_id FROM poligons) 
	),
	microdistricts AS (
	SELECT 
		DISTINCT id_poligon_level_4,
		(SELECT city FROM poligons WHERE pol_id = id_poligon_level_4) AS city,
		id_wall_material,
		COUNT(*) AS count,
		AVG(price_1sq_meter_usd) AS avg, 
		median(price_1sq_meter_usd) AS median
	FROM wall_materials
	GROUP BY id_poligon_level_4, id_wall_material
	ORDER BY id_wall_material
	),
	wall_type_1 AS (
	SELECT
		id_poligon_level_4,
		city,
		count, avg, median
	FROM microdistricts
	WHERE id_wall_material = 1 AND count >= 5	
	),
	wall_type_2 AS (
	SELECT
		id_poligon_level_4,
		city,
		count, avg, median
	FROM microdistricts
	WHERE id_wall_material = 2 AND count >= 5
	),
	wall_type_3 AS (
	SELECT
		id_poligon_level_4,
		city,
		count, avg, median
	FROM microdistricts
	WHERE id_wall_material = 3 AND count >= 5
	),
	wall_type_4 AS (
	SELECT
		id_poligon_level_4,
		city,
		count, avg, median
	FROM microdistricts
	WHERE id_wall_material = 4 AND count >= 5
	),
	wall_type_5 AS (
	SELECT
		id_poligon_level_4,
		city,
		count, avg, median
	FROM microdistricts
	WHERE id_wall_material = 5 AND count >= 5
	),
	K_type_2_1 AS ( -- Панель до цегли
	SELECT
		t2.id_poligon_level_4 AS poligon,
		t2.city AS city,
		t2.count AS quantity,
		t2.avg / t1.avg AS K_2_1_a,
		t2.median / t1.median AS K_2_1_m
	FROM wall_type_1 t1, wall_type_2 t2
	WHERE t2.id_poligon_level_4 = t1.id_poligon_level_4
	ORDER BY poligon
	),
	K_type_3_1 AS ( -- Утеплена панель до цегли
	SELECT
		t3.id_poligon_level_4 AS poligon,
		t3.city AS city,
		t3.count AS quantity,
		t3.avg / t1.avg AS K_3_1_a,
		t3.median / t1.median AS K_3_1_m
	FROM wall_type_1 t1, wall_type_3 t3
	WHERE t3.id_poligon_level_4 = t1.id_poligon_level_4
	ORDER BY poligon
	),
	K_type_4_1 AS ( -- Моноліт до цегли
	SELECT
		t4.id_poligon_level_4 AS poligon,
		t4.city AS city,
		t4.count AS quantity,
		t4.avg / t1.avg AS K_4_1_a,
		t4.median / t1.median AS K_4_1_m
	FROM wall_type_1 t1, wall_type_4 t4
	WHERE t4.id_poligon_level_4 = t1.id_poligon_level_4
	ORDER BY poligon
	),
	K_type_5_1 AS ( -- Блок до цегли
	SELECT
		t5.id_poligon_level_4 AS poligon,
		t5.city AS city,
		t5.count AS quantity,
		t5.avg / t1.avg AS K_5_1_a,
		t5.median / t1.median AS K_5_1_m
	FROM wall_type_1 t1, wall_type_5 t5
	WHERE t5.id_poligon_level_4 = t1.id_poligon_level_4
	ORDER BY poligon
	),
	WAK_2_1_by_city AS (
	SELECT
		DISTINCT city,
		sum(K_2_1_a * quantity) / sum(quantity) AS WAK_2_1_a,
		sum(K_2_1_m * quantity) / sum(quantity) AS WAK_2_1_m,
		sum(quantity) AS quantity
	FROM K_type_2_1
	GROUP BY city
	),
	WAK_3_1_by_city AS (
	SELECT
		DISTINCT city,
		sum(K_3_1_a * quantity) / sum(quantity) AS WAK_3_1_a,
		sum(K_3_1_m * quantity) / sum(quantity) AS WAK_3_1_m,
		sum(quantity) AS quantity
	FROM K_type_3_1
	GROUP BY city
	),
	WAK_4_1_by_city AS (
	SELECT
		DISTINCT city,
		sum(K_4_1_a * quantity) / sum(quantity) AS WAK_4_1_a,
		sum(K_4_1_m * quantity) / sum(quantity) AS WAK_4_1_m,
		sum(quantity) AS quantity
	FROM K_type_4_1
	GROUP BY city
	),
	WAK_5_1_by_city AS (
	SELECT
		DISTINCT city,
		sum(K_5_1_a * quantity) / sum(quantity) AS WAK_5_1_a,
		sum(K_5_1_m * quantity) / sum(quantity) AS WAK_5_1_m,
		sum(quantity) AS quantity
	FROM K_type_5_1
	GROUP BY city
	)
SELECT
	'Панель до цегли' AS name,
	sum(WAK_2_1_a * quantity) / sum(quantity) AS WAK_2_1_a,
	sum(WAK_2_1_m * quantity) / sum(quantity) AS WAK_2_1_m,
	sum(quantity) AS quantity,
	stddev(WAK_2_1_a) AS std_WAK_2_1_a,
	stddev(WAK_2_1_m) AS std_WAK_2_1_m
FROM WAK_2_1_by_city
UNION ALL
SELECT
	'Утеплена панель до цегли' AS name,
	sum(WAK_3_1_a * quantity) / sum(quantity) AS WAK_3_1_a,
	sum(WAK_3_1_m * quantity) / sum(quantity) AS WAK_3_1_m,
	sum(quantity) AS quantity,
	stddev(WAK_3_1_a) AS std_WAK_3_1_a,
	stddev(WAK_3_1_m) AS std_WAK_3_1_m
FROM WAK_3_1_by_city
UNION ALL
SELECT
	'Моноліт до цегли' AS name,
	sum(WAK_4_1_a * quantity) / sum(quantity) AS WAK_4_1_a,
	sum(WAK_4_1_m * quantity) / sum(quantity) AS WAK_4_1_m,
	sum(quantity) AS quantity,
	stddev(WAK_4_1_a) AS std_WAK_4_1_a,
	stddev(WAK_4_1_m) AS std_WAK_4_1_m
FROM WAK_4_1_by_city
UNION ALL
SELECT
	'Блок до цегли' AS name,
	sum(WAK_5_1_a * quantity) / sum(quantity) AS WAK_5_1_a,
	sum(WAK_5_1_m * quantity) / sum(quantity) AS WAK_5_1_m,
	sum(quantity) AS quantity,
	stddev(WAK_5_1_a) AS std_WAK_5_1_a,
	stddev(WAK_5_1_m) AS std_WAK_5_1_m
FROM WAK_5_1_by_city

	
------------------------------------------------------------------------
--* 4_поверху_розташування *--
------------------------------------------------------------------------

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
	AND date_relevance IN ('2018-05-31', '2018-04-30')
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
	WHERE floor_id = 2 AND count >= 3
	),
	last_floor AS (
	SELECT
		id_build_type_u,
		id_poligon_level_4,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE floor_id = 3 AND count >= 3
	),
	K_first AS (
	SELECT
		DISTINCT nth.hash AS hash,
		first.id_poligon_level_4 AS poligon,
		first.id_build_type_u AS build_type,
		first.count AS quantity,
		first.avg / nth.avg AS K_first_a
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
		last.avg / nth.avg AS K_last_a
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
		sum(quantity) AS quantity
	FROM K_last
	GROUP BY poligon
	)
SELECT
	'Перший поверх' AS K_name,
	avg(first.weighted_K_first_a) AS avg_K_a,
	median(first.weighted_K_first_a) AS median_K_a,
	sum(first.weighted_K_first_a * first.quantity) / sum(first.quantity) AS weighted_K_a,
	sum(first.quantity) AS K_quantity,
	stddev(first.weighted_K_first_a) AS std_K
FROM weighted_K_first_by_poligon first
WHERE weighted_K_first_a between 0.65 AND 1.25
UNION ALL
SELECT
	'Останній поверх' AS K_name,
	avg(last.weighted_K_last_a) AS avg_K_a,
	median(last.weighted_K_last_a) AS median_K_a,
	sum(last.weighted_K_last_a * last.quantity) / sum(last.quantity) AS weighted_K_a,
	sum(last.quantity) AS K_quantity,
	stddev(last.weighted_K_last_a) AS std_K
FROM weighted_K_last_by_poligon last
WHERE weighted_K_last_a between 0.65 AND 1.25

--------------------------------------------------------------------
--* 5_типу_планування_квартири *--
--------------------------------------------------------------------

--------------------------------------------------------------------
-- Житло радянської забудови (соціальне) --
--------------------------------------------------------------------
WITH poligons AS(
	SELECT
		id_sq AS pol_id,
		name_ua AS pol_name,
		center AS city
	FROM uvekon.re_poligons
	WHERE level = 4
	),
	apartment_layouts AS (
	SELECT 
		price_1sq_meter_usd,
		id_poligon_level_4,
		id_build_type_u,
		(
		CASE 
		WHEN apartment_layout = 'Роздільна' THEN 1
		WHEN apartment_layout = 'Суміжна, прохідна' THEN 2
		WHEN apartment_layout = 'Двостороння' THEN 2
		WHEN apartment_layout = 'Студія' THEN 4
		WHEN apartment_layout = 'Вільне планування' THEN 4
		WHEN apartment_layout = 'Малосімейка, гостинка' THEN 7
		ELSE null END
		) AS apartment_layout_id
	FROM uvekon.re_advert
	WHERE id_type_oper = 1 AND id_subsegment = 2
	AND apartment_layout <> '' AND apartment_layout is not null
	AND price_1sq_meter_usd >= 20 AND price_1sq_meter_usd <= 5000
	AND id_build_type_u IN (1,2,3,4,5,6,7)
	AND date_relevance IN ('2018-05-31',
						   '2018-04-30')
	),
	microdistrcts AS (
	SELECT 
		DISTINCT id_poligon_level_4,
		id_build_type_u,
		apartment_layout_id,
		concat(
			replace(to_char(id_poligon_level_4, '9999999999'), ' ', ''),
			replace(to_char(id_build_type_u, '99'), ' ', '')
		) AS hash,
		COUNT(*) AS count,
		AVG(price_1sq_meter_usd) AS avg, 
		median(price_1sq_meter_usd) AS median
	FROM apartment_layouts
	GROUP BY id_poligon_level_4, id_build_type_u, apartment_layout_id
	ORDER BY apartment_layout_id
	),
	layout_1 AS (
	SELECT
		id_build_type_u,
		id_poligon_level_4,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE apartment_layout_id = 1 AND count >= 5
	),
	layout_2 AS (
	SELECT
		id_build_type_u,
		id_poligon_level_4,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE apartment_layout_id = 2 AND count >= 2
	),
	layout_3 AS (
	SELECT
		id_build_type_u,
		id_poligon_level_4,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE apartment_layout_id = 4 AND count >= 2
	),
	layout_4 AS (
	SELECT
		id_build_type_u,
		id_poligon_level_4,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE apartment_layout_id = 7 AND count >= 2
	),
	K_2_1 AS (
	SELECT
		DISTINCT l2.hash AS hash,
		l2.id_poligon_level_4 AS poligon,
		l2.id_build_type_u AS build_type,
		l2.count AS quantity,
		l2.avg / l1.avg AS K_2_1_a,
		l2.median / l1.median AS K_2_1_m
	FROM layout_1 l1, layout_2 l2
	WHERE l1.hash = l2.hash
	ORDER BY build_type
	),
	K_3_1 AS (
	SELECT
		DISTINCT l3.hash AS hash,
		l3.id_poligon_level_4 AS poligon,
		l3.id_build_type_u AS build_type,
		l3.count AS quantity,
		l3.avg / l1.avg AS K_3_1_a,
		l3.median / l1.median AS K_3_1_m
	FROM layout_1 l1, layout_3 l3
	WHERE l1.hash = l3.hash
	ORDER BY build_type
	),
	K_4_1 AS (
	SELECT
		DISTINCT l4.hash AS hash,
		l4.id_poligon_level_4 AS poligon,
		l4.id_build_type_u AS build_type,
		l4.count AS quantity,
		l4.avg / l1.avg AS K_4_1_a,
		l4.median / l1.median AS K_4_1_m
	FROM layout_1 l1, layout_4 l4
	WHERE l1.hash = l4.hash
	ORDER BY build_type
	),
	WAK_2_1 AS (
	SELECT
		DISTINCT poligon,
		sum(K_2_1_a * quantity) / sum(quantity) AS WAK_2_1_a,
		sum(K_2_1_m * quantity) / sum(quantity) AS WAK_2_1_m,
		sum(quantity) AS quantity
	FROM K_2_1
	GROUP BY poligon
	),
	WAK_3_1 AS (
	SELECT
		DISTINCT poligon,
		sum(K_3_1_a * quantity) / sum(quantity) AS WAK_3_1_a,
		sum(K_3_1_m * quantity) / sum(quantity) AS WAK_3_1_m,
		sum(quantity) AS quantity
	FROM K_3_1
	GROUP BY poligon
	),
	WAK_4_1 AS (
	SELECT
		DISTINCT poligon,
		sum(K_4_1_a * quantity) / sum(quantity) AS WAK_4_1_a,
		sum(K_4_1_m * quantity) / sum(quantity) AS WAK_4_1_m,
		sum(quantity) AS quantity
	FROM K_4_1
	GROUP BY poligon
	)
SELECT
	'Суміжна до роздільної' AS name,
	sum(WAK_2_1_a * quantity) / sum(quantity) AS WAK_2_1_a,
	sum(WAK_2_1_m * quantity) / sum(quantity) AS WAK_2_1_m,
	sum(quantity) AS quantity,
	stddev(WAK_2_1_a) AS std_WAK_2_1_a,
	stddev(WAK_2_1_m) AS std_WAK_2_1_m
FROM WAK_2_1
UNION ALL
SELECT
	'Вільне п. до роздільної' AS name,
	sum(WAK_3_1_a * quantity) / sum(quantity) AS WAK_2_1_a,
	sum(WAK_3_1_m * quantity) / sum(quantity) AS WAK_2_1_m,
	sum(quantity) AS quantity,
	stddev(WAK_3_1_a) AS std_WAK_2_1_a,
	stddev(WAK_3_1_m) AS std_WAK_2_1_m
FROM WAK_3_1
UNION ALL
SELECT
	'Малосімейка до роздільної' AS name,
	sum(WAK_4_1_a * quantity) / sum(quantity) AS WAK_2_1_a,
	sum(WAK_4_1_m * quantity) / sum(quantity) AS WAK_2_1_m,
	sum(quantity) AS quantity,
	stddev(WAK_4_1_a) AS std_WAK_2_1_a,
	stddev(WAK_4_1_m) AS std_WAK_2_1_m
FROM WAK_4_1

--------------------------------------------------------------------
-- Cучасне житло --
--------------------------------------------------------------------
WITH poligons AS(
	SELECT
		id_sq AS pol_id,
		name_ua AS pol_name,
		center AS city
	FROM uvekon.re_poligons
	WHERE level = 4
	),
	apartment_layouts AS (
	SELECT 
		price_1sq_meter_usd,
		id_poligon_level_4,
		id_build_type_u,
		(
		CASE 
		WHEN apartment_layout = 'Роздільна' THEN 1
		WHEN apartment_layout = 'Студія' THEN 3
		WHEN apartment_layout = 'Вільне планування' THEN 4
		WHEN apartment_layout = 'Багаторівнева' THEN 6
		WHEN apartment_layout = 'Пентхаус' THEN 8
		WHEN apartment_layout = 'Смарт-квартира' THEN 9
		ELSE null END
		) AS apartment_layout_id
	FROM uvekon.re_advert
	WHERE id_type_oper = 1 AND id_subsegment = 2
	AND apartment_layout <> '' AND apartment_layout is not null
	AND price_1sq_meter_usd >= 100 AND price_1sq_meter_usd <= 5000
	AND id_build_type_u IN (8,9,10)
	AND date_relevance IN ('2018-05-31',
						   '2018-04-30')
	),
	microdistrcts AS (
	SELECT 
		DISTINCT id_poligon_level_4,
		id_build_type_u,
		apartment_layout_id,
		concat(
			replace(to_char(id_poligon_level_4, '9999999999'), ' ', ''),
			replace(to_char(id_build_type_u, '99'), ' ', '')
		) AS hash,
		COUNT(*) AS count,
		AVG(price_1sq_meter_usd) AS avg, 
		median(price_1sq_meter_usd) AS median
	FROM apartment_layouts
	GROUP BY id_poligon_level_4, id_build_type_u, apartment_layout_id
	ORDER BY apartment_layout_id
	),
	layout_1 AS ( -- Роздільна
	SELECT
		id_build_type_u,
		id_poligon_level_4,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE apartment_layout_id = 1 AND count >= 5
	),
	layout_2 AS ( -- Студія
	SELECT
		id_build_type_u,
		id_poligon_level_4,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE apartment_layout_id = 3 AND count >= 2
	),
	layout_3 AS ( -- Вільне п.
	SELECT
		id_build_type_u,
		id_poligon_level_4,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE apartment_layout_id = 4 AND count >= 2
	),
	layout_4 AS ( -- Багаторівнева
	SELECT
		id_build_type_u,
		id_poligon_level_4,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE apartment_layout_id = 6 AND count >= 2
	),
	layout_5 AS ( -- Пентхаус Смарт-квартира
	SELECT
		id_build_type_u,
		id_poligon_level_4,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE apartment_layout_id = 8 AND count >= 2
	),
	layout_6 AS ( -- Смарт-квартира
	SELECT
		id_build_type_u,
		id_poligon_level_4,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE apartment_layout_id = 9 AND count >= 2
	),
	K_2_1 AS (
	SELECT
		DISTINCT l2.hash AS hash,
		l2.id_poligon_level_4 AS poligon,
		l2.id_build_type_u AS build_type,
		l2.count AS quantity,
		l2.avg / l1.avg AS K_2_1_a,
		l2.median / l1.median AS K_2_1_m
	FROM layout_1 l1, layout_2 l2
	WHERE l1.hash = l2.hash
	ORDER BY build_type
	),
	K_3_1 AS (
	SELECT
		DISTINCT l3.hash AS hash,
		l3.id_poligon_level_4 AS poligon,
		l3.id_build_type_u AS build_type,
		l3.count AS quantity,
		l3.avg / l1.avg AS K_3_1_a,
		l3.median / l1.median AS K_3_1_m
	FROM layout_1 l1, layout_3 l3
	WHERE l1.hash = l3.hash
	ORDER BY build_type
	),
	K_4_1 AS (
	SELECT
		DISTINCT l4.hash AS hash,
		l4.id_poligon_level_4 AS poligon,
		l4.id_build_type_u AS build_type,
		l4.count AS quantity,
		l4.avg / l1.avg AS K_4_1_a,
		l4.median / l1.median AS K_4_1_m
	FROM layout_1 l1, layout_4 l4
	WHERE l1.hash = l4.hash
	ORDER BY build_type
	),
	K_5_1 AS (
	SELECT
		DISTINCT l5.hash AS hash,
		l5.id_poligon_level_4 AS poligon,
		l5.id_build_type_u AS build_type,
		l5.count AS quantity,
		l5.avg / l1.avg AS K_5_1_a,
		l5.median / l1.median AS K_5_1_m
	FROM layout_1 l1, layout_5 l5
	WHERE l1.hash = l5.hash
	ORDER BY build_type
	),
	K_6_1 AS (
	SELECT
		DISTINCT l6.hash AS hash,
		l6.id_poligon_level_4 AS poligon,
		l6.id_build_type_u AS build_type,
		l6.count AS quantity,
		l6.avg / l1.avg AS K_6_1_a,
		l6.median / l1.median AS K_6_1_m
	FROM layout_1 l1, layout_6 l6
	WHERE l1.hash = l6.hash
	ORDER BY build_type
	),
	WAK_2_1 AS (
	SELECT
		DISTINCT poligon,
		sum(K_2_1_a * quantity) / sum(quantity) AS WAK_2_1_a,
		sum(K_2_1_m * quantity) / sum(quantity) AS WAK_2_1_m,
		sum(quantity) AS quantity
	FROM K_2_1
	GROUP BY poligon
	),
	WAK_3_1 AS (
	SELECT
		DISTINCT poligon,
		sum(K_3_1_a * quantity) / sum(quantity) AS WAK_3_1_a,
		sum(K_3_1_m * quantity) / sum(quantity) AS WAK_3_1_m,
		sum(quantity) AS quantity
	FROM K_3_1
	GROUP BY poligon
	),
	WAK_4_1 AS (
	SELECT
		DISTINCT poligon,
		sum(K_4_1_a * quantity) / sum(quantity) AS WAK_4_1_a,
		sum(K_4_1_m * quantity) / sum(quantity) AS WAK_4_1_m,
		sum(quantity) AS quantity
	FROM K_4_1
	GROUP BY poligon
	),
	WAK_5_1 AS (
	SELECT
		DISTINCT poligon,
		sum(K_5_1_a * quantity) / sum(quantity) AS WAK_5_1_a,
		sum(K_5_1_m * quantity) / sum(quantity) AS WAK_5_1_m,
		sum(quantity) AS quantity
	FROM K_5_1
	GROUP BY poligon
	),
	WAK_6_1 AS (
	SELECT
		DISTINCT poligon,
		sum(K_6_1_a * quantity) / sum(quantity) AS WAK_6_1_a,
		sum(K_6_1_m * quantity) / sum(quantity) AS WAK_6_1_m,
		sum(quantity) AS quantity
	FROM K_6_1
	GROUP BY poligon
	)
SELECT
	'Студія до роздільної' AS name,
	sum(WAK_2_1_a * quantity) / sum(quantity) AS WAK_2_1_a,
	sum(WAK_2_1_m * quantity) / sum(quantity) AS WAK_2_1_m,
	sum(quantity) AS quantity,
	stddev(WAK_2_1_a) AS std_WAK_2_1_a,
	stddev(WAK_2_1_m) AS std_WAK_2_1_m
FROM WAK_2_1
UNION ALL
SELECT
	'Вільне п. до роздільної' AS name,
	sum(WAK_3_1_a * quantity) / sum(quantity) AS WAK_2_1_a,
	sum(WAK_3_1_m * quantity) / sum(quantity) AS WAK_2_1_m,
	sum(quantity) AS quantity,
	stddev(WAK_3_1_a) AS std_WAK_2_1_a,
	stddev(WAK_3_1_m) AS std_WAK_2_1_m
FROM WAK_3_1
UNION ALL
SELECT
	'Багаторівнева до роздільної' AS name,
	sum(WAK_4_1_a * quantity) / sum(quantity) AS WAK_2_1_a,
	sum(WAK_4_1_m * quantity) / sum(quantity) AS WAK_2_1_m,
	sum(quantity) AS quantity,
	stddev(WAK_4_1_a) AS std_WAK_2_1_a,
	stddev(WAK_4_1_m) AS std_WAK_2_1_m
FROM WAK_4_1
UNION ALL
SELECT
	'Пентхаус до роздільної' AS name,
	sum(WAK_5_1_a * quantity) / sum(quantity) AS WAK_2_1_a,
	sum(WAK_5_1_m * quantity) / sum(quantity) AS WAK_2_1_m,
	sum(quantity) AS quantity,
	stddev(WAK_5_1_a) AS std_WAK_2_1_a,
	stddev(WAK_5_1_m) AS std_WAK_2_1_m
FROM WAK_5_1
UNION ALL
SELECT
	'Смарт-квартира до роздільної' AS name,
	sum(WAK_6_1_a * quantity) / sum(quantity) AS WAK_2_1_a,
	sum(WAK_6_1_m * quantity) / sum(quantity) AS WAK_2_1_m,
	sum(quantity) AS quantity,
	stddev(WAK_6_1_a) AS std_WAK_2_1_a,
	stddev(WAK_6_1_m) AS std_WAK_2_1_m
FROM WAK_6_1


---------------------------------------------------------------------
--* 6_наявності_меблів *--
---------------------------------------------------------------------
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
	AND date_relevance IN ('2018-05-31',
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
FROM WAK_furnishing

---------------------------------------------------------------------
--* 7_наявності_ліфту *--
---------------------------------------------------------------------


---------------------------------------------------------------------
--* 8_видових_характеристик *--
---------------------------------------------------------------------
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
		WHEN (comfort like '%Панорамні вікна%' 
			 OR (lower(advert_text) like '%панорамны%' 
			 OR lower(advert_text) like '%панорамни%'
			 OR lower(advert_text) like '%панорамні%')) THEN 2
		ELSE 1 END
		) AS panoramic_id
	FROM uvekon.re_advert
	WHERE id_type_oper = 1 AND id_subsegment = 2
	AND comfort <> '' AND comfort is not null
	AND price_1sq_meter_usd >= 100 AND price_1sq_meter_usd <= 5000
	AND id_build_type_u is not null
	AND date_relevance IN ('2018-05-31',
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
	FROM is_panoramic p1, is_not_panoramic p2
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