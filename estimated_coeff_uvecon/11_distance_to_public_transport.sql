--------------------------------------------------------------------------------------------
--** Значення коефіцієнтів коригуванння середньої ціни за кв.м. житла відповідно до ... **--
--------------------------------------------------------------------------------------------
--* 11_відстані_до_зупинок_громадського_транспорту *--
--------------------------------------------------------------------------------------------


--------------------------------------
-- КИЇВ --
--------------------------------------
WITH poligons AS(
	SELECT
		id_sq AS pol_id,
		name_ua AS pol_name,
		center AS city
	FROM uvekon.re_poligons
	WHERE level = 4 AND center = 'Київ'
	),
	incorrect_coordinates AS (
	SELECT
		geom, city
	FROM uvekon.incorrect_coordinates_buffer
	WHERE city = 'Київ'
	),
	metro_250m AS (
    SELECT
        geom
    FROM uvekon.metro_buffer
    WHERE buffer_name = '250m'
	AND city = 'Київ'
    ),
    metro_500m AS (
    SELECT
        geom
    FROM uvekon.metro_buffer
    WHERE buffer_name = '500m'
	AND city = 'Київ'
    ),
    public_transport_100m AS (
    SELECT
        geom
    FROM uvekon.public_transport_buffer
    WHERE buffer_name = '100m'
	AND city = 'Київ'
    ),
    public_transport_200m AS (
    SELECT
        geom
    FROM uvekon.public_transport_buffer
    WHERE buffer_name = '200m'
	AND city = 'Київ'
    ),
	public_transport_adverts AS (
	SELECT
        advert.id_build_type_u,
		advert.id_poligon_level_4,
		advert.price_1sq_meter_usd,
        advert.geom,
        (
		CASE 
		WHEN (ST_Within(ST_Transform(advert.geom, 3857), pt100.geom) = true
		 	 AND ST_Within(ST_Transform(advert.geom, 3857), m500.geom) = false) THEN 3
		WHEN (ST_Within(ST_Transform(advert.geom, 3857), pt200.geom) = true
			 AND ST_Within(ST_Transform(advert.geom, 3857), m500.geom) = false) THEN 2
		WHEN (ST_Within(ST_Transform(advert.geom, 3857), pt200.geom) = false
			 AND ST_Within(ST_Transform(advert.geom, 3857), m500.geom) = false) THEN 1
		END
		) AS public_transport_id
	FROM 
		uvekon.re_advert advert, 
		public_transport_100m pt100, 
		public_transport_200m pt200, 
		metro_500m m500,
		incorrect_coordinates ic
	WHERE id_type_oper = 1 AND id_subsegment = 2
	AND id_build_type_u is not null
	AND price_1sq_meter_usd >= 400 AND price_1sq_meter_usd <= 5000
    AND id_poligon_level_4 IN (SELECT pol_id FROM poligons)
	AND date_relevance IN ('2018-06-30',
                           '2018-05-31',
						   '2018-04-30')
	AND ST_Within(ST_Transform(advert.geom, 3857), ic.geom) = false
    ),
    microdistrcts AS (
	SELECT 
		DISTINCT id_poligon_level_4,
		id_build_type_u,
		public_transport_id,
		concat(
			replace(to_char(id_poligon_level_4, '9999999999'), ' ', ''),
			replace(to_char(id_build_type_u, '99'), ' ', '')
		) AS hash,
		COUNT(*) AS count,
		AVG(price_1sq_meter_usd) AS avg, 
		median(price_1sq_meter_usd) AS median
	FROM public_transport_adverts
	GROUP BY id_poligon_level_4, id_build_type_u, public_transport_id
	ORDER BY public_transport_id
	),
    more_500m_to_public_transport AS ( -- більше 200м до зупинок
        SELECT
		id_build_type_u,
		id_poligon_level_4,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE public_transport_id = 1 AND count >= 5
    ),
    to_public_transport_200m AS ( -- 200м до зупинок
        SELECT
		id_build_type_u,
		id_poligon_level_4,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE public_transport_id IN (2, 3) AND count >= 3
    ),
    to_public_transport_100m AS ( -- 100м до зупинок
        SELECT
		id_build_type_u,
		id_poligon_level_4,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE public_transport_id = 3 AND count >= 3
    ),
    K_more_200m AS (
    SELECT
        DISTINCT e0.hash AS hash,
		e0.id_poligon_level_4 AS poligon,
		e0.id_build_type_u AS build_type,
		e0.count AS quantity,
		e0.avg / e0.avg AS K_e_a,
		e0.median / e0.median AS K_e_m
	FROM to_public_transport_200m e1, more_500m_to_public_transport e0
	WHERE e0.hash = e1.hash
	ORDER BY build_type
    ),
    K_200m_to_public_transport AS (
    SELECT
		DISTINCT e1.hash AS hash,
		e1.id_poligon_level_4 AS poligon,
		e1.id_build_type_u AS build_type,
		e1.count AS quantity,
		e1.avg / e0.avg AS K_e_a,
		e1.median / e0.median AS K_e_m
	FROM to_public_transport_200m e1, more_500m_to_public_transport e0
	WHERE e0.hash = e1.hash
	ORDER BY build_type
    ),
    K_100m_to_public_transport  AS (
    SELECT
		DISTINCT e2.hash AS hash,
		e2.id_poligon_level_4 AS poligon,
		e2.id_build_type_u AS build_type,
		e2.count AS quantity,
		e2.avg / e0.avg AS K_e_a,
		e2.median / e0.median AS K_e_m
	FROM to_public_transport_100m e2, more_500m_to_public_transport e0
	WHERE e0.hash = e2.hash
	ORDER BY build_type
    ),
    WAK_more_200m AS (
	SELECT
		DISTINCT poligon,
		sum(K_e_a * quantity) / sum(quantity) AS WAK_e_a,
		sum(K_e_m * quantity) / sum(quantity) AS WAK_e_m,
		sum(quantity) AS quantity
	FROM K_more_200m
	GROUP BY poligon
	),
    WAK_200m_to_public_transport AS (
	SELECT
		DISTINCT poligon,
		sum(K_e_a * quantity) / sum(quantity) AS WAK_e_a,
		sum(K_e_m * quantity) / sum(quantity) AS WAK_e_m,
		sum(quantity) AS quantity
	FROM K_200m_to_public_transport
	GROUP BY poligon
	),
    WAK_100m_to_public_transport AS (
	SELECT
		DISTINCT poligon,
		sum(K_e_a * quantity) / sum(quantity) AS WAK_e_a,
		sum(K_e_m * quantity) / sum(quantity) AS WAK_e_m,
		sum(quantity) AS quantity
	FROM K_100m_to_public_transport
	GROUP BY poligon
	)
