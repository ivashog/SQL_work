--------------------------------------------------------------------------------------------
--** Значення коефіцієнтів коригуванння середньої ціни за кв.м. житла відповідно до ... **--
--------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------
--* 1_загальної_площі *--

-- Житло радянської забудови (соціальне) --
-- re_advert_load --
WITH category AS (
	SELECT 
		price_1sq_meter_usd,
		(
		CASE 
		WHEN total_area_d < 30 THEN 1
		WHEN total_area_d >= 30 AND total_area_d < 40 THEN 2
		WHEN total_area_d >= 40 AND total_area_d < 50 THEN 3
		WHEN total_area_d >= 50 AND total_area_d < 65 THEN 4
		WHEN total_area_d >= 65 AND total_area_d < 80 THEN 5
		ELSE 6 END
		) AS cat_id
	FROM uvekon.re_advert_load
	WHERE status = 1 AND id_type_oper = 1 AND id_subsegment = 2
	AND id_build_type_u is not null
	AND id_build_type_u IN (1,2,3,4,5,6,7)
	AND price_1sq_meter_usd >= 20 AND price_1sq_meter_usd <= 2000
	)
SELECT 
	cat_id,
	COUNT(*),
	AVG(price_1sq_meter_usd), 
	median(price_1sq_meter_usd)
FROM category
GROUP BY cat_id
ORDER BY cat_id;
-- re_advert --
WITH category AS (
	SELECT 
		price_1sq_meter_usd,
		(
		CASE 
		WHEN total_area < 30 THEN 1
		WHEN total_area >= 30 AND total_area < 40 THEN 2
		WHEN total_area >= 40 AND total_area < 50 THEN 3
		WHEN total_area >= 50 AND total_area < 65 THEN 4
		WHEN total_area >= 65 AND total_area < 80 THEN 5
		ELSE 6 END
		) AS cat_id
	FROM uvekon.re_advert
	WHERE id_type_oper = 1 AND id_subsegment = 2
	AND id_build_type_u is not null
	AND id_build_type_u IN (1,2,3,4,5,6,7)
	AND price_1sq_meter_usd >= 20 AND price_1sq_meter_usd <= 2000
	AND date_relevance IN ('2018-05-31')
	)
SELECT 
	cat_id,
	COUNT(*),
	AVG(price_1sq_meter_usd), 
	median(price_1sq_meter_usd)
FROM category
GROUP BY cat_id
ORDER BY cat_id;
----------------

-------------------
-- Cучасне житло --
WITH category AS (
	SELECT 
		price_1sq_meter_usd,
		(
		CASE 
		WHEN total_area_d < 30 THEN 1
		WHEN total_area_d >= 30 AND total_area_d < 50 THEN 2
		WHEN total_area_d >= 50 AND total_area_d < 65 THEN 3
		WHEN total_area_d >= 65 AND total_area_d < 90 THEN 4
		WHEN total_area_d >= 90 AND total_area_d < 120 THEN 5
		ELSE 6 END
		) AS cat_id
	FROM uvekon.re_advert_load
	WHERE status = 1 AND id_type_oper = 1 AND id_subsegment = 2
	AND id_build_type_u is not null
	AND id_build_type_u IN (8,9,10)
	AND price_1sq_meter_usd >= 20 AND price_1sq_meter_usd <= 2000
	)
SELECT 
	cat_id,
	COUNT(*),
	AVG(price_1sq_meter_usd), 
	median(price_1sq_meter_usd)
FROM category
GROUP BY cat_id
ORDER BY cat_id;
-- re_advert --
WITH category AS (
	SELECT 
		price_1sq_meter_usd,
		(
		CASE 
		WHEN total_area < 30 THEN 1
		WHEN total_area >= 30 AND total_area < 50 THEN 2
		WHEN total_area >= 50 AND total_area < 65 THEN 3
		WHEN total_area >= 65 AND total_area < 90 THEN 4
		WHEN total_area >= 90 AND total_area < 120 THEN 5
		ELSE 6 END
		) AS cat_id
	FROM uvekon.re_advert
	WHERE id_type_oper = 1 AND id_subsegment = 2
	AND id_build_type_u is not null
	AND id_build_type_u IN (8,9,10)
	AND price_1sq_meter_usd >= 20 AND price_1sq_meter_usd <= 2000
	AND date_relevance IN ('2018-05-31')
	)
