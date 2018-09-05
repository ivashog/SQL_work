--------------------------------------------------------------------------------------------
--** Значення коефіцієнтів коригуванння середньої ціни за кв.м. житла відповідно до ... **--
--------------------------------------------------------------------------------------------
--* 7_наявності_ліфту *--
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
    elevators AS (
	SELECT 
		(
		CASE 
		WHEN (comfort like '%Ліфт%' AND comfort like '%Грузовий ліфт%') THEN 3
		WHEN comfort like '%Ліфт%' THEN 2
		ELSE 1 END
		) AS elevator_id,
        id_build_type_u,
		id_poligon_level_4,
		price_1sq_meter_usd
	FROM uvekon.re_advert
	WHERE id_type_oper = 1 AND id_subsegment = 2
	AND comfort <> '' AND comfort is not null
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
		elevator_id,
		concat(
			replace(to_char(id_poligon_level_4, '9999999999'), ' ', ''),
			replace(to_char(id_build_type_u, '99'), ' ', '')
		) AS hash,
		COUNT(*) AS count,
		AVG(price_1sq_meter_usd) AS avg, 
		median(price_1sq_meter_usd) AS median
	FROM elevators
	GROUP BY id_poligon_level_4, id_build_type_u, elevator_id
	ORDER BY elevator_id
	),
    no_elevator AS ( -- ліфти відсутні
        SELECT
		id_build_type_u,
		id_poligon_level_4,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE elevator_id = 1 AND count >= 5
    ),
    passenger_elevator AS ( -- 1 і більше пасажирських ліфти
        SELECT
		id_build_type_u,
		id_poligon_level_4,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE elevator_id = 2 AND count >= 5
    ),
    passenger_and_cargo_elevator AS ( -- 1 і більше пасажирських і вантажний
        SELECT
		id_build_type_u,
		id_poligon_level_4,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE elevator_id = 3 AND count >= 5
    ),
    K_no_elevator AS (
    SELECT
        DISTINCT e0.hash AS hash,
		e0.id_poligon_level_4 AS poligon,
		e0.id_build_type_u AS build_type,
		e0.count AS quantity,
		e0.avg / e0.avg AS K_e_a,
		e0.median / e0.median AS K_e_m
	FROM passenger_elevator e1, passenger_and_cargo_elevator e2, no_elevator e0
	WHERE e0.hash = e1.hash OR e0.hash = e2.hash
	ORDER BY build_type
    ),
    K_pass_elev AS (
    SELECT
		DISTINCT e1.hash AS hash,
		e1.id_poligon_level_4 AS poligon,
		e1.id_build_type_u AS build_type,
		e1.count AS quantity,
		e1.avg / e0.avg AS K_e_a,
		e1.median / e0.median AS K_e_m
	FROM passenger_elevator e1, no_elevator e0
	WHERE e0.hash = e1.hash
	ORDER BY build_type
    ),
    K_pass_cargo_elev AS (
    SELECT
		DISTINCT e2.hash AS hash,
		e2.id_poligon_level_4 AS poligon,
		e2.id_build_type_u AS build_type,
		e2.count AS quantity,
		e2.avg / e0.avg AS K_e_a,
		e2.median / e0.median AS K_e_m
	FROM passenger_and_cargo_elevator e2, no_elevator e0
	WHERE e0.hash = e2.hash
	ORDER BY build_type
    ),
    WAK_no_elev AS (
	SELECT
		DISTINCT poligon,
		sum(K_e_a * quantity) / sum(quantity) AS WAK_e_a,
		sum(K_e_m * quantity) / sum(quantity) AS WAK_e_m,
		sum(quantity) AS quantity
	FROM K_no_elevator
	GROUP BY poligon
	),
    WAK_pass_elev AS (
	SELECT
		DISTINCT poligon,
		sum(K_e_a * quantity) / sum(quantity) AS WAK_e_a,
		sum(K_e_m * quantity) / sum(quantity) AS WAK_e_m,
		sum(quantity) AS quantity
	FROM K_pass_elev
	GROUP BY poligon
	),
    WAK_pass_cargo_elev AS (
	SELECT
		DISTINCT poligon,
		sum(K_e_a * quantity) / sum(quantity) AS WAK_e_a,
		sum(K_e_m * quantity) / sum(quantity) AS WAK_e_m,
		sum(quantity) AS quantity
	FROM K_pass_cargo_elev
	GROUP BY poligon
	)