SELECT
	'Понад 200м до зупинок' AS name,
	sum(WAK_e_a * quantity) / sum(quantity) AS WAK_e_a,
	sum(WAK_e_m * quantity) / sum(quantity) AS WAK_e_m,
	sum(quantity) AS quantity,
	stddev(WAK_e_a) AS std_WAK_e_a,
	stddev(WAK_e_m) AS std_WAK_e_m
FROM WAK_more_200m
UNION ALL
SELECT
	'до 200м до зупинок' AS name,
	sum(WAK_e_a * quantity) / sum(quantity) AS WAK_e_a,
	sum(WAK_e_m * quantity) / sum(quantity) AS WAK_e_m,
	sum(quantity) AS quantity,
	stddev(WAK_e_a) AS std_WAK_e_a,
	stddev(WAK_e_m) AS std_WAK_e_m
FROM WAK_200m_to_public_transport
UNION ALL
SELECT
	'до 100м до зупинок' AS name,
	sum(WAK_e_a * quantity) / sum(quantity) AS WAK_e_a,
	sum(WAK_e_m * quantity) / sum(quantity) AS WAK_e_m,
	sum(quantity) AS quantity,
	stddev(WAK_e_a) AS std_WAK_e_a,
	stddev(WAK_e_m) AS std_WAK_e_m
