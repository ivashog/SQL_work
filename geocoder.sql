-- Основа - модуль HTTP для Postgres https://github.com/pramsey/pgsql-http
--------------------------------------------------------------------------

-- функция адрес в геометрию Google
CREATE OR REPLACE FUNCTION address_to_geom(text)
RETURNS geometry
AS
$$
WITH http AS (
  SELECT status, content_type, content::json
  FROM http_get('https://maps.googleapis.com/maps/api/geocode/json?language=uk&address' || replace($1, ' ', '+'))
),
parts AS (
  SELECT
    status, content_type,
    content::json#>>'{results, 0, geometry, location, lat}' AS lat,
    content::json#>>'{results, 0, geometry, location, lng}' AS lng
  FROM http
)
SELECT
  ST_SetSRID(ST_MakePoint(lng::text::float8, lat::text::float8),4326) AS geom
FROM parts

$$
LANGUAGE 'sql';

-- функция адрес в геометрию Yandex
CREATE OR REPLACE FUNCTION address_to_geom_yandex(text)
RETURNS geometry
AS
$$
WITH http AS (
  SELECT status, content_type, content::json
  FROM http_get('https://geocode-maps.yandex.ru/1.x/?format=json&lang=uk_UA&results=2&geocode=' || replace($1, ' ', '+'))
),
parts AS (
  SELECT
    status, content_type,
    split_part((content::json#>>'{response, GeoObjectCollection, featureMember, 0, GeoObject, Point, pos}'), ' ', 2) AS lat,
    split_part((content::json#>>'{response, GeoObjectCollection, featureMember, 0, GeoObject, Point, pos}'), ' ', 1) AS lng
  FROM http
)
SELECT
  ST_SetSRID(ST_MakePoint(lng::text::float8, lat::text::float8),4326) AS geom
FROM parts

$$
LANGUAGE 'sql';

-- адрес в координаты json Google
WITH http AS (
  SELECT status, content_type, content::json
  FROM http_get('https://maps.googleapis.com/maps/api/geocode/json?language=uk&address=Київ+Половецька+25-27')
)
SELECT
	status, content_type,
    content::json#>>'{results, 0, formatted_address}' AS formatted_address,
	  content::json#>>'{results, 0, geometry, location, lat}' AS lat,
    content::json#>>'{results, 0, geometry, location, lng}' AS lng
FROM http

-- адрес в координаты json Yandex
WITH http AS (
  SELECT status, content_type, content::json
  FROM http_get('https://geocode-maps.yandex.ru/1.x/?format=json&lang=uk_UA&results=2&geocode=Київ+Половецька+25-27')
)
SELECT
	status, content_type,
    content::json#>>'{response, GeoObjectCollection, featureMember, 0, GeoObject, metaDataProperty, GeocoderMetaData, Address, formatted}' AS formatted_address,
	  split_part((content::json#>>'{response, GeoObjectCollection, featureMember, 0, GeoObject, Point, pos}'), ' ', 2) AS lat,
    split_part((content::json#>>'{response, GeoObjectCollection, featureMember, 0, GeoObject, Point, pos}'), ' ', 1) AS lng
FROM http



-----------
WITH geom AS (
	SELECT 
		koatuu_code AS koatuu,
		address_to_geom(replace(concat('https://maps.googleapis.com/maps/api/geocode/json?language=uk&address=', k.region_name, ', ', k.district_name, ', ', k.name), ' ', '+')) AS geom 
	FROM uvekon.v_re_dic_koatuu k
	WHERE coordinate_n is null AND locality_form in ( 1, 2, 3, 4 )
	AND (locality_status is null OR locality_status not in ( 1, 3, 5, 6 ))
)
UPDATE uvekon.re_dic_koatuu
SET coordinate_n = ST_Y(SELECT geom FROM geom),
	coordinate_e = ST_X(SELECT geom FROM geom)
WHERE koatuu_code = (SELECT koatuu FROM geom)
AND coordinate_n is null AND locality_form in ( 1, 2, 3, 4 ) 
AND (locality_status is null OR locality_status not in ( 1, 3, 5, 6 ));

WITH geom AS (
	SELECT address_to_geom(replace(concat('https://maps.googleapis.com/maps/api/geocode/json?language=uk&address=', k.region_name, ', ', k.district_name, ', ', k.name), ' ', '+')) AS geom 
	FROM uvekon.v_re_dic_koatuu k
	WHERE coordinate_n is null AND locality_form in ( 1, 2, 3, 4 )
	AND (locality_status is null OR locality_status not in ( 1, 3, 5, 6 ))
)
SELECT
	ST_Y(geom) AS coordinate_n,
	ST_X(geom) AS coordinate_e 
FROM geom
LIMIT 10;

----- Геокодирование справочника КОАТУУ -----
UPDATE uvekon.re_dic_koatuu u
SET geom =(
SELECT 
	address_to_geom(replace(concat('https://maps.googleapis.com/maps/api/geocode/json?language=uk&address=', k.region_name, ', ', k.district_name, ', ', k.name), ' ', '+'))
FROM uvekon.v_re_dic_koatuu k
WHERE u.koatuu_code = k.koatuu_code
	AND coordinate_n is null AND locality_form in ( 1, 2, 3, 4 )
	AND (locality_status is null OR locality_status not in ( 1, 3, 5, 6 ))
) 
WHERE coordinate_n is null AND locality_form in ( 1, 2, 3, 4 ) 
AND (locality_status is null OR locality_status not in ( 1, 3, 5, 6 ))
AND geom is null;

--
UPDATE uvekon.re_dic_koatuu u
SET geom =(
SELECT 
	address_to_geom_yandex(replace(concat(k.region_name, ', ', k.name), ' ', '+'))
FROM uvekon.v_re_dic_koatuu k
WHERE u.koatuu_code = k.koatuu_code
	AND coordinate_n is null AND locality_form in ( 1, 2, 3, 4 )
	AND (locality_status is null OR locality_status in ( 1, 3, 5, 6 ))
) 
WHERE coordinate_n is null AND locality_form in ( 1, 2, 3, 4 ) 
AND (locality_status is null OR locality_status in ( 1, 3, 5, 6 ))
AND geom is null;
--

UPDATE uvekon.re_dic_koatuu
SET coordinate_n = ST_Y(geom),
	coordinate_e = ST_X(geom)
WHERE geom is not null
AND coordinate_n is null;

UPDATE uvekon.re_dic_koatuu
SET geom = ST_SetSRID(ST_MakePoint(cast(coordinate_e AS double precision), cast(coordinate_n AS double precision)), 4326) 
WHERE coordinate_e <> '' AND coordinate_e <> 0 AND coordinate_e is not null AND geom is null;