SELECT
	'Ліфти відсутні' AS name,
	sum(WAK_e_a * quantity) / sum(quantity) AS WAK_e_a,
	sum(WAK_e_m * quantity) / sum(quantity) AS WAK_e_m,
	sum(quantity) AS quantity,
	stddev(WAK_e_a) AS std_WAK_e_a,
	stddev(WAK_e_m) AS std_WAK_e_m
FROM WAK_no_elev
UNION ALL
SELECT
	'1 і більше пасажирських ліфти' AS name,
	sum(WAK_e_a * quantity) / sum(quantity) AS WAK_e_a,
	sum(WAK_e_m * quantity) / sum(quantity) AS WAK_e_m,
	sum(quantity) AS quantity,
	stddev(WAK_e_a) AS std_WAK_e_a,
	stddev(WAK_e_m) AS std_WAK_e_m
FROM WAK_pass_elev
UNION ALL
SELECT
	'1 і більше пасажирських і вантажний' AS name,
	sum(WAK_e_a * quantity) / sum(quantity) AS WAK_e_a,
	sum(WAK_e_m * quantity) / sum(quantity) AS WAK_e_m,
	sum(quantity) AS quantity,
	stddev(WAK_e_a) AS std_WAK_e_a,
	stddev(WAK_e_m) AS std_WAK_e_m