FROM WAK_100m_to_public_transport;



--------------------------------------
-- ХАРКІВ --
--------------------------------------
WITH poligons AS(
	SELECT
		id_sq AS pol_id,
		name_ua AS pol_name,
		center AS city
	FROM uvekon.re_poligons
	WHERE level = 4 AND center = 'Харків'
	),
	incorrect_coordinates AS (
	SELECT
		geom, city
	FROM uvekon.incorrect_coordinates_buffer
	WHERE city = 'Харків'
	),
	metro_250m AS (
    SELECT
        geom
    FROM uvekon.metro_buffer
    WHERE buffer_name = '250m'
	AND city = 'Харків'
    ),
    metro_500m AS (
    SELECT
        geom
    FROM uvekon.metro_buffer
    WHERE buffer_name = '500m'
	AND city = 'Харків'
    ),
    public_transport_100m AS (
    SELECT
        geom
    FROM uvekon.public_transport_buffer
    WHERE buffer_name = '100m'
	AND city = 'Харків'
    ),
    public_transport_200m AS (
    SELECT
        geom
    FROM uvekon.public_transport_buffer
    WHERE buffer_name = '200m'
	AND city = 'Харків'
    ),
	public_transport_adverts AS (
	SELECT
        advert.id_build_type_u,
		advert.id_poligon_level_4,
		advert.price_1sq_meter_usd,
        advert.geom,
        (
		CASE 
		WHEN (ST_Within(ST_Transform(advert.geom, 3857), pt100.geom) = true
		 	 AND ST_Within(ST_Transform(advert.geom, 3857), m500.geom) = false) THEN 3
		WHEN (ST_Within(ST_Transform(advert.geom, 3857), pt200.geom) = true
			 AND ST_Within(ST_Transform(advert.geom, 3857), m500.geom) = false) THEN 2
		WHEN (ST_Within(ST_Transform(advert.geom, 3857), pt200.geom) = false
			 AND ST_Within(ST_Transform(advert.geom, 3857), m500.geom) = false) THEN 1
		END
		) AS public_transport_id
	FROM 
		uvekon.re_advert advert, 
		public_transport_100m pt100, 
		public_transport_200m pt200, 
		metro_500m m500,
		incorrect_coordinates ic
	WHERE id_type_oper = 1 AND id_subsegment = 2
	AND id_build_type_u is not null
	AND price_1sq_meter_usd >= 200 AND price_1sq_meter_usd <= 4000
    AND id_poligon_level_4 IN (SELECT pol_id FROM poligons)
	AND date_relevance IN ('2018-06-30',
                           '2018-05-31',
						   '2018-04-30')
	AND ST_Within(ST_Transform(advert.geom, 3857), ic.geom) = false
    ),
    microdistrcts AS (
	SELECT 
		DISTINCT id_poligon_level_4,
		id_build_type_u,
		public_transport_id,
		concat(
			replace(to_char(id_poligon_level_4, '9999999999'), ' ', ''),
			replace(to_char(id_build_type_u, '99'), ' ', '')
		) AS hash,
		COUNT(*) AS count,
		AVG(price_1sq_meter_usd) AS avg, 
		median(price_1sq_meter_usd) AS median
	FROM public_transport_adverts
	GROUP BY id_poligon_level_4, id_build_type_u, public_transport_id
	ORDER BY public_transport_id
	),
    more_500m_to_public_transport AS ( -- більше 200м до зупинок
        SELECT
		id_build_type_u,
		id_poligon_level_4,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE public_transport_id = 1 AND count >= 5
    ),
    to_public_transport_200m AS ( -- 200м до зупинок
        SELECT
		id_build_type_u,
		id_poligon_level_4,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE public_transport_id IN (2, 3) AND count >= 3
    ),
    to_public_transport_100m AS ( -- 100м до зупинок
        SELECT
		id_build_type_u,
		id_poligon_level_4,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE public_transport_id = 3 AND count >= 3
    ),
    K_more_200m AS (
    SELECT
        DISTINCT e0.hash AS hash,
		e0.id_poligon_level_4 AS poligon,
		e0.id_build_type_u AS build_type,
		e0.count AS quantity,
		e0.avg / e0.avg AS K_e_a,
		e0.median / e0.median AS K_e_m
	FROM to_public_transport_200m e1, more_500m_to_public_transport e0
	WHERE e0.hash = e1.hash
	ORDER BY build_type
    ),
    K_200m_to_public_transport AS (
    SELECT
		DISTINCT e1.hash AS hash,
		e1.id_poligon_level_4 AS poligon,
		e1.id_build_type_u AS build_type,
		e1.count AS quantity,
		e1.avg / e0.avg AS K_e_a,
		e1.median / e0.median AS K_e_m
	FROM to_public_transport_200m e1, more_500m_to_public_transport e0
	WHERE e0.hash = e1.hash
	ORDER BY build_type
    ),
    K_100m_to_public_transport  AS (
    SELECT
		DISTINCT e2.hash AS hash,
		e2.id_poligon_level_4 AS poligon,
		e2.id_build_type_u AS build_type,
		e2.count AS quantity,
		e2.avg / e0.avg AS K_e_a,
		e2.median / e0.median AS K_e_m
	FROM to_public_transport_100m e2, more_500m_to_public_transport e0
	WHERE e0.hash = e2.hash
	ORDER BY build_type
    ),
    WAK_more_200m AS (
	SELECT
		DISTINCT poligon,
		sum(K_e_a * quantity) / sum(quantity) AS WAK_e_a,
		sum(K_e_m * quantity) / sum(quantity) AS WAK_e_m,
		sum(quantity) AS quantity
	FROM K_more_200m
	GROUP BY poligon
	),
    WAK_200m_to_public_transport AS (
	SELECT
		DISTINCT poligon,
		sum(K_e_a * quantity) / sum(quantity) AS WAK_e_a,
		sum(K_e_m * quantity) / sum(quantity) AS WAK_e_m,
		sum(quantity) AS quantity
	FROM K_200m_to_public_transport
	GROUP BY poligon
	),
    WAK_100m_to_public_transport AS (
	SELECT
		DISTINCT poligon,
		sum(K_e_a * quantity) / sum(quantity) AS WAK_e_a,
		sum(K_e_m * quantity) / sum(quantity) AS WAK_e_m,
		sum(quantity) AS quantity
	FROM K_100m_to_public_transport
	GROUP BY poligon
	)
