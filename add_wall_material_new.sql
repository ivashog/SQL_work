-- Создание увеконовской агрегированой(сводной) таблицы типов материалов стен uvekon.re_dic_wall_material_uvecon (id_wall_material_u, name, note)
CREATE TABLE uvekon.re_dic_wall_material_uvecon
(
    id_wall_material_u integer NOT NULL,
    name character varying(100) NOT NULL,
    note character varying(2000),
    PRIMARY KEY (id_wall_material_u)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE uvekon.re_dic_wall_material_uvecon
    OWNER to postgres;
COMMENT ON TABLE uvekon.re_dic_wall_material_uvecon
    IS 'Агрегированнная (сводная) таблицы типов материалов стен "УВЕКОН"';
	
-- Заполнение накопительной таблицы типов материалов стен uvekon.re_dic_wall_material_accumul (id_wall_material, name, id_agency, id_wall_material_u, date_insert, source, note) 
-- Заполнение накопительной таблицы типов материалов стен с OLXa
INSERT INTO uvekon.re_dic_wall_material_accumul (name,id_agency,source)
SELECT wall_material, 2, 'olx.ua'
FROM (
  SELECT DISTINCT wall_material
  FROM uvekon.re_advert_load
  WHERE id_segment = 1 
  AND agency = 'OLX' 
  AND wall_material IS NOT NULL 
  AND wall_material <> ''
) g
WHERE (wall_material) NOT IN (
  SELECT name
  FROM uvekon.re_dic_wall_material_accumul
  WHERE id_agency = 2
);
-- Заполнение накопительной таблицы типов материалов стен с LUNa
INSERT INTO uvekon.re_dic_wall_material_accumul (name,id_agency,source)
SELECT wall_material, 1, 'lun.ua'
FROM (
  SELECT DISTINCT wall_material
  FROM uvekon.re_advert_load
  WHERE id_segment = 1 
  AND agency = 'LUN' 
  AND advert_url not like 'https://novostroyki.lun.ua/%'
  AND wall_material IS NOT NULL 
  AND wall_material <> ''
) g
WHERE (wall_material) NOT IN (
  SELECT name
  FROM uvekon.re_dic_wall_material_accumul
  WHERE id_agency = 1
);
-- Заполнение накопительной таблицы типов материалов стен с novostroyki.lun.ua
INSERT INTO uvekon.re_dic_wall_material_accumul (name,id_agency,source)
SELECT wall_material, 1, 'novostroyki.lun.ua'
FROM (
  SELECT DISTINCT wall_material
  FROM uvekon.re_advert_load
  WHERE id_segment = 1 
  AND agency = 'LUN' 
  AND advert_url like 'https://novostroyki.lun.ua/%'
  AND wall_material IS NOT NULL 
  AND wall_material <> ''
) g
WHERE (wall_material) NOT IN (
  SELECT name
  FROM uvekon.re_dic_wall_material_accumul
  WHERE id_agency = 1
);
-----------------------------------------------------------------------------

-- Простановка "увеконовских" кодов материалов стен в накопительную табл. материалов стен 
UPDATE uvekon.re_dic_wall_material_accumul
SET id_wall_material_u = 
(CASE
  WHEN name in ('Цегляний', 'цегла', 'червона цегла', 'червона цегла, силікатна цегла', 'керамічна цегла') THEN 1
  WHEN name in ('Панельний', 'панель', 'залізобетон', 'залізобетон, газобетон') THEN 2
  WHEN name in ('утеплена панель') THEN 3
  WHEN name in ('Монолітний', 'монолітно-каркасний', 'залізобетон, цегла') THEN 4
  WHEN name in ('Шлакоблочний', 'блочний', 'Газоблок', 'газоблок', 'газоблок, керамоблок', 'газоблок, керамоблок, цегла', 'газоблок, цегла', 'газоблок, шлакоблок', 'керамблок', 'керамзитоблок, цегла',  'керамоблок', 'керамоблок, цегла', 'пеноблок', 'піноблок', 'цементно-піщаний блок', 'арболіт', 'газобетон', 'газобетон, керамзитобетон', 'газосилікат', 'керамзитобетон', 'керамзитобетон, газобетон', 'пінобетон', 'піногазобетон', 'пористий бетон') THEN 5
  WHEN name in ('СИП панель', 'SIP-панелі', 'SIP-панель') THEN 6
  WHEN name in ('Дерев''яний') THEN 7
  WHEN name in ('Інше', 'газобетон, керамоблок, керамічна цегла', 'газобетон, цегла', 'залізобетон, цегла, керамоблок', 'керамзитобетон, цегла', 'керамограніт', 'кератерм', 'натуральний камінь', 'перлитобетон', 'фасадне вітражне скління', 'цегла, газобетон', 'цегла, газоблок', 'цегла, керамоблок', 'цегла, кератерм', 'цегла, пінобетон', 'цегла, піноблок') THEN 8
ELSE null END);

-- Простановка кодов материалов стен в объявления re_advert_load
UPDATE uvekon.re_advert_load l
SET id_wall_material = (
  SELECT id_wall_material_u
  FROM uvekon.re_dic_wall_material_accumul w
  WHERE w.name = l.wall_material 
)
WHERE id_segment = 1
AND wall_material <> ''
AND wall_material IS NOT NULL;



-----------------------------------------------------------------------------------
-- Обновление материалов стен по "увеконовскому" справочнику для архива
UPDATE uvekon.re_advert
SET id_wall_material = 
(CASE
  WHEN id_wall_material in (6, 20, 38, 608, 167, 308, 435, 568, 600, 40, 54) THEN 1
  WHEN id_wall_material in (597, 10, 611, 108, 248, 376, 509, 603) THEN 2
  WHEN id_wall_material in (45, 13) THEN 3
  WHEN id_wall_material in (35, 9, 613, 188, 327, 457, 591, 605, 4) THEN 4
  WHEN id_wall_material in (43, 170, 311, 438, 571, 21, 2, 609, 601, 31, 25, 44, 27, 39, 48, 49, 36, 12, 47, 30, 26, 51, 607, 599) THEN 5
  WHEN id_wall_material in (17, 50, 610, 602) THEN 6
  WHEN id_wall_material in (46, 32, 53, 612, 123, 263, 390, 521, 604, 60) THEN 7
  WHEN id_wall_material in (606, 598, 24, 37, 42, 8, 19, 57, 28, 55, 59, 16, 15, 18, 7, 33, 56, 23, 34, 11, 22, 5, 41, 29, 14, 3, 58, 196, 52) THEN 8
ELSE null END);


-- выборка ср. цены по типу материалу стен - Киев
SELECT id_wall_material, COUNT(*), AVG(price_1sq_meter_usd) FROM uvekon.re_advert_load
WHERE id_wall_material is not null
AND status = 1 AND id_type_oper = 1 AND id_subsegment = 2 AND id_region = '80'
GROUP BY id_wall_material
ORDER BY id_wall_material;

SELECT DISTINCT id_wall_material, COUNT(*)FROM uvekon.re_advert_load
GROUP BY id_wall_material
ORDER BY id_wall_material;