SELECT 
	cat_id,
	COUNT(*),
	AVG(price_1sq_meter_usd), 
	median(price_1sq_meter_usd)
FROM category
GROUP BY cat_id
ORDER BY cat_id;
---------------------------------------------------------------------

---------------------------------------------------------------------
--* 2_типу_забудови *--

-- re_advert_load --
SELECT 
	id_build_type_u,
	COUNT(*), 
	AVG(price_1sq_meter_usd),
	median(price_1sq_meter_usd)
FROM uvekon.re_advert_load
WHERE id_build_type_u is not null
AND status = 1 AND id_type_oper = 1 AND id_subsegment = 2
AND price_1sq_meter_usd >= 20 AND price_1sq_meter_usd <= 5000
GROUP BY id_build_type_u
ORDER BY id_build_type_u DESC
-- re_advert --
SELECT 
	id_build_type_u,
	COUNT(*), 
	AVG(price_1sq_meter_usd),
	median(price_1sq_meter_usd)
FROM uvekon.re_advert
WHERE id_build_type_u is not null
AND id_type_oper = 1 AND id_subsegment = 2
AND price_1sq_meter_usd >= 20 AND price_1sq_meter_usd <= 5000
AND date_relevance IN ('2018-05-31')
GROUP BY id_build_type_u
ORDER BY id_build_type_u DESC
--------------------------------------------------------------------

--------------------------------------------------------------------
--* 3_матеріалу_стін_будинку *--

-- Житло радянської забудови (соціальне) --

-- re_advert_load --
SELECT 
	id_wall_material,
	COUNT(*), 
	AVG(price_1sq_meter_usd),
	median(price_1sq_meter_usd)
FROM uvekon.re_advert_load
WHERE id_wall_material is not null
AND id_wall_material IN (1,2,4,5)
AND status = 1 AND id_type_oper = 1 AND id_subsegment = 2
AND price_1sq_meter_usd >= 20 AND price_1sq_meter_usd <= 5000
AND id_build_type_u IN (1,2,3,4,5,6,7)
GROUP BY id_wall_material
ORDER BY id_wall_material
-- re_advert --
SELECT 
	id_wall_material,
	COUNT(*), 
	AVG(price_1sq_meter_usd),
	median(price_1sq_meter_usd)
FROM uvekon.re_advert
WHERE id_wall_material is not null
AND id_wall_material IN (1,2,4,5)
AND id_type_oper = 1 AND id_subsegment = 2
AND price_1sq_meter_usd >= 20 AND price_1sq_meter_usd <= 5000
AND id_build_type_u IN (1,2,3,4,5,6,7)
AND date_relevance IN ('2018-05-31')
GROUP BY id_wall_material
ORDER BY id_wall_material

-- Cучасне житло --

-- re_advert_load --
SELECT 
	id_wall_material,
	COUNT(*), 
	AVG(price_1sq_meter_usd),
	median(price_1sq_meter_usd)
FROM uvekon.re_advert_load
WHERE id_wall_material is not null
AND id_wall_material IN (1,2,3,4,5)
AND status = 1 AND id_type_oper = 1 AND id_subsegment = 2
AND price_1sq_meter_usd >= 20 AND price_1sq_meter_usd <= 5000
AND id_build_type_u IN (8,9,10)
GROUP BY id_wall_material
ORDER BY id_wall_material
-- re_advert --
SELECT 
	id_wall_material,
	COUNT(*), 
	AVG(price_1sq_meter_usd),
	median(price_1sq_meter_usd)
FROM uvekon.re_advert
WHERE id_wall_material is not null
AND id_wall_material IN (1,2,3,4,5)
AND id_type_oper = 1 AND id_subsegment = 2
AND price_1sq_meter_usd >= 20 AND price_1sq_meter_usd <= 5000
AND id_build_type_u IN (8,9,10)
AND date_relevance IN ('2018-05-31')
GROUP BY id_wall_material
ORDER BY id_wall_material
------------------------------------------------------------------------

------------------------------------------------------------------------
--* 4_поверху_розташування *--

