-- Создание накопительной таблицы типов домов uvekon.re_dic_building_type_accumul (id_build_type_a, name, id_agency, id_build_type_u, date_insert, note) 

CREATE TABLE uvekon.re_dic_building_type_accumul
(
    id_build_type_a integer NOT NULL,
    name character varying(100) NOT NULL,
    id_agency integer NOT NULL,
    id_build_type_u integer,
    date_insert timestamp without time zone DEFAULT now(),
    note character varying(2000),
    PRIMARY KEY (id_build_type_a)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE uvekon.re_dic_building_type_accumul
    OWNER to postgres;
COMMENT ON TABLE uvekon.re_dic_building_type_accumul
    IS 'Накопительная таблица типов домов (втор. рынок, ОЛХ и ЛУН)';

-- Создание увеконовской агрегированой(сводной) таблицы типов домов uvekon.re_dic_building_type_uvecon (id_build_type_u, name, note)

CREATE TABLE uvekon.re_dic_building_type_uvecon
(
    id_build_type_u integer NOT NULL,
    name character varying(100) NOT NULL,
    note character varying(2000),
    PRIMARY KEY (id_build_type_u)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE uvekon.re_dic_building_type_uvecon
    OWNER to postgres;
COMMENT ON TABLE uvekon.re_dic_building_type_uvecon
    IS 'Сводная (агрегированная) таблица типов домов "УВЕКОН"';
----------------------------------------------------------------	
-- Заполнени накопительной таблицы типов домов с ЛУНа

INSERT INTO uvekon.re_dic_building_type_accumul (name,id_agency)
SELECT type_obj, 1
FROM (
  SELECT DISTINCT type_obj
  FROM uvekon.re_advert_load
  WHERE id_segment = 1 
  AND id_subsegment = 2
  AND agency = 'LUN' 
  AND type_obj IS NOT NULL 
  AND type_obj <> ''
) g
WHERE (type_obj) NOT IN (
  SELECT name
  FROM uvekon.re_dic_building_type_accumul
  WHERE id_agency = 1
);

-- Заполнение накопительной таблицы типов домов с OLXa

INSERT INTO uvekon.re_dic_building_type_accumul (name,id_agency)
SELECT type_obj, 2
FROM (
  SELECT DISTINCT type_obj
  FROM uvekon.re_advert_load
  WHERE id_segment = 1 
  AND id_subsegment = 2
  AND agency = 'OLX' 
  AND type_obj IS NOT NULL 
  AND type_obj <> ''
) g
WHERE (type_obj) NOT IN (
  SELECT name
  FROM uvekon.re_dic_building_type_accumul
  WHERE id_agency = 2
);
---------------------------------------------------------------

-- Присвоение "увеконовского" id_build_type_u в накопительной табле типов домов - установление соответсвий
UPDATE uvekon.re_dic_building_type_accumul
SET id_build_type_u = 
(CASE
  WHEN name in ('дореволюційний', 'бельгійський проект', 'Царський будинок') THEN 1
  WHEN name in ('сталінка', 'Сталінка') THEN 2
  WHEN name in ('хрущовка', 'серія 468', 'серія 464', 'серія 215', 'Хрущовка') THEN 3
  WHEN name in ('чеський проект', 'Чешка') THEN 4
  WHEN name in ('гостинка', 'Гостинка', 'Гуртожиток') THEN 5
  WHEN name in ('радмін', 'Совмін') THEN 6
  WHEN name in ('БПС', 'серія 134', 'серія 87', 'серія 96', 'Житловий фонд 80-90-і') THEN 7
  WHEN name in ('АППС', 'серія ЕС', 'серія КП', 'серія КС', 'серія КТ', 'серія Т', 'Житловий фонд 91-2000-і') THEN 8
  WHEN name in ('АППС-люкс', 'КТУ', 'Житловий фонд 2001-2010-і') THEN 9
  WHEN name in ('спец. проект', 'Житловий фонд від 2011 р.', 'На етапі будівництва') THEN 10
ELSE null END);

------------------------------------------------------------------
-- Простановка "увеконовских" кодов типов домов  в объявления. LUN
UPDATE uvekon.re_advert_load l
SET id_build_type_u = (
  SELECT id_build_type_u
  FROM uvekon.re_dic_building_type_accumul b
  WHERE b.id_agency = 1
  AND b.name = l.type_obj
)
WHERE agency = 'LUN'
AND id_segment = 1 
AND id_subsegment = 2
AND type_obj <> ''
AND type_obj IS NOT NULL;

-- Перенос спецпроектов до 2011 года посройки в категорию 9 - "Забудова з 2001 по 2010 рр."
UPDATE uvekon.re_advert_load
SET id_build_type_u = 9
WHERE agency = 'LUN'
AND id_segment = 1 
AND id_subsegment = 2
AND type_obj = 'спец. проект'
AND year_building NOT IN ('2011', '2012', '2013', '2014', '2015', '2016', '2017', '2018', '2019', 'новобудова');

-- Простановка "увеконовских" кодов типов домов  в объявления. OLX
UPDATE uvekon.re_advert_load l
SET id_build_type_u = (
  SELECT id_build_type_u
  FROM uvekon.re_dic_building_type_accumul b
  WHERE b.id_agency = 2
  AND b.name = l.type_obj
)
WHERE agency = 'OLX'
AND id_segment = 1 
AND id_subsegment = 2
AND type_obj <> ''
AND type_obj IS NOT NULL ;
----------------------------------------------------------------

-- выборка ср. цены по типу домов - Киев
SELECT id_build_type_u, COUNT(*), AVG(price_1sq_meter_usd) FROM uvekon.re_advert_load
WHERE id_build_type_u is not null
AND status = 1 AND id_type_oper = 1 AND id_subsegment = 2 AND id_region = '80'
GROUP BY id_build_type_u
ORDER BY id_build_type_u