SELECT
	'Понад 200м до зупинок' AS name,
	sum(WAK_e_a * quantity) / sum(quantity) AS WAK_e_a,
	sum(WAK_e_m * quantity) / sum(quantity) AS WAK_e_m,
	sum(quantity) AS quantity,
	stddev(WAK_e_a) AS std_WAK_e_a,
	stddev(WAK_e_m) AS std_WAK_e_m
FROM WAK_more_200m
UNION ALL
SELECT
	'до 200м до зупинок' AS name,
	sum(WAK_e_a * quantity) / sum(quantity) AS WAK_e_a,
	sum(WAK_e_m * quantity) / sum(quantity) AS WAK_e_m,
	sum(quantity) AS quantity,
	stddev(WAK_e_a) AS std_WAK_e_a,
	stddev(WAK_e_m) AS std_WAK_e_m
FROM WAK_200m_to_public_transport
UNION ALL
SELECT
	'до 100м до зупинок' AS name,
	sum(WAK_e_a * quantity) / sum(quantity) AS WAK_e_a,
	sum(WAK_e_m * quantity) / sum(quantity) AS WAK_e_m,
	sum(quantity) AS quantity,
	stddev(WAK_e_a) AS std_WAK_e_a,
	stddev(WAK_e_m) AS std_WAK_e_m