-- re_advert_load --
WITH floors AS (
	SELECT 
		price_1sq_meter_usd,
		(
		CASE 
		WHEN floor = '1' THEN 2
		WHEN floor = qt_floor AND qt_floor <> '' AND qt_floor is not null THEN 3
		ELSE 1 END
		) AS floor_id
	FROM uvekon.re_advert_load
	WHERE status = 1 AND id_type_oper = 1 AND id_subsegment = 2
	AND floor <> '' AND floor is not null
	AND price_1sq_meter_usd >= 20 AND price_1sq_meter_usd <= 5000
	)
SELECT 
	floor_id,
	COUNT(*),
	AVG(price_1sq_meter_usd), 
	median(price_1sq_meter_usd)
FROM floors
GROUP BY floor_id
ORDER BY floor_id;
-- re_advert --
WITH floors AS (
	SELECT 
		price_1sq_meter_usd,
		(
		CASE 
		WHEN floor = 1 THEN 2
		WHEN floor = qt_floor AND qt_floor is not null THEN 3
		ELSE 1 END
		) AS floor_id
	FROM uvekon.re_advert
	WHERE id_type_oper = 1 AND id_subsegment = 2
	AND floor is not null
	AND price_1sq_meter_usd >= 20 AND price_1sq_meter_usd <= 5000
	AND date_relevance IN ('2018-05-31',
						   '2018-04-30',
						   '2018-03-31',
						   '2018-02-28',
						   '2018-01-31')
	AND id_poligon_level_3 IN (2408001)
	)
SELECT 
	floor_id,
	COUNT(*),
	AVG(price_1sq_meter_usd), 
	median(price_1sq_meter_usd)
FROM floors
GROUP BY floor_id
ORDER BY floor_id;
--------------------------
WITH floors AS (
	SELECT 
		price_1sq_meter_usd,
		(
		CASE 
		WHEN floor = '1' THEN 2
		WHEN floor = qt_floor AND qt_floor <> '' AND qt_floor is not null THEN 3
		ELSE 1 END
		) AS floor_id
	FROM uvekon.re_advert_load
	WHERE status = 1 AND id_type_oper = 1 AND id_subsegment = 2
	AND floor <> '' AND floor is not null
	AND price_1sq_meter_usd >= 20 AND price_1sq_meter_usd <= 5000
	)
SELECT 
	floor_id,
	COUNT(*),
	AVG(price_1sq_meter_usd), 
	median(price_1sq_meter_usd)
FROM floors
GROUP BY floor_id
ORDER BY floor_id;
--По городам в разрезе типов домов
WITH floors AS (
	SELECT 
		price_1sq_meter_usd,
		(
		CASE 
		WHEN floor = '1' THEN 2
		WHEN floor = qt_floor THEN 3
		ELSE 1 END
		) AS floor_id,
		id_build_type_u
	FROM uvekon.re_advert_load
	WHERE status = 1 AND id_type_oper = 1 AND id_subsegment = 2
	AND floor <> '' AND floor is not null
	AND price_1sq_meter_usd >= 20 AND price_1sq_meter_usd <= 5000
	AND id_build_type_u is not null
	AND id_kotuu_district = '23101'
	)
SELECT 
	DISTINCT id_build_type_u,
	floor_id,
	COUNT(*),
	AVG(price_1sq_meter_usd), 
	median(price_1sq_meter_usd)
FROM floors
GROUP BY id_build_type_u, floor_id
ORDER BY floor_id;


---****
WITH floors AS (
	SELECT 
		price_1sq_meter_usd,
		(
		CASE 
		WHEN floor = 1 THEN 2
		WHEN floor = qt_floor THEN 3
		ELSE 1 END
		) AS floor_id,
		id_build_type_u,
		id_poligon_level_4
	FROM uvekon.re_advert
	WHERE id_type_oper = 1 AND id_subsegment = 2
	AND floor is not null
	AND price_1sq_meter_usd >= 20 AND price_1sq_meter_usd <= 5000
	AND id_build_type_u is not null AND id_poligon_level_4 is not null
	AND date_relevance IN ('2018-05-31')
	),
	microdistricts AS (
	SELECT 
		DISTINCT id_poligon_level_4,
		id_build_type_u,
		floor_id,
		COUNT(*) AS count,
		AVG(price_1sq_meter_usd) AS avg, 
		median(price_1sq_meter_usd) AS median
	FROM floors
	GROUP BY id_poligon_level_4, id_build_type_u, floor_id
	ORDER BY floor_id
	)
SELECT
	DISTINCT id_build_type_u,
	id_poligon_level_4,
	floor_id,
	count,
	avg,
	median
