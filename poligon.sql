-- Простановка полигонов. Полигоны первого уровня
UPDATE uvekon.re_advert a 
SET id_poligon_level_1 = 
    (SELECT p.id_sq
    FROM uvekon.re_poligons p
    WHERE p.level=1
            AND rpad(substring(a.koatuu_code
    FROM 1 for 2), length(a.koatuu_code), '0') =p.koatuu )
WHERE koatuu_code <> ''
        AND id_poligon_level_1 is null
        AND date_relevance = 
    (SELECT date_relevance
    FROM uvekon.re_aggregate_period
    WHERE type_period=1
            AND is_work); 
-- полигоны второго уровня по koatuu
UPDATE uvekon.re_advert a 
SET id_poligon_level_2 = 
    (SELECT p.id_sq
    FROM uvekon.re_poligons p
    WHERE p.level=2
            AND rpad(substring(a.koatuu_code
    FROM 1 for 5), length(a.koatuu_code), '0') =p.koatuu )
WHERE koatuu_code <> ''
        AND koatuu_code IN 
    (SELECT koatuu
    FROM uvekon.re_poligons p
    WHERE p.level=2
            AND koatuu <> ''
    GROUP BY  koatuu
    HAVING count(1) =1 )
        AND id_poligon_level_2 is null
        AND date_relevance = 
    (SELECT date_relevance
    FROM uvekon.re_aggregate_period
    WHERE type_period=1
            AND is_work);
-- Простановка полигонов. Полигоны третьего уровня по koatuu
UPDATE uvekon.re_advert a 
SET id_poligon_level_3 = 
    (SELECT p.id_sq
    FROM uvekon.re_poligons p
    WHERE p.level=3
            AND a.koatuu_code =p.koatuu )
WHERE koatuu_code <> ''
        AND koatuu_code IN 
    (SELECT koatuu
    FROM uvekon.re_poligons p
    WHERE p.level=3
            AND koatuu <> ''
    GROUP BY  koatuu
    HAVING count(1) =1 )
        AND id_poligon_level_3 is null
        AND date_relevance = 
    (SELECT date_relevance
    FROM uvekon.re_aggregate_period
    WHERE type_period=1
            AND is_work);
-- Простановка полигонов. Полигоны второго уровня по полигону первого уровня и координатам
UPDATE
  uvekon.re_advert a
SET
  id_poligon_level_2 = (
    SELECT
      p.id_sq
    FROM
      uvekon.re_poligons p
    WHERE
      p.id_region = a.id_poligon_level_1
      AND level = 2
      AND ST_Within(ST_Transform(a.geom, 3857), p.geom) = true
  )
WHERE
  koatuu_code <> ''
  AND geom is NOT null
  AND id_poligon_level_2 is null
  AND id_poligon_level_1 is NOT null
  AND date_relevance = (
    SELECT
      date_relevance
    FROM
      uvekon.re_aggregate_period
    WHERE
      type_period = 1
      AND is_work
  );
-- Простановка полигонов. Полигоны третьего уровня по полигону второго уровня и координатам
UPDATE
  uvekon.re_advert a
SET
  id_poligon_level_3 = (
    SELECT
      min(p.id_sq)
    FROM
      uvekon.re_poligons p
    WHERE
      p.parent_id = a.id_poligon_level_2
      AND level = 3
      AND ST_Within(ST_Transform(a.geom, 3857), p.geom) = true
  )
WHERE
  koatuu_code <> ''
  AND geom is NOT null
  AND id_poligon_level_3 is null
  AND id_poligon_level_2 is NOT null
  AND date_relevance = (
    SELECT
      date_relevance
    FROM
      uvekon.re_aggregate_period
    WHERE
      type_period = 1
      AND is_work
  );
-- Простановка полигонов. Полигоны четвертого уровня по полигону третьего уровня и координатам
UPDATE
  uvekon.re_advert a
SET
  id_poligon_level_4 = (
    SELECT
      min(p.id_sq)
    FROM
      uvekon.re_poligons p
    WHERE
      p.parent_id = a.id_poligon_level_3
      AND level = 4
      AND ST_Within(ST_Transform(a.geom, 3857), p.geom) = true
  )
WHERE
  koatuu_code <> ''
  AND geom is NOT null
  AND id_poligon_level_4 is null
  AND id_poligon_level_3 is NOT null
  AND date_relevance = (
    SELECT
      date_relevance
    FROM
      uvekon.re_aggregate_period
    WHERE
      type_period = 1
      AND is_work
  );