FROM WAK_100m_to_public_transport;

--------------------------------------
-- КИЇВ -- по адмінрайонах
--------------------------------------
WITH poligons AS(
	SELECT
		id_sq AS pol_id,
		name_ua AS pol_name,
		center AS city
	FROM uvekon.re_poligons
	WHERE level = 2 AND center = 'Київ'
	),
	incorrect_coordinates AS (
	SELECT
		geom, city
	FROM uvekon.incorrect_coordinates_buffer
	WHERE city = 'Київ'
	),
	metro_250m AS (
    SELECT
        geom
    FROM uvekon.metro_buffer
    WHERE buffer_name = '250m'
	AND city = 'Київ'
    ),
    metro_500m AS (
    SELECT
        geom
    FROM uvekon.metro_buffer
    WHERE buffer_name = '500m'
	AND city = 'Київ'
    ),
    public_transport_100m AS (
    SELECT
        geom
    FROM uvekon.public_transport_buffer
    WHERE buffer_name = '100m'
	AND city = 'Київ'
    ),
    public_transport_200m AS (
    SELECT
        geom
    FROM uvekon.public_transport_buffer
    WHERE buffer_name = '200m'
	AND city = 'Київ'
    ),
	public_transport_adverts AS (
	SELECT
        advert.id_build_type_u,
		advert.id_poligon_level_2,
		advert.price_1sq_meter_usd,
        advert.geom,
        (
		CASE 
		WHEN (ST_Within(ST_Transform(advert.geom, 3857), pt100.geom) = true
		 	 AND ST_Within(ST_Transform(advert.geom, 3857), m500.geom) = false) THEN 3
		WHEN (ST_Within(ST_Transform(advert.geom, 3857), pt200.geom) = true
			 AND ST_Within(ST_Transform(advert.geom, 3857), m500.geom) = false) THEN 2
		WHEN (ST_Within(ST_Transform(advert.geom, 3857), pt200.geom) = false
			 AND ST_Within(ST_Transform(advert.geom, 3857), m500.geom) = false) THEN 1
		END
		) AS public_transport_id
	FROM 
		uvekon.re_advert advert, 
		public_transport_100m pt100, 
		public_transport_200m pt200, 
		metro_500m m500,
		incorrect_coordinates ic
	WHERE id_type_oper = 1 AND id_subsegment = 2
	AND id_build_type_u is not null
	AND price_1sq_meter_usd >= 400 AND price_1sq_meter_usd <= 5000
    AND id_poligon_level_2 IN (SELECT pol_id FROM poligons)
	AND date_relevance IN ('2018-06-30',
                           '2018-05-31',
						   '2018-04-30')
	AND ST_Within(ST_Transform(advert.geom, 3857), ic.geom) = false
    ),
    microdistrcts AS (
	SELECT 
		DISTINCT id_poligon_level_2,
		id_build_type_u,
		public_transport_id,
		concat(
			replace(to_char(id_poligon_level_2, '9999999999'), ' ', ''),
			replace(to_char(id_build_type_u, '99'), ' ', '')
		) AS hash,
		COUNT(*) AS count,
		AVG(price_1sq_meter_usd) AS avg, 
		median(price_1sq_meter_usd) AS median
	FROM public_transport_adverts
	GROUP BY id_poligon_level_2, id_build_type_u, public_transport_id
	ORDER BY public_transport_id
	),
    more_500m_to_public_transport AS ( -- більше 200м до зупинок
        SELECT
		id_build_type_u,
		id_poligon_level_2,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE public_transport_id = 1 AND count >= 5
    ),
    to_public_transport_200m AS ( -- 200м до зупинок
        SELECT
		id_build_type_u,
		id_poligon_level_2,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE public_transport_id IN (2, 3) AND count >= 3
    ),
    to_public_transport_100m AS ( -- 100м до зупинок
        SELECT
		id_build_type_u,
		id_poligon_level_2,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE public_transport_id = 3 AND count >= 3
    ),
    K_more_200m AS (
    SELECT
        DISTINCT e0.hash AS hash,
		e0.id_poligon_level_2 AS poligon,
		e0.id_build_type_u AS build_type,
		e0.count AS quantity,
		e0.avg / e0.avg AS K_e_a,
		e0.median / e0.median AS K_e_m
	FROM to_public_transport_200m e1, more_500m_to_public_transport e0
	WHERE e0.hash = e1.hash
	ORDER BY build_type
    ),
    K_200m_to_public_transport AS (
    SELECT
		DISTINCT e1.hash AS hash,
		e1.id_poligon_level_2 AS poligon,
		e1.id_build_type_u AS build_type,
		e1.count AS quantity,
		e1.avg / e0.avg AS K_e_a,
		e1.median / e0.median AS K_e_m
	FROM to_public_transport_200m e1, more_500m_to_public_transport e0
	WHERE e0.hash = e1.hash
	ORDER BY build_type
    ),
    K_100m_to_public_transport  AS (
    SELECT
		DISTINCT e2.hash AS hash,
		e2.id_poligon_level_2 AS poligon,
		e2.id_build_type_u AS build_type,
		e2.count AS quantity,
		e2.avg / e0.avg AS K_e_a,
		e2.median / e0.median AS K_e_m
	FROM to_public_transport_100m e2, more_500m_to_public_transport e0
	WHERE e0.hash = e2.hash
	ORDER BY build_type
    ),
    WAK_more_200m AS (
	SELECT
		DISTINCT poligon,
		sum(K_e_a * quantity) / sum(quantity) AS WAK_e_a,
		sum(K_e_m * quantity) / sum(quantity) AS WAK_e_m,
		sum(quantity) AS quantity
	FROM K_more_200m
	GROUP BY poligon
	),
    WAK_200m_to_public_transport AS (
	SELECT
		DISTINCT poligon,
		sum(K_e_a * quantity) / sum(quantity) AS WAK_e_a,
		sum(K_e_m * quantity) / sum(quantity) AS WAK_e_m,
		sum(quantity) AS quantity
	FROM K_200m_to_public_transport
	GROUP BY poligon
	),
    WAK_100m_to_public_transport AS (
	SELECT
		DISTINCT poligon,
		sum(K_e_a * quantity) / sum(quantity) AS WAK_e_a,
		sum(K_e_m * quantity) / sum(quantity) AS WAK_e_m,
		sum(quantity) AS quantity
	FROM K_100m_to_public_transport
	GROUP BY poligon
	)
