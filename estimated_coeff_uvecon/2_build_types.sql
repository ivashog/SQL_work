--------------------------------------------------------------------------------------------
--** Значення коефіцієнтів коригуванння середньої ціни за кв.м. житла відповідно до ... **--
--------------------------------------------------------------------------------------------
--* 2_типу_забудови *--
--------------------------------------------------------------------------------------------

WITH 
	cities AS (-- выборка полигонов для всех городов
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
	AND date_relevance IN ('2018-06-30','2018-05-31', '2018-04-30')
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
FROM K_build_10_1;