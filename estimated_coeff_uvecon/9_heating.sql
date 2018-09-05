--------------------------------------------------------------------------------------------
--** Значення коефіцієнтів коригуванння середньої ціни за кв.м. житла відповідно до ... **--
--------------------------------------------------------------------------------------------
--* 9_типу_опалення *--
--------------------------------------------------------------------------------------------

-------------------------------------
 -- По микрорайонах (level = 4)
-------------------------------------

WITH poligons AS (
	SELECT
		id_sq AS pol_id,
		name_ua AS pol_name,
		center AS city
	FROM uvekon.re_poligons
	WHERE level = 4
	),
	heating_types AS (
	SELECT 
		price_1sq_meter_usd,
		id_poligon_level_4,
		id_build_type_u,
		(
		CASE 
		WHEN heating = 'Централізоване' THEN 1
		WHEN heating = 'Індивідуальне газове' THEN 2
        WHEN heating = 'Індивідуальне електро' THEN 3
        WHEN heating = 'Власна котельня' THEN 4
        WHEN heating = 'Твердопаливне' THEN 5
        WHEN heating = 'Комбіноване' THEN 6
		ELSE 7
        END
		) AS heating_id
	FROM uvekon.re_advert
	WHERE id_type_oper = 1 AND id_subsegment = 2
	AND heating <> '' AND heating is not null
	AND price_1sq_meter_usd >= 100 AND price_1sq_meter_usd <= 5000
	AND id_build_type_u is not null
    AND id_poligon_level_4 IN (SELECT pol_id FROM poligons)
	AND date_relevance IN ('2018-06-30',
                           '2018-05-31',
						   '2018-04-30')
	),
	microdistrcts AS (
	SELECT 
		DISTINCT id_poligon_level_4,
		id_build_type_u,
		heating_id,
		concat(
			replace(to_char(id_poligon_level_4, '9999999999'), ' ', ''),
			replace(to_char(id_build_type_u, '99'), ' ', '')
		) AS hash,
		COUNT(*) AS count,
		AVG(price_1sq_meter_usd) AS avg, 
		median(price_1sq_meter_usd) AS median
	FROM heating_types
	GROUP BY id_poligon_level_4, id_build_type_u, heating_id
	ORDER BY heating_id
	),
	heating_type_1 AS ( -- Централізоване опалення
	SELECT
		id_build_type_u,
		id_poligon_level_4,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE heating_id = 1 AND count >= 3
	),
	heating_type_2 AS ( -- Індивідуальне газове опалення
	SELECT
		id_build_type_u,
		id_poligon_level_4,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE heating_id = 2 AND count >= 2
	),
    heating_type_3 AS ( -- Індивідуальне електро опалення
	SELECT
		id_build_type_u,
		id_poligon_level_4,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE heating_id = 3 AND count >= 2
	),
    heating_type_4 AS ( -- Власна котельня
	SELECT
		id_build_type_u,
		id_poligon_level_4,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE heating_id = 4 AND count >= 2
	),
    heating_type_5 AS ( -- Твердопаливне опалення
	SELECT
		id_build_type_u,
		id_poligon_level_4,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE heating_id = 5 AND count >= 2
	),
    heating_type_6 AS ( -- Комбіноване опалення
	SELECT
		id_build_type_u,
		id_poligon_level_4,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE heating_id = 6 AND count >= 2
	),
    heating_type_7 AS ( -- Інше опалення
	SELECT
		id_build_type_u,
		id_poligon_level_4,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE heating_id = 7 AND count >= 2
	),
    K_ht_1 AS (
	SELECT
		DISTINCT h1.hash AS hash,
		h1.id_poligon_level_4 AS poligon,
		h1.id_build_type_u AS build_type,
		h1.count AS quantity,
		h1.avg / h1.avg AS K_h_a,
		h1.median / h1.median AS K_h_m
	FROM heating_type_1 h1, heating_type_2 h2
	WHERE h1.hash = h2.hash 
	ORDER BY build_type
	),
	K_ht_2 AS (
	SELECT
		DISTINCT h2.hash AS hash,
		h2.id_poligon_level_4 AS poligon,
		h2.id_build_type_u AS build_type,
		h2.count AS quantity,
		h2.avg / h1.avg AS K_h_a,
		h2.median / h1.median AS K_h_m
	FROM heating_type_1 h1, heating_type_2 h2
	WHERE h1.hash = h2.hash
	ORDER BY build_type
	),
    K_ht_3 AS (
	SELECT
		DISTINCT h3.hash AS hash,
		h3.id_poligon_level_4 AS poligon,
		h3.id_build_type_u AS build_type,
		h3.count AS quantity,
		h3.avg / h1.avg AS K_h_a,
		h3.median / h1.median AS K_h_m
	FROM heating_type_1 h1, heating_type_3 h3
	WHERE h1.hash = h3.hash
	ORDER BY build_type
	),
    K_ht_4 AS (
	SELECT
		DISTINCT h4.hash AS hash,
		h4.id_poligon_level_4 AS poligon,
		h4.id_build_type_u AS build_type,
		h4.count AS quantity,
		h4.avg / h1.avg AS K_h_a,
		h4.median / h1.median AS K_h_m
	FROM heating_type_1 h1, heating_type_4 h4
	WHERE h1.hash = h4.hash
	ORDER BY build_type
	),
    K_ht_5 AS (
	SELECT
		DISTINCT h5.hash AS hash,
		h5.id_poligon_level_4 AS poligon,
		h5.id_build_type_u AS build_type,
		h5.count AS quantity,
		h5.avg / h1.avg AS K_h_a,
		h5.median / h1.median AS K_h_m
	FROM heating_type_1 h1, heating_type_5 h5
	WHERE h1.hash = h5.hash
	ORDER BY build_type
	),
    K_ht_6 AS (
	SELECT
		DISTINCT h6.hash AS hash,
		h6.id_poligon_level_4 AS poligon,
		h6.id_build_type_u AS build_type,
		h6.count AS quantity,
		h6.avg / h1.avg AS K_h_a,
		h6.median / h1.median AS K_h_m
	FROM heating_type_1 h1, heating_type_6 h6
	WHERE h1.hash = h6.hash
	ORDER BY build_type
	),
    K_ht_7 AS (
	SELECT
		DISTINCT h7.hash AS hash,
		h7.id_poligon_level_4 AS poligon,
		h7.id_build_type_u AS build_type,
		h7.count AS quantity,
		h7.avg / h1.avg AS K_h_a,
		h7.median / h1.median AS K_h_m
	FROM heating_type_1 h1, heating_type_7 h7
	WHERE h1.hash = h7.hash
	ORDER BY build_type
	),
	WAK_ht_1 AS (
	SELECT
		DISTINCT poligon,
		sum(K_h_a * quantity) / sum(quantity) AS WAK_h_a,
		sum(K_h_m * quantity) / sum(quantity) AS WAK_h_m,
		sum(quantity) AS quantity
	FROM K_ht_1
	GROUP BY poligon
	),
    WAK_ht_2 AS (
	SELECT
		DISTINCT poligon,
		sum(K_h_a * quantity) / sum(quantity) AS WAK_h_a,
		sum(K_h_m * quantity) / sum(quantity) AS WAK_h_m,
		sum(quantity) AS quantity
	FROM K_ht_2
	GROUP BY poligon
	),
    WAK_ht_3 AS (
	SELECT
		DISTINCT poligon,
		sum(K_h_a * quantity) / sum(quantity) AS WAK_h_a,
		sum(K_h_m * quantity) / sum(quantity) AS WAK_h_m,
		sum(quantity) AS quantity
	FROM K_ht_3
	GROUP BY poligon
	),
    WAK_ht_4 AS (
	SELECT
		DISTINCT poligon,
		sum(K_h_a * quantity) / sum(quantity) AS WAK_h_a,
		sum(K_h_m * quantity) / sum(quantity) AS WAK_h_m,
		sum(quantity) AS quantity
	FROM K_ht_4
	GROUP BY poligon
	),
    WAK_ht_5 AS (
	SELECT
		DISTINCT poligon,
		sum(K_h_a * quantity) / sum(quantity) AS WAK_h_a,
		sum(K_h_m * quantity) / sum(quantity) AS WAK_h_m,
		sum(quantity) AS quantity
	FROM K_ht_5
	GROUP BY poligon
	),
    WAK_ht_6 AS (
	SELECT
		DISTINCT poligon,
		sum(K_h_a * quantity) / sum(quantity) AS WAK_h_a,
		sum(K_h_m * quantity) / sum(quantity) AS WAK_h_m,
		sum(quantity) AS quantity
	FROM K_ht_6
	GROUP BY poligon
	),
    WAK_ht_7 AS (
	SELECT
		DISTINCT poligon,
		sum(K_h_a * quantity) / sum(quantity) AS WAK_h_a,
		sum(K_h_m * quantity) / sum(quantity) AS WAK_h_m,
		sum(quantity) AS quantity
	FROM K_ht_7
	GROUP BY poligon
	)