SELECT
	'Понад 200м до зупинок' AS name,
	sum(WAK_e_a * quantity) / sum(quantity) AS WAK_e_a,
	sum(WAK_e_m * quantity) / sum(quantity) AS WAK_e_m,
	sum(quantity) AS quantity,
	stddev(WAK_e_a) AS std_WAK_e_a,
	stddev(WAK_e_m) AS std_WAK_e_m
FROM WAK_more_200m
UNION ALL
SELECT
	'до 200м до зупинок' AS name,
	sum(WAK_e_a * quantity) / sum(quantity) AS WAK_e_a,
	sum(WAK_e_m * quantity) / sum(quantity) AS WAK_e_m,
	sum(quantity) AS quantity,
	stddev(WAK_e_a) AS std_WAK_e_a,
	stddev(WAK_e_m) AS std_WAK_e_m
FROM WAK_200m_to_public_transport
UNION ALL
SELECT
	'до 100м до зупинок' AS name,
	sum(WAK_e_a * quantity) / sum(quantity) AS WAK_e_a,
	sum(WAK_e_m * quantity) / sum(quantity) AS WAK_e_m,
	sum(quantity) AS quantity,
	stddev(WAK_e_a) AS std_WAK_e_a,
	stddev(WAK_e_m) AS std_WAK_e_m