FROM WAK_pass_cargo_elev;

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
    elevators AS (
	SELECT 
		(
		CASE 
		WHEN (comfort like '%Ліфт%' AND comfort like '%Грузовий ліфт%') THEN 3
		WHEN comfort like '%Ліфт%' THEN 2
		ELSE 1 END
		) AS elevator_id,
        id_build_type_u,
		id_poligon_level_4,
		price_1sq_meter_usd
	FROM uvekon.re_advert
	WHERE id_type_oper = 1 AND id_subsegment = 2
	AND comfort <> '' AND comfort is not null
	AND price_1sq_meter_usd >= 20 AND price_1sq_meter_usd <= 5000
	AND id_build_type_u IN (8,9,10)
	AND date_relevance IN ('2018-06-30',
                           '2018-05-31',
						   '2018-04-30')
	),
    microdistrcts AS (
	SELECT 
		DISTINCT id_poligon_level_4,
		id_build_type_u,
		elevator_id,
		concat(
			replace(to_char(id_poligon_level_4, '9999999999'), ' ', ''),
			replace(to_char(id_build_type_u, '99'), ' ', '')
		) AS hash,
		COUNT(*) AS count,
		AVG(price_1sq_meter_usd) AS avg, 
		median(price_1sq_meter_usd) AS median
	FROM elevators
	GROUP BY id_poligon_level_4, id_build_type_u, elevator_id
	ORDER BY elevator_id
	),
    no_elevator AS ( -- ліфти відсутні
        SELECT
		id_build_type_u,
		id_poligon_level_4,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE elevator_id = 1 AND count >= 5
    ),
    passenger_elevator AS ( -- 1 і більше пасажирських ліфти
        SELECT
		id_build_type_u,
		id_poligon_level_4,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE elevator_id = 2 AND count >= 5
    ),
    passenger_and_cargo_elevator AS ( -- 1 і більше пасажирських і вантажний
        SELECT
		id_build_type_u,
		id_poligon_level_4,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE elevator_id = 3 AND count >= 5
    ),
    K_no_elevator AS (
    SELECT
        DISTINCT e0.hash AS hash,
		e0.id_poligon_level_4 AS poligon,
		e0.id_build_type_u AS build_type,
		e0.count AS quantity,
		e0.avg / e0.avg AS K_e_a,
		e0.median / e0.median AS K_e_m
	FROM passenger_elevator e1, passenger_and_cargo_elevator e2, no_elevator e0
	WHERE e0.hash = e1.hash OR e0.hash = e2.hash
	ORDER BY build_type
    ),
    K_pass_elev AS (
    SELECT
		DISTINCT e1.hash AS hash,
		e1.id_poligon_level_4 AS poligon,
		e1.id_build_type_u AS build_type,
		e1.count AS quantity,
		e1.avg / e0.avg AS K_e_a,
		e1.median / e0.median AS K_e_m
	FROM passenger_elevator e1, no_elevator e0
	WHERE e0.hash = e1.hash
	ORDER BY build_type
    ),
    K_pass_cargo_elev AS (
    SELECT
		DISTINCT e2.hash AS hash,
		e2.id_poligon_level_4 AS poligon,
		e2.id_build_type_u AS build_type,
		e2.count AS quantity,
		e2.avg / e0.avg AS K_e_a,
		e2.median / e0.median AS K_e_m
	FROM passenger_and_cargo_elevator e2, no_elevator e0
	WHERE e0.hash = e2.hash
	ORDER BY build_type
    ),
    WAK_no_elev AS (
	SELECT
		DISTINCT poligon,
		sum(K_e_a * quantity) / sum(quantity) AS WAK_e_a,
		sum(K_e_m * quantity) / sum(quantity) AS WAK_e_m,
		sum(quantity) AS quantity
	FROM K_no_elevator
	GROUP BY poligon
	),
    WAK_pass_elev AS (
	SELECT
		DISTINCT poligon,
		sum(K_e_a * quantity) / sum(quantity) AS WAK_e_a,
		sum(K_e_m * quantity) / sum(quantity) AS WAK_e_m,
		sum(quantity) AS quantity
	FROM K_pass_elev
	GROUP BY poligon
	),
    WAK_pass_cargo_elev AS (
	SELECT
		DISTINCT poligon,
		sum(K_e_a * quantity) / sum(quantity) AS WAK_e_a,
		sum(K_e_m * quantity) / sum(quantity) AS WAK_e_m,
		sum(quantity) AS quantity
	FROM K_pass_cargo_elev
	GROUP BY poligon
	)
SELECT
	'Ліфти відсутні' AS name,
	sum(WAK_e_a * quantity) / sum(quantity) AS WAK_e_a,
	sum(WAK_e_m * quantity) / sum(quantity) AS WAK_e_m,
	sum(quantity) AS quantity,
	stddev(WAK_e_a) AS std_WAK_e_a,
	stddev(WAK_e_m) AS std_WAK_e_m
FROM WAK_no_elev
UNION ALL
SELECT
	'1 і більше пасажирських ліфти' AS name,
	sum(WAK_e_a * quantity) / sum(quantity) AS WAK_e_a,
	sum(WAK_e_m * quantity) / sum(quantity) AS WAK_e_m,
	sum(quantity) AS quantity,
	stddev(WAK_e_a) AS std_WAK_e_a,
	stddev(WAK_e_m) AS std_WAK_e_m
FROM WAK_pass_elev
UNION ALL
SELECT
	'1 і більше пасажирських і вантажний' AS name,
	sum(WAK_e_a * quantity) / sum(quantity) AS WAK_e_a,
	sum(WAK_e_m * quantity) / sum(quantity) AS WAK_e_m,
	sum(quantity) AS quantity,
	stddev(WAK_e_a) AS std_WAK_e_a,
	stddev(WAK_e_m) AS std_WAK_e_m
FROM WAK_pass_cargo_elev;