SELECT
	'Централізоване' AS name,
	sum(WAK_h_a * quantity) / sum(quantity) AS WAK_h_a,
	sum(WAK_h_m * quantity) / sum(quantity) AS WAK_h_m,
	sum(quantity) AS quantity,
	stddev(WAK_h_a) AS std_WAK_h_a,
	stddev(WAK_h_m) AS std_WAK_h_m
FROM WAK_ht_1
UNION ALL
SELECT
	'Індивідуальне газове' AS name,
	sum(WAK_h_a * quantity) / sum(quantity) AS WAK_h_a,
	sum(WAK_h_m * quantity) / sum(quantity) AS WAK_h_m,
	sum(quantity) AS quantity,
	stddev(WAK_h_a) AS std_WAK_h_a,
	stddev(WAK_h_m) AS std_WAK_h_m
FROM WAK_ht_2
UNION ALL
SELECT
	'Індивідуальне електро' AS name,
	sum(WAK_h_a * quantity) / sum(quantity) AS WAK_h_a,
	sum(WAK_h_m * quantity) / sum(quantity) AS WAK_h_m,
	sum(quantity) AS quantity,
	stddev(WAK_h_a) AS std_WAK_h_a,
	stddev(WAK_h_m) AS std_WAK_h_m
FROM WAK_ht_3
UNION ALL
SELECT
	'Власна котельня' AS name,
	sum(WAK_h_a * quantity) / sum(quantity) AS WAK_h_a,
	sum(WAK_h_m * quantity) / sum(quantity) AS WAK_h_m,
	sum(quantity) AS quantity,
	stddev(WAK_h_a) AS std_WAK_h_a,
	stddev(WAK_h_m) AS std_WAK_h_m