FROM WAK_100m_to_public_transport;


--------------------------------------
-- ХАРКІВ -- по адмінрайонах
--------------------------------------
WITH poligons AS(
	SELECT
		id_sq AS pol_id,
		name_ua AS pol_name,
		center AS city
	FROM uvekon.re_poligons
	WHERE level = 3 AND center = 'Харків'
	),
	incorrect_coordinates AS (
	SELECT
		geom, city
	FROM uvekon.incorrect_coordinates_buffer
	WHERE city = 'Харків'
	),
	metro_250m AS (
    SELECT
        geom
    FROM uvekon.metro_buffer
    WHERE buffer_name = '250m'
	AND city = 'Харків'
    ),
    metro_500m AS (
    SELECT
        geom
    FROM uvekon.metro_buffer
    WHERE buffer_name = '500m'
	AND city = 'Харків'
    ),
    public_transport_100m AS (
    SELECT
        geom
    FROM uvekon.public_transport_buffer
    WHERE buffer_name = '100m'
	AND city = 'Харків'
    ),
    public_transport_200m AS (
    SELECT
        geom
    FROM uvekon.public_transport_buffer
    WHERE buffer_name = '200m'
	AND city = 'Харків'
    ),
	public_transport_adverts AS (
	SELECT
        advert.id_build_type_u,
		advert.id_poligon_level_3,
		advert.price_1sq_meter_usd,
        advert.geom,
        (
		CASE 
		WHEN (ST_Within(ST_Transform(advert.geom, 3857), pt100.geom) = true
		 	 AND ST_Within(ST_Transform(advert.geom, 3857), m500.geom) = false) THEN 3
		WHEN (ST_Within(ST_Transform(advert.geom, 3857), pt200.geom) = true
			 AND ST_Within(ST_Transform(advert.geom, 3857), m500.geom) = false) THEN 2
		WHEN (ST_Within(ST_Transform(advert.geom, 3857), pt200.geom) = false
			 AND ST_Within(ST_Transform(advert.geom, 3857), m500.geom) = false) THEN 1
		END
		) AS public_transport_id
	FROM 
		uvekon.re_advert advert, 
		public_transport_100m pt100, 
		public_transport_200m pt200, 
		metro_500m m500,
		incorrect_coordinates ic
	WHERE id_type_oper = 1 AND id_subsegment = 2
	AND id_build_type_u is not null
	AND price_1sq_meter_usd >= 200 AND price_1sq_meter_usd <= 4000
    AND id_poligon_level_3 IN (SELECT pol_id FROM poligons)
	AND date_relevance IN ('2018-06-30',
                           '2018-05-31',
						   '2018-04-30')
	AND ST_Within(ST_Transform(advert.geom, 3857), ic.geom) = false
    ),
    microdistrcts AS (
	SELECT 
		DISTINCT id_poligon_level_3,
		id_build_type_u,
		public_transport_id,
		concat(
			replace(to_char(id_poligon_level_3, '9999999999'), ' ', ''),
			replace(to_char(id_build_type_u, '99'), ' ', '')
		) AS hash,
		COUNT(*) AS count,
		AVG(price_1sq_meter_usd) AS avg, 
		median(price_1sq_meter_usd) AS median
	FROM public_transport_adverts
	GROUP BY id_poligon_level_3, id_build_type_u, public_transport_id
	ORDER BY public_transport_id
	),
    more_500m_to_public_transport AS ( -- більше 200м до зупинок
        SELECT
		id_build_type_u,
		id_poligon_level_3,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE public_transport_id = 1 AND count >= 5
    ),
    to_public_transport_200m AS ( -- 200м до зупинок
        SELECT
		id_build_type_u,
		id_poligon_level_3,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE public_transport_id IN (2, 3) AND count >= 3
    ),
    to_public_transport_100m AS ( -- 100м до зупинок
        SELECT
		id_build_type_u,
		id_poligon_level_3,
		hash,
		count, avg, median
	FROM microdistrcts
	WHERE public_transport_id = 3 AND count >= 3
    ),
    K_more_200m AS (
    SELECT
        DISTINCT e0.hash AS hash,
		e0.id_poligon_level_3 AS poligon,
		e0.id_build_type_u AS build_type,
		e0.count AS quantity,
		e0.avg / e0.avg AS K_e_a,
		e0.median / e0.median AS K_e_m
	FROM to_public_transport_200m e1, more_500m_to_public_transport e0
	WHERE e0.hash = e1.hash
	ORDER BY build_type
    ),
    K_200m_to_public_transport AS (
    SELECT
		DISTINCT e1.hash AS hash,
		e1.id_poligon_level_3 AS poligon,
		e1.id_build_type_u AS build_type,
		e1.count AS quantity,
		e1.avg / e0.avg AS K_e_a,
		e1.median / e0.median AS K_e_m
	FROM to_public_transport_200m e1, more_500m_to_public_transport e0
	WHERE e0.hash = e1.hash
	ORDER BY build_type
    ),
    K_100m_to_public_transport  AS (
    SELECT
		DISTINCT e2.hash AS hash,
		e2.id_poligon_level_3 AS poligon,
		e2.id_build_type_u AS build_type,
		e2.count AS quantity,
		e2.avg / e0.avg AS K_e_a,
		e2.median / e0.median AS K_e_m
	FROM to_public_transport_100m e2, more_500m_to_public_transport e0
	WHERE e0.hash = e2.hash
	ORDER BY build_type
    ),
    WAK_more_200m AS (
	SELECT
		DISTINCT poligon,
		sum(K_e_a * quantity) / sum(quantity) AS WAK_e_a,
		sum(K_e_m * quantity) / sum(quantity) AS WAK_e_m,
		sum(quantity) AS quantity
	FROM K_more_200m
	GROUP BY poligon
	),
    WAK_200m_to_public_transport AS (
	SELECT
		DISTINCT poligon,
		sum(K_e_a * quantity) / sum(quantity) AS WAK_e_a,
		sum(K_e_m * quantity) / sum(quantity) AS WAK_e_m,
		sum(quantity) AS quantity
	FROM K_200m_to_public_transport
	GROUP BY poligon
	),
    WAK_100m_to_public_transport AS (
	SELECT
		DISTINCT poligon,
		sum(K_e_a * quantity) / sum(quantity) AS WAK_e_a,
		sum(K_e_m * quantity) / sum(quantity) AS WAK_e_m,
		sum(quantity) AS quantity
	FROM K_100m_to_public_transport
	GROUP BY poligon
	)
