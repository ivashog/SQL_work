--------------------------------------------------------------------------------------------
--** Значення коефіцієнтів коригуванння середньої ціни за кв.м. житла відповідно до ... **--
--------------------------------------------------------------------------------------------
--* 5_типу_планування_квартири *--
--------------------------------------------------------------------------------------------

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
	AND date_relevance IN ('2018-06-30',
                           '2018-05-31',
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
FROM WAK_4_1;

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
	AND date_relevance IN ('2018-06-30',
                           '2018-05-31',
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
FROM WAK_6_1;