FROM WAK_ht_4
UNION ALL
SELECT
	'Твердопаливне' AS name,
	sum(WAK_h_a * quantity) / sum(quantity) AS WAK_h_a,
	sum(WAK_h_m * quantity) / sum(quantity) AS WAK_h_m,
	sum(quantity) AS quantity,
	stddev(WAK_h_a) AS std_WAK_h_a,
	stddev(WAK_h_m) AS std_WAK_h_m
FROM WAK_ht_5
UNION ALL
SELECT
	'Комбіноване' AS name,
	sum(WAK_h_a * quantity) / sum(quantity) AS WAK_h_a,
	sum(WAK_h_m * quantity) / sum(quantity) AS WAK_h_m,
	sum(quantity) AS quantity,
	stddev(WAK_h_a) AS std_WAK_h_a,
	stddev(WAK_h_m) AS std_WAK_h_m
FROM WAK_ht_6
UNION ALL
SELECT
	'Інше' AS name,
	sum(WAK_h_a * quantity) / sum(quantity) AS WAK_h_a,
	sum(WAK_h_m * quantity) / sum(quantity) AS WAK_h_m,
	sum(quantity) AS quantity,
	stddev(WAK_h_a) AS std_WAK_h_a,
	stddev(WAK_h_m) AS std_WAK_h_m
FROM WAK_ht_7;


--------------------------------------
-- По всех городах (level = 3)
--------------------------------------