FROM microdistricts
----------------------------------------- Новый подход -----------------------------------------------

-- Step 1 --
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
AND price_1sq_meter_usd >= 20 AND price_1sq_meter_usd <= 5000
AND id_build_type_u is not null AND id_poligon_level_4 is not null
AND date_relevance IN ('2018-05-31')
AND id_poligon_level_4 = 2400000004
	
-- Step 2 --
WITH floors AS (
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
	AND price_1sq_meter_usd >= 20 AND price_1sq_meter_usd <= 5000
	AND id_build_type_u is not null AND id_poligon_level_4 is not null
	AND date_relevance IN ('2018-05-31')
	AND id_poligon_level_4 = 2400000004
	)
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

-- Step 3 --
WITH floors AS (
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
	AND price_1sq_meter_usd >= 20 AND price_1sq_meter_usd <= 5000
	AND id_build_type_u is not null AND id_poligon_level_4 is not null
	AND date_relevance IN ('2018-05-31', '2018-04-30')
	AND id_poligon_level_4 IN (2400000159) 
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
	)
SELECT
	DISTINCT nth.hash AS hash,
	first.id_poligon_level_4 AS poligon,
	first.id_build_type_u AS build_type,
	first.count AS quantity,
	first.avg / nth.avg AS K_first_a
FROM nth_floor nth, first_floor first
WHERE nth.hash = first.hash
ORDER BY build_type

-- Step 4 --
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
	AND price_1sq_meter_usd >= 20 AND price_1sq_meter_usd <= 5000
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
	)
SELECT
	DISTINCT poligon,
	(SELECT pol_name FROM poligons WHERE pol_id = poligon) AS microdistrict,
	(SELECT city FROM poligons WHERE pol_id = poligon) AS city,
	sum(K_first_a * quantity) / sum(quantity) AS weighted_K_first_a,
	sum(quantity) AS quantity
FROM K_first
GROUP BY poligon;
-- Step 5 --
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
	AND price_1sq_meter_usd >= 20 AND price_1sq_meter_usd <= 5000
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
	sum(first.quantity) AS K_quantity
FROM weighted_K_first_by_poligon first
UNION ALL
SELECT
	'Останній поверх' AS K_name,
	avg(last.weighted_K_last_a) AS avg_K_a,
	median(last.weighted_K_last_a) AS median_K_a,
	sum(last.weighted_K_last_a * last.quantity) / sum(last.quantity) AS weighted_K_a,
	sum(last.quantity) AS K_quantity
FROM weighted_K_last_by_poligon last;
	
	

-- Step 6 --

------------------------------------------------------------------------------------

------------------------------------------------------------------------------------
--* 5_типу_планування_квартири *--

-- Всього --

-- re_advert_load --
WITH apartment_layouts AS (
	SELECT 
		price_1sq_meter_usd,
		(
		CASE 
		WHEN apartment_layout = 'Роздільна' THEN 1
		WHEN apartment_layout = 'Суміжна, прохідна' THEN 2
		WHEN apartment_layout = 'Студія' THEN 3
		WHEN apartment_layout = 'Вільне планування' THEN 4
		WHEN apartment_layout = 'Двостороння' THEN 5
		WHEN apartment_layout = 'Багаторівнева' THEN 6
		WHEN apartment_layout = 'Малосімейка, гостинка' THEN 7
		WHEN apartment_layout = 'Пентхаус' THEN 8
		WHEN apartment_layout = 'Смарт-квартира' THEN 9
		ELSE null END
		) AS apartment_layout_id
	FROM uvekon.re_advert_load
	WHERE status = 1 AND id_type_oper = 1 AND id_subsegment = 2
	AND apartment_layout <> '' AND apartment_layout is not null
	AND price_1sq_meter_usd >= 20 AND price_1sq_meter_usd <= 5000
	)
SELECT 
	apartment_layout_id,
	COUNT(*),
	AVG(price_1sq_meter_usd), 
	median(price_1sq_meter_usd)