SELECT
	'Понад 200м до зупинок' AS name,
	sum(WAK_e_a * quantity) / sum(quantity) AS WAK_e_a,
	sum(WAK_e_m * quantity) / sum(quantity) AS WAK_e_m,
	sum(quantity) AS quantity,
	stddev(WAK_e_a) AS std_WAK_e_a,
	stddev(WAK_e_m) AS std_WAK_e_m
FROM WAK_more_200m
UNION ALL
SELECT
	'до 200м до зупинок' AS name,
	sum(WAK_e_a * quantity) / sum(quantity) AS WAK_e_a,
	sum(WAK_e_m * quantity) / sum(quantity) AS WAK_e_m,
	sum(quantity) AS quantity,
	stddev(WAK_e_a) AS std_WAK_e_a,
	stddev(WAK_e_m) AS std_WAK_e_m
FROM WAK_200m_to_public_transport
UNION ALL
SELECT
	'до 100м до зупинок' AS name,
	sum(WAK_e_a * quantity) / sum(quantity) AS WAK_e_a,
	sum(WAK_e_m * quantity) / sum(quantity) AS WAK_e_m,
	sum(quantity) AS quantity,
	stddev(WAK_e_a) AS std_WAK_e_a,
	stddev(WAK_e_m) AS std_WAK_e_m
FROM WAK_100m_to_public_transport;