WITH cities AS (-- выборка полигонов для всех городов
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
	heating_types AS (
	SELECT 
		price_1sq_meter_usd,
		id_poligon_level_3,
		id_build_type_u,
		(
		CASE 
		WHEN heating = 'Централізоване' THEN 1
		WHEN heating = 'Індивідуальне газове' THEN 2
        WHEN heating = 'Індивідуальне електро' THEN 3
        WHEN heating = 'Власна котельня' THEN 4
        WHEN heating = 'Твердопаливне' THEN 5
        WHEN heating = 'Комбіноване' THEN 6
		ELSE 7
        END
		) AS heating_id
	FROM uvekon.re_advert
	WHERE id_type_oper = 1 AND id_subsegment = 2
	AND heating <> '' AND heating is not null
	AND price_1sq_meter_usd >= 50 AND price_1sq_meter_usd <= 5000
	AND id_build_type_u is not null
    AND id_poligon_level_3 IN (SELECT city_id FROM cities)
	AND date_relevance IN ('2018-06-30',
                           '2018-05-31',
						   '2018-04-30')
	),
	microdistrcts AS (
	SELECT 
		DISTINCT id_poligon_level_3,
        (SELECT city FROM cities WHERE city_id = id_poligon_level_3) AS city,
		id_build_type_u,
		heating_id,
		concat(
			replace(to_char(id_poligon_level_3, '9999999999'), ' ', ''),
			replace(to_char(id_build_type_u, '99'), ' ', '')
		) AS hash,
		COUNT(*) AS count,
		AVG(price_1sq_meter_usd) AS avg, 
		median(price_1sq_meter_usd) AS median
	FROM heating_types
	GROUP BY id_poligon_level_3, id_build_type_u, heating_id
	ORDER BY heating_id
	),
	heating_type_1 AS ( -- Централізоване опалення
	SELECT
		id_build_type_u,
		id_poligon_level_3,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE heating_id = 1 AND count > 5
	),
	heating_type_2 AS ( -- Індивідуальне газове опалення
	SELECT
		id_build_type_u,
		id_poligon_level_3,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE heating_id = 2 AND count >= 5
	),
    heating_type_3 AS ( -- Індивідуальне електро опалення
	SELECT
		id_build_type_u,
		id_poligon_level_3,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE heating_id = 3 AND count >= 5
	),
    heating_type_4 AS ( -- Власна котельня
	SELECT
		id_build_type_u,
		id_poligon_level_3,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE heating_id = 4 AND count >= 5
	),
    heating_type_5 AS ( -- Твердопаливне опалення
	SELECT
		id_build_type_u,
		id_poligon_level_3,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE heating_id = 5 AND count >= 5
	),
    heating_type_6 AS ( -- Комбіноване опалення
	SELECT
		id_build_type_u,
		id_poligon_level_3,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE heating_id = 6 AND count >= 5
	),
    heating_type_7 AS ( -- Інше опалення
	SELECT
		id_build_type_u,
		id_poligon_level_3,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE heating_id = 7 AND count >= 5
	),
    K_ht_1 AS (
	SELECT
		DISTINCT h1.hash AS hash,
		h1.id_poligon_level_3 AS poligon,
		h1.id_build_type_u AS build_type,
		h1.count AS quantity,
		h1.avg / h1.avg AS K_h_a,
		h1.median / h1.median AS K_h_m
	FROM heating_type_1 h1, heating_type_2 h2
	WHERE h1.hash = h2.hash 
	ORDER BY build_type
	),
	K_ht_2 AS (
	SELECT
		DISTINCT h2.hash AS hash,
		h2.id_poligon_level_3 AS poligon,
		h2.id_build_type_u AS build_type,
		h2.count AS quantity,
		h2.avg / h1.avg AS K_h_a,
		h2.median / h1.median AS K_h_m
	FROM heating_type_1 h1, heating_type_2 h2
	WHERE h1.hash = h2.hash
	ORDER BY build_type
	),
    K_ht_3 AS (
	SELECT
		DISTINCT h3.hash AS hash,
		h3.id_poligon_level_3 AS poligon,
		h3.id_build_type_u AS build_type,
		h3.count AS quantity,
		h3.avg / h1.avg AS K_h_a,
		h3.median / h1.median AS K_h_m
	FROM heating_type_1 h1, heating_type_3 h3
	WHERE h1.hash = h3.hash
	ORDER BY build_type
	),
    K_ht_4 AS (
	SELECT
		DISTINCT h4.hash AS hash,
		h4.id_poligon_level_3 AS poligon,
		h4.id_build_type_u AS build_type,
		h4.count AS quantity,
		h4.avg / h1.avg AS K_h_a,
		h4.median / h1.median AS K_h_m
	FROM heating_type_1 h1, heating_type_4 h4
	WHERE h1.hash = h4.hash
	ORDER BY build_type
	),
    K_ht_5 AS (
	SELECT
		DISTINCT h5.hash AS hash,
		h5.id_poligon_level_3 AS poligon,
		h5.id_build_type_u AS build_type,
		h5.count AS quantity,
		h5.avg / h1.avg AS K_h_a,
		h5.median / h1.median AS K_h_m
	FROM heating_type_1 h1, heating_type_5 h5
	WHERE h1.hash = h5.hash
	ORDER BY build_type
	),
    K_ht_6 AS (
	SELECT
		DISTINCT h6.hash AS hash,
		h6.id_poligon_level_3 AS poligon,
		h6.id_build_type_u AS build_type,
		h6.count AS quantity,
		h6.avg / h1.avg AS K_h_a,
		h6.median / h1.median AS K_h_m
	FROM heating_type_1 h1, heating_type_6 h6
	WHERE h1.hash = h6.hash
	ORDER BY build_type
	),
    K_ht_7 AS (
	SELECT
		DISTINCT h7.hash AS hash,
		h7.id_poligon_level_3 AS poligon,
		h7.id_build_type_u AS build_type,
		h7.count AS quantity,
		h7.avg / h1.avg AS K_h_a,
		h7.median / h1.median AS K_h_m
	FROM heating_type_1 h1, heating_type_7 h7
	WHERE h1.hash = h7.hash
	ORDER BY build_type
	),
	WAK_ht_1 AS (
	SELECT
		DISTINCT poligon,
		sum(K_h_a * quantity) / sum(quantity) AS WAK_h_a,
		sum(K_h_m * quantity) / sum(quantity) AS WAK_h_m,
		sum(quantity) AS quantity
	FROM K_ht_1
	GROUP BY poligon
	),
    WAK_ht_2 AS (
	SELECT
		DISTINCT poligon,
		sum(K_h_a * quantity) / sum(quantity) AS WAK_h_a,
		sum(K_h_m * quantity) / sum(quantity) AS WAK_h_m,
		sum(quantity) AS quantity
	FROM K_ht_2
	GROUP BY poligon
	),
    WAK_ht_3 AS (
	SELECT
		DISTINCT poligon,
		sum(K_h_a * quantity) / sum(quantity) AS WAK_h_a,
		sum(K_h_m * quantity) / sum(quantity) AS WAK_h_m,
		sum(quantity) AS quantity
	FROM K_ht_3
	GROUP BY poligon
	),
    WAK_ht_4 AS (
	SELECT
		DISTINCT poligon,
		sum(K_h_a * quantity) / sum(quantity) AS WAK_h_a,
		sum(K_h_m * quantity) / sum(quantity) AS WAK_h_m,
		sum(quantity) AS quantity
	FROM K_ht_4
	GROUP BY poligon
	),
    WAK_ht_5 AS (
	SELECT
		DISTINCT poligon,
		sum(K_h_a * quantity) / sum(quantity) AS WAK_h_a,
		sum(K_h_m * quantity) / sum(quantity) AS WAK_h_m,
		sum(quantity) AS quantity
	FROM K_ht_5
	GROUP BY poligon
	),
    WAK_ht_6 AS (
	SELECT
		DISTINCT poligon,
		sum(K_h_a * quantity) / sum(quantity) AS WAK_h_a,
		sum(K_h_m * quantity) / sum(quantity) AS WAK_h_m,
		sum(quantity) AS quantity
	FROM K_ht_6
	GROUP BY poligon
	),
    WAK_ht_7 AS (
	SELECT
		DISTINCT poligon,
		sum(K_h_a * quantity) / sum(quantity) AS WAK_h_a,
		sum(K_h_m * quantity) / sum(quantity) AS WAK_h_m,
		sum(quantity) AS quantity
	FROM K_ht_7
	GROUP BY poligon
	)
SELECT
	'Централізоване' AS name,
	sum(WAK_h_a * quantity) / sum(quantity) AS WAK_h_a,
	sum(WAK_h_m * quantity) / sum(quantity) AS WAK_h_m,
	sum(quantity) AS quantity,
	stddev(WAK_h_a) AS std_WAK_h_a,
	stddev(WAK_h_m) AS std_WAK_h_m
FROM WAK_ht_1
UNION ALL
SELECT
	'Індивідуальне газове' AS name,
	sum(WAK_h_a * quantity) / sum(quantity) AS WAK_h_a,
	sum(WAK_h_m * quantity) / sum(quantity) AS WAK_h_m,
	sum(quantity) AS quantity,
	stddev(WAK_h_a) AS std_WAK_h_a,
	stddev(WAK_h_m) AS std_WAK_h_m
FROM WAK_ht_2
UNION ALL
SELECT
	'Індивідуальне електро' AS name,
	sum(WAK_h_a * quantity) / sum(quantity) AS WAK_h_a,
	sum(WAK_h_m * quantity) / sum(quantity) AS WAK_h_m,
	sum(quantity) AS quantity,
	stddev(WAK_h_a) AS std_WAK_h_a,
	stddev(WAK_h_m) AS std_WAK_h_m
FROM WAK_ht_3
UNION ALL
SELECT
	'Власна котельня' AS name,
	sum(WAK_h_a * quantity) / sum(quantity) AS WAK_h_a,
	sum(WAK_h_m * quantity) / sum(quantity) AS WAK_h_m,
	sum(quantity) AS quantity,
	stddev(WAK_h_a) AS std_WAK_h_a,
	stddev(WAK_h_m) AS std_WAK_h_m
FROM WAK_ht_4
UNION ALL
SELECT
	'Твердопаливне' AS name,
	sum(WAK_h_a * quantity) / sum(quantity) AS WAK_h_a,
	sum(WAK_h_m * quantity) / sum(quantity) AS WAK_h_m,
	sum(quantity) AS quantity,
	stddev(WAK_h_a) AS std_WAK_h_a,
	stddev(WAK_h_m) AS std_WAK_h_m
FROM WAK_ht_5
UNION ALL
SELECT
	'Комбіноване' AS name,
	sum(WAK_h_a * quantity) / sum(quantity) AS WAK_h_a,
	sum(WAK_h_m * quantity) / sum(quantity) AS WAK_h_m,
	sum(quantity) AS quantity,
	stddev(WAK_h_a) AS std_WAK_h_a,
	stddev(WAK_h_m) AS std_WAK_h_m
FROM WAK_ht_6
UNION ALL
SELECT
	'Інше' AS name,
	sum(WAK_h_a * quantity) / sum(quantity) AS WAK_h_a,
	sum(WAK_h_m * quantity) / sum(quantity) AS WAK_h_m,
	sum(quantity) AS quantity,
	stddev(WAK_h_a) AS std_WAK_h_a,
	stddev(WAK_h_m) AS std_WAK_h_m
FROM WAK_ht_7;

--------------------------------------
-- По всех городах и селах (level = 3)
--------------------------------------
WITH poligons AS (
	SELECT
		id_sq AS pol_id,
		name_ua AS pol_name,
		center AS city
	FROM uvekon.re_poligons
	WHERE level = 3
	),
	heating_types AS (
	SELECT 
		price_1sq_meter_usd,
		id_poligon_level_3,
		id_build_type_u,
		(
		CASE 
		WHEN heating = 'Централізоване' THEN 1
		WHEN heating = 'Індивідуальне газове' THEN 2
        WHEN heating = 'Індивідуальне електро' THEN 3
        WHEN heating = 'Власна котельня' THEN 4
        WHEN heating = 'Твердопаливне' THEN 5
        WHEN heating = 'Комбіноване' THEN 6
		ELSE 7
        END
		) AS heating_id
	FROM uvekon.re_advert
	WHERE id_type_oper = 1 AND id_subsegment = 2
	AND heating <> '' AND heating is not null
	AND price_1sq_meter_usd >= 30 AND price_1sq_meter_usd <= 5000
	AND id_build_type_u is not null
    AND id_poligon_level_3 IN (SELECT pol_id FROM poligons)
	AND date_relevance IN ('2018-06-30',
                           '2018-05-31',
						   '2018-04-30')
	),
	microdistrcts AS (
	SELECT 
		DISTINCT id_poligon_level_3,
		id_build_type_u,
		heating_id,
		concat(
			replace(to_char(id_poligon_level_3, '9999999'), ' ', ''),
			replace(to_char(id_build_type_u, '99'), ' ', '')
		) AS hash,
		COUNT(*) AS count,
		AVG(price_1sq_meter_usd) AS avg, 
		median(price_1sq_meter_usd) AS median
	FROM heating_types
	GROUP BY id_poligon_level_3, id_build_type_u, heating_id
	ORDER BY heating_id
	),
	heating_type_1 AS ( -- Централізоване опалення
	SELECT
		id_build_type_u,
		id_poligon_level_3,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE heating_id = 1 AND count >= 3
	),
	heating_type_2 AS ( -- Індивідуальне газове опалення
	SELECT
		id_build_type_u,
		id_poligon_level_3,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE heating_id = 2 AND count >= 2
	),
    heating_type_3 AS ( -- Індивідуальне електро опалення
	SELECT
		id_build_type_u,
		id_poligon_level_3,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE heating_id = 3 AND count >= 2
	),
    heating_type_4 AS ( -- Власна котельня
	SELECT
		id_build_type_u,
		id_poligon_level_3,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE heating_id = 4 AND count >= 2
	),
    heating_type_5 AS ( -- Твердопаливне опалення
	SELECT
		id_build_type_u,
		id_poligon_level_3,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE heating_id = 5 AND count >= 2
	),
    heating_type_6 AS ( -- Комбіноване опалення
	SELECT
		id_build_type_u,
		id_poligon_level_3,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE heating_id = 6 AND count >= 2
	),
    heating_type_7 AS ( -- Інше опалення
	SELECT
		id_build_type_u,
		id_poligon_level_3,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE heating_id = 7 AND count >= 2
	),
    K_ht_1 AS (
	SELECT
		DISTINCT h1.hash AS hash,
		h1.id_poligon_level_3 AS poligon,
		h1.id_build_type_u AS build_type,
		h1.count AS quantity,
		h1.avg / h1.avg AS K_h_a,
		h1.median / h1.median AS K_h_m
	FROM heating_type_1 h1, heating_type_2 h2
	WHERE h1.hash = h2.hash 
	ORDER BY build_type
	),
	K_ht_2 AS (
	SELECT
		DISTINCT h2.hash AS hash,
		h2.id_poligon_level_3 AS poligon,
		h2.id_build_type_u AS build_type,
		h2.count AS quantity,
		h2.avg / h1.avg AS K_h_a,
		h2.median / h1.median AS K_h_m
	FROM heating_type_1 h1, heating_type_2 h2
	WHERE h1.hash = h2.hash
	ORDER BY build_type
	),
    K_ht_3 AS (
	SELECT
		DISTINCT h3.hash AS hash,
		h3.id_poligon_level_3 AS poligon,
		h3.id_build_type_u AS build_type,
		h3.count AS quantity,
		h3.avg / h1.avg AS K_h_a,
		h3.median / h1.median AS K_h_m
	FROM heating_type_1 h1, heating_type_3 h3
	WHERE h1.hash = h3.hash
	ORDER BY build_type
	),
    K_ht_4 AS (
	SELECT
		DISTINCT h4.hash AS hash,
		h4.id_poligon_level_3 AS poligon,
		h4.id_build_type_u AS build_type,
		h4.count AS quantity,
		h4.avg / h1.avg AS K_h_a,
		h4.median / h1.median AS K_h_m
	FROM heating_type_1 h1, heating_type_4 h4
	WHERE h1.hash = h4.hash
	ORDER BY build_type
	),
    K_ht_5 AS (
	SELECT
		DISTINCT h5.hash AS hash,
		h5.id_poligon_level_3 AS poligon,
		h5.id_build_type_u AS build_type,
		h5.count AS quantity,
		h5.avg / h1.avg AS K_h_a,
		h5.median / h1.median AS K_h_m
	FROM heating_type_1 h1, heating_type_5 h5
	WHERE h1.hash = h5.hash
	ORDER BY build_type
	),
    K_ht_6 AS (
	SELECT
		DISTINCT h6.hash AS hash,
		h6.id_poligon_level_3 AS poligon,
		h6.id_build_type_u AS build_type,
		h6.count AS quantity,
		h6.avg / h1.avg AS K_h_a,
		h6.median / h1.median AS K_h_m
	FROM heating_type_1 h1, heating_type_6 h6
	WHERE h1.hash = h6.hash
	ORDER BY build_type
	),
    K_ht_7 AS (
	SELECT
		DISTINCT h7.hash AS hash,
		h7.id_poligon_level_3 AS poligon,
		h7.id_build_type_u AS build_type,
		h7.count AS quantity,
		h7.avg / h1.avg AS K_h_a,
		h7.median / h1.median AS K_h_m
	FROM heating_type_1 h1, heating_type_7 h7
	WHERE h1.hash = h7.hash
	ORDER BY build_type
	),
	WAK_ht_1 AS (
	SELECT
		DISTINCT poligon,
		sum(K_h_a * quantity) / sum(quantity) AS WAK_h_a,
		sum(K_h_m * quantity) / sum(quantity) AS WAK_h_m,
		sum(quantity) AS quantity
	FROM K_ht_1
	GROUP BY poligon
	),
    WAK_ht_2 AS (
	SELECT
		DISTINCT poligon,
		sum(K_h_a * quantity) / sum(quantity) AS WAK_h_a,
		sum(K_h_m * quantity) / sum(quantity) AS WAK_h_m,
		sum(quantity) AS quantity
	FROM K_ht_2
	GROUP BY poligon
	),
    WAK_ht_3 AS (
	SELECT
		DISTINCT poligon,
		sum(K_h_a * quantity) / sum(quantity) AS WAK_h_a,
		sum(K_h_m * quantity) / sum(quantity) AS WAK_h_m,
		sum(quantity) AS quantity
	FROM K_ht_3
	GROUP BY poligon
	),
    WAK_ht_4 AS (
	SELECT
		DISTINCT poligon,
		sum(K_h_a * quantity) / sum(quantity) AS WAK_h_a,
		sum(K_h_m * quantity) / sum(quantity) AS WAK_h_m,
		sum(quantity) AS quantity
	FROM K_ht_4
	GROUP BY poligon
	),
    WAK_ht_5 AS (
	SELECT
		DISTINCT poligon,
		sum(K_h_a * quantity) / sum(quantity) AS WAK_h_a,
		sum(K_h_m * quantity) / sum(quantity) AS WAK_h_m,
		sum(quantity) AS quantity
	FROM K_ht_5
	GROUP BY poligon
	),
    WAK_ht_6 AS (
	SELECT
		DISTINCT poligon,
		sum(K_h_a * quantity) / sum(quantity) AS WAK_h_a,
		sum(K_h_m * quantity) / sum(quantity) AS WAK_h_m,
		sum(quantity) AS quantity
	FROM K_ht_6
	GROUP BY poligon
	),
    WAK_ht_7 AS (
	SELECT
		DISTINCT poligon,
		sum(K_h_a * quantity) / sum(quantity) AS WAK_h_a,
		sum(K_h_m * quantity) / sum(quantity) AS WAK_h_m,
		sum(quantity) AS quantity
	FROM K_ht_7
	GROUP BY poligon
	)
SELECT
	'Централізоване' AS name,
	sum(WAK_h_a * quantity) / sum(quantity) AS WAK_h_a,
	sum(WAK_h_m * quantity) / sum(quantity) AS WAK_h_m,
	sum(quantity) AS quantity,
	stddev(WAK_h_a) AS std_WAK_h_a,
	stddev(WAK_h_m) AS std_WAK_h_m
FROM WAK_ht_1
UNION ALL
SELECT
	'Індивідуальне газове' AS name,
	sum(WAK_h_a * quantity) / sum(quantity) AS WAK_h_a,
	sum(WAK_h_m * quantity) / sum(quantity) AS WAK_h_m,
	sum(quantity) AS quantity,
	stddev(WAK_h_a) AS std_WAK_h_a,
	stddev(WAK_h_m) AS std_WAK_h_m
FROM WAK_ht_2
UNION ALL
SELECT
	'Індивідуальне електро' AS name,
	sum(WAK_h_a * quantity) / sum(quantity) AS WAK_h_a,
	sum(WAK_h_m * quantity) / sum(quantity) AS WAK_h_m,
	sum(quantity) AS quantity,
	stddev(WAK_h_a) AS std_WAK_h_a,
	stddev(WAK_h_m) AS std_WAK_h_m
FROM WAK_ht_3
UNION ALL
SELECT
	'Власна котельня' AS name,
	sum(WAK_h_a * quantity) / sum(quantity) AS WAK_h_a,
	sum(WAK_h_m * quantity) / sum(quantity) AS WAK_h_m,
	sum(quantity) AS quantity,
	stddev(WAK_h_a) AS std_WAK_h_a,
	stddev(WAK_h_m) AS std_WAK_h_m
FROM WAK_ht_4
UNION ALL
SELECT
	'Твердопаливне' AS name,
	sum(WAK_h_a * quantity) / sum(quantity) AS WAK_h_a,
	sum(WAK_h_m * quantity) / sum(quantity) AS WAK_h_m,
	sum(quantity) AS quantity,
	stddev(WAK_h_a) AS std_WAK_h_a,
	stddev(WAK_h_m) AS std_WAK_h_m
FROM WAK_ht_5
UNION ALL
SELECT
	'Комбіноване' AS name,
	sum(WAK_h_a * quantity) / sum(quantity) AS WAK_h_a,
	sum(WAK_h_m * quantity) / sum(quantity) AS WAK_h_m,
	sum(quantity) AS quantity,
	stddev(WAK_h_a) AS std_WAK_h_a,
	stddev(WAK_h_m) AS std_WAK_h_m
FROM WAK_ht_6
UNION ALL
SELECT
	'Інше' AS name,
	sum(WAK_h_a * quantity) / sum(quantity) AS WAK_h_a,
	sum(WAK_h_m * quantity) / sum(quantity) AS WAK_h_m,
	sum(quantity) AS quantity,
	stddev(WAK_h_a) AS std_WAK_h_a,
	stddev(WAK_h_m) AS std_WAK_h_m
FROM WAK_ht_7;