FROM apartment_layouts
GROUP BY apartment_layout_id
ORDER BY apartment_layout_id;
-- re_advert --
WITH apartment_layouts AS (
	SELECT 
		price_1sq_meter_usd,
		(
		CASE 
		WHEN apartment_layout = 'Роздільна' THEN 1
		WHEN apartment_layout = 'Суміжна, прохідна' THEN 2
		WHEN apartment_layout = 'Студія' THEN 3
		WHEN apartment_layout = 'Вільне планування' THEN 4
		WHEN apartment_layout = 'Двостороння' THEN 5
		WHEN apartment_layout = 'Багаторівнева' THEN 6
		WHEN apartment_layout = 'Малосімейка, гостинка' THEN 7
		WHEN apartment_layout = 'Пентхаус' THEN 8
		WHEN apartment_layout = 'Смарт-квартира' THEN 9
		ELSE null END
		) AS apartment_layout_id
	FROM uvekon.re_advert
	WHERE id_type_oper = 1 AND id_subsegment = 2
	AND apartment_layout <> '' AND apartment_layout is not null
	AND price_1sq_meter_usd >= 20 AND price_1sq_meter_usd <= 5000
	AND date_relevance IN ('2018-05-31',
						   '2018-04-30')
	)
SELECT 
	apartment_layout_id,
	COUNT(*),
	AVG(price_1sq_meter_usd), 
	median(price_1sq_meter_usd)
FROM apartment_layouts
GROUP BY apartment_layout_id
ORDER BY apartment_layout_id;

-- Житло радянської забудови (соціальне) --

-- re_advert_load --
WITH apartment_layouts AS (
	SELECT 
		price_1sq_meter_usd,
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
	FROM uvekon.re_advert_load
	WHERE status = 1 AND id_type_oper = 1 AND id_subsegment = 2
	AND apartment_layout <> '' AND apartment_layout is not null
	AND price_1sq_meter_usd >= 20 AND price_1sq_meter_usd <= 5000
	AND id_build_type_u IN (1,2,3,4,5,6,7)
	)
SELECT 
	apartment_layout_id,
	COUNT(*),
	AVG(price_1sq_meter_usd), 
	median(price_1sq_meter_usd)
FROM apartment_layouts
WHERE apartment_layout_id is not null
GROUP BY apartment_layout_id
ORDER BY apartment_layout_id;
-- re_advert --
WITH apartment_layouts AS (
	SELECT 
		price_1sq_meter_usd,
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
	)
SELECT 
	apartment_layout_id,
	COUNT(*),
	AVG(price_1sq_meter_usd), 
	median(price_1sq_meter_usd)
FROM apartment_layouts
WHERE apartment_layout_id is not null
GROUP BY apartment_layout_id
ORDER BY apartment_layout_id;

-- Cучасне житло --

-- re_advert_load --
WITH apartment_layouts AS (
	SELECT 
		price_1sq_meter_usd,
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
	FROM uvekon.re_advert_load
	WHERE status = 1 AND id_type_oper = 1 AND id_subsegment = 2
	AND apartment_layout <> '' AND apartment_layout is not null
	AND price_1sq_meter_usd >= 20 AND price_1sq_meter_usd <= 5000
	AND id_build_type_u IN (8,9,10)
	)
SELECT 
	apartment_layout_id,
	COUNT(*),
	AVG(price_1sq_meter_usd), 
	median(price_1sq_meter_usd)
FROM apartment_layouts
WHERE apartment_layout_id is not null
GROUP BY apartment_layout_id
ORDER BY apartment_layout_id;
-- re_advert --
WITH apartment_layouts AS (
	SELECT 
		price_1sq_meter_usd,
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
	AND price_1sq_meter_usd >= 20 AND price_1sq_meter_usd <= 5000
	AND id_build_type_u IN (8,9,10)
	AND date_relevance IN ('2018-05-31',
						   '2018-04-30')
	)
SELECT 
	apartment_layout_id,
	COUNT(*),
	AVG(price_1sq_meter_usd), 
	median(price_1sq_meter_usd)
FROM apartment_layouts
WHERE apartment_layout_id is not null
GROUP BY apartment_layout_id
ORDER BY apartment_layout_id;
---------------------------------------------------------------------

---------------------------------------------------------------------
--* 6_наявності_меблів *--

-- re_advert_load --
SELECT 
	DISTINCT furnishing, 
	COUNT(furnishing) AS count,  
	AVG(price_1sq_meter_usd), 
	median(price_1sq_meter_usd) 
