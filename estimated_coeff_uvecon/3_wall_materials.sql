--------------------------------------------------------------------------------------------
--** Значення коефіцієнтів коригуванння середньої ціни за кв.м. житла відповідно до ... **--
--------------------------------------------------------------------------------------------
--* 3_матеріалу_стін_будинку *--
--------------------------------------------------------------------------------------------

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
FROM WAK_4_1_by_city;

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
FROM WAK_5_1_by_city;