FROM uvekon.re_advert_load
WHERE furnishing is not null AND furnishing <> ''
AND status = 1 AND id_type_oper = 1 AND id_subsegment = 2
AND price_1sq_meter_usd >= 20 AND price_1sq_meter_usd <= 5000
GROUP BY furnishing
ORDER BY count DESC
-- re_advert --
SELECT 
	DISTINCT furnishing, 
	COUNT(furnishing) AS count,  
	AVG(price_1sq_meter_usd), 
	median(price_1sq_meter_usd) 
FROM uvekon.re_advert
WHERE furnishing is not null AND furnishing <> ''
AND id_type_oper = 1 AND id_subsegment = 2
AND price_1sq_meter_usd >= 20 AND price_1sq_meter_usd <= 5000
AND date_relevance IN ('2018-05-31',
					   '2018-04-30')
GROUP BY furnishing
ORDER BY count DESC;
-------------------------------------------------------------------

-------------------------------------------------------------------
--* 7_наявності_ліфту *--

-- Житло радянської забудови (соціальне) --

-- re_advert_load --
WITH comforts AS (
	SELECT 
		price_1sq_meter_usd,
		(
		CASE 
		WHEN (comfort like '%Ліфт%' AND comfort like '%Грузовий ліфт%') THEN 3
		WHEN comfort like '%Ліфт%' THEN 2
		ELSE 1 END
		) AS elevator_id
	FROM uvekon.re_advert_load
	WHERE status = 1 AND id_type_oper = 1 AND id_subsegment = 2
	AND comfort <> '' AND comfort is not null
	AND price_1sq_meter_usd >= 20 AND price_1sq_meter_usd <= 5000
	AND id_build_type_u IN (1,2,3,4,5,6,7)
	)
SELECT 
	elevator_id,
	COUNT(*),
	AVG(price_1sq_meter_usd), 
	median(price_1sq_meter_usd)
FROM comforts
WHERE elevator_id is not null
GROUP BY elevator_id
ORDER BY elevator_id;
-- re_advert --
WITH comforts AS (
	SELECT 
		price_1sq_meter_usd,
		(
		CASE 
		WHEN (comfort like '%Ліфт%' AND comfort like '%Грузовий ліфт%') THEN 3
		WHEN comfort like '%Ліфт%' THEN 2
		ELSE 1 END
		) AS elevator_id
	FROM uvekon.re_advert
	WHERE id_type_oper = 1 AND id_subsegment = 2
	AND comfort <> '' AND comfort is not null
	AND price_1sq_meter_usd >= 20 AND price_1sq_meter_usd <= 5000
	AND id_build_type_u IN (1,2,3,4,5,6,7)
	AND date_relevance IN ('2018-05-31',
						   '2018-04-30')
	)
SELECT 
	elevator_id,
	COUNT(*),
	AVG(price_1sq_meter_usd), 
	median(price_1sq_meter_usd)
FROM comforts
WHERE elevator_id is not null
GROUP BY elevator_id
ORDER BY elevator_id;

-- Cучасне житло --

-- re_advert_load --
WITH comforts AS (
	SELECT 
		price_1sq_meter_usd,
		(
		CASE 
		WHEN (comfort like '%Ліфт%' AND comfort like '%Грузовий ліфт%') THEN 3
		WHEN comfort like '%Ліфт%' THEN 2
		ELSE 1 END
		) AS elevator_id
	FROM uvekon.re_advert_load
	WHERE status = 1 AND id_type_oper = 1 AND id_subsegment = 2
	AND comfort <> '' AND comfort is not null
	AND price_1sq_meter_usd >= 20 AND price_1sq_meter_usd <= 5000
	AND id_build_type_u IN (8,9,10)
	)
SELECT 
	elevator_id,
	COUNT(*),
	AVG(price_1sq_meter_usd), 
	median(price_1sq_meter_usd)
FROM comforts
WHERE elevator_id is not null
GROUP BY elevator_id
ORDER BY elevator_id;
-- re_advert --
WITH comforts AS (
	SELECT 
		price_1sq_meter_usd,
		(
		CASE 
		WHEN (comfort like '%Ліфт%' AND comfort like '%Грузовий ліфт%') THEN 3
		WHEN comfort like '%Ліфт%' THEN 2
		ELSE 1 END
		) AS elevator_id
	FROM uvekon.re_advert
	WHERE id_type_oper = 1 AND id_subsegment = 2
	AND comfort <> '' AND comfort is not null
	AND price_1sq_meter_usd >= 20 AND price_1sq_meter_usd <= 5000
	AND id_build_type_u IN (8,9,10)
	AND date_relevance IN ('2018-05-31',
						   '2018-04-30')
	)
SELECT 
	elevator_id,
	COUNT(*),
	AVG(price_1sq_meter_usd), 
	median(price_1sq_meter_usd)
FROM comforts
WHERE elevator_id is not null
GROUP BY elevator_id
ORDER BY elevator_id;
------------------------------------------------------------------------------------
-- київ радянське
WITH comforts AS (
	SELECT 
		price_1sq_meter_usd,
		(
		CASE 
		WHEN comfort like '%Грузовий ліфт%' THEN 3
		WHEN (comfort like '%Ліфт%' AND comfort not like '%Грузовий ліфт%') THEN 2
		WHEN  qt_floor in ('1', '2', '3', '4', '5') THEN 1
		ELSE null END
		) AS elevator_id
	FROM uvekon.re_advert_load
	WHERE status = 1 AND id_type_oper = 1 AND id_subsegment = 2
	AND comfort <> '' AND comfort is not null
	AND price_1sq_meter_usd >= 20 AND price_1sq_meter_usd <= 5000
	AND id_build_type_u IN (2,3,4,5,6,7)
	AND id_region = '80'
	)
SELECT 
	elevator_id,
	COUNT(*),
	AVG(price_1sq_meter_usd), 
	median(price_1sq_meter_usd)
FROM comforts
WHERE elevator_id is not null
GROUP BY elevator_id
ORDER BY elevator_id;
-- київ сучасне
WITH comforts AS (
	SELECT 
		price_1sq_meter_usd,
		(
		CASE 
		WHEN comfort like '%Грузовий ліфт%' THEN 3
		WHEN (comfort like '%Ліфт%' AND comfort not like '%Грузовий ліфт%') THEN 2
		WHEN  qt_floor in ('1', '2', '3', '4', '5') THEN 1
		ELSE null END
		) AS elevator_id
	FROM uvekon.re_advert_load
	WHERE status = 1 AND id_type_oper = 1 AND id_subsegment = 2
	AND comfort <> '' AND comfort is not null
	AND price_1sq_meter_usd >= 20 AND price_1sq_meter_usd <= 5000
	AND id_build_type_u IN (8,9,10)
	AND id_region = '80'
	)
SELECT 
	elevator_id,
	COUNT(*),
	AVG(price_1sq_meter_usd), 
	median(price_1sq_meter_usd)
FROM comforts
WHERE elevator_id is not null
GROUP BY elevator_id
ORDER BY elevator_id;
---------------------------------------------------------------------

---------------------------------------------------------------------
--* 8_видових_характеристик *--

-- re_advert_load --
--!
WITH comforts AS (
	SELECT 
		price_1sq_meter_usd,
		(
		CASE 
		WHEN (comfort like '%Панорамні вікна%' 
			 OR (lower(advert_text) like '%панорамны%' 
			 OR lower(advert_text) like '%панорамни%'
			 OR lower(advert_text) like '%панорамні%')) THEN 2
		ELSE 1 END
		) AS panoram_id
	FROM uvekon.re_advert_load
	WHERE status = 1 AND id_type_oper = 1 AND id_subsegment = 2
	AND price_1sq_meter_usd >= 20 AND price_1sq_meter_usd <= 5000
	)
SELECT 
	panoram_id,
	COUNT(*),
	AVG(price_1sq_meter_usd), 
	median(price_1sq_meter_usd)
FROM comforts
WHERE panoram_id is not null
GROUP BY panoram_id
ORDER BY panoram_id;

--*
WITH comforts AS (
	SELECT 
		price_1sq_meter_usd,
		(
		CASE 
		WHEN comfort like '%Панорамні вікна%' THEN 2
		ELSE 1 END
		) AS panoram_id
	FROM uvekon.re_advert_load
	WHERE status = 1 AND id_type_oper = 1 AND id_subsegment = 2
	AND comfort <> '' AND comfort is not null
	AND price_1sq_meter_usd >= 20 AND price_1sq_meter_usd <= 5000
	)
SELECT 
	panoram_id,
	COUNT(*),
	AVG(price_1sq_meter_usd), 
	median(price_1sq_meter_usd)
FROM comforts
WHERE panoram_id is not null
GROUP BY panoram_id
ORDER BY panoram_id;

-- re_advert --