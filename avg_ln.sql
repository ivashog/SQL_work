--- 4vgr --------------
----------- 1 level   4 gr --------------------------
update uvekon.re_aggregate_info a
set (avg_ln_price_usd,avg_ln_price_1sq_meter_usd,
std_ln_price_usd,STD_LN_price_1sq_meter_usd)  = 
(select s1,s2,s3,s4 from 
(
select sum(u.ln_price_usd)/count(u.ln_price_usd) s1,sum(ln_price_1sq_meter_usd)/count(*) s2,
stddev(ln_price_usd) s3,stddev(ln_price_1sq_meter_usd) s4,
id_segment,id_subsegment,id_type_oper, 
  id_size_object,id_class_subsegment,id_poligon_level_1,
  date_relevance  
from uvekon.re_advert u
where 1=1
and u.ln_price_usd is not null
and u.ln_price_1sq_meter_usd is not null
and u.date_relevance='2017-12-31'
and u.id_poligon_level_1 is not null
GROUP BY
  id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_size_object, -- Код размера объекта (РАСЧЕТНОЕ)
  id_class_subsegment, -- Код класса подсегмента (РАСЧЕТНАЯ)
  id_poligon_level_1,
  date_relevance  
) t
where a.date_relevance=t.date_relevance
and a.level_poligon=1
and a.level_group=4
and a.id_poligon=t.id_poligon_level_1
and a.id_type_oper=t.id_type_oper
and a.id_segment =t.id_segment 
and a.id_subsegment=t.id_subsegment
and a.id_size_object=t.id_size_object
and a.id_class_subsegment=t.id_class_subsegment
);

----------- 2 level   4 gr --------------------------
update uvekon.re_aggregate_info a
set (avg_ln_price_usd,avg_ln_price_1sq_meter_usd,
std_ln_price_usd,STD_LN_price_1sq_meter_usd)  = 
(select s1,s2,s3,s4 from 
(
select sum(u.ln_price_usd)/count(u.ln_price_usd) s1,sum(ln_price_1sq_meter_usd)/count(*) s2,
stddev(ln_price_usd) s3,stddev(ln_price_1sq_meter_usd) s4,
id_segment,id_subsegment,id_type_oper, 
  id_size_object,id_class_subsegment,id_poligon_level_2,
  date_relevance  
from uvekon.re_advert u
where 1=1
and u.ln_price_usd is not null
and u.ln_price_1sq_meter_usd is not null
and u.date_relevance='2017-12-31'
and u.id_poligon_level_2 is not null
GROUP BY
  id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_size_object, -- Код размера объекта (РАСЧЕТНОЕ)
  id_class_subsegment, -- Код класса подсегмента (РАСЧЕТНАЯ)
  id_poligon_level_2,
  date_relevance  
) t
where a.date_relevance=t.date_relevance
and a.level_poligon=2
and a.level_group=4
and a.id_poligon=t.id_poligon_level_2
and a.id_type_oper=t.id_type_oper
and a.id_segment =t.id_segment 
and a.id_subsegment=t.id_subsegment
and a.id_size_object=t.id_size_object
and a.id_class_subsegment=t.id_class_subsegment
);

----------- 3 level   4 gr --------------------------
update uvekon.re_aggregate_info a
set (avg_ln_price_usd,avg_ln_price_1sq_meter_usd,
std_ln_price_usd,STD_LN_price_1sq_meter_usd)  = 
(select s1,s2,s3,s4 from 
(
select sum(u.ln_price_usd)/count(u.ln_price_usd) s1,sum(ln_price_1sq_meter_usd)/count(*) s2,
stddev(ln_price_usd) s3,stddev(ln_price_1sq_meter_usd) s4,
id_segment,id_subsegment,id_type_oper, 
  id_size_object,id_class_subsegment,id_poligon_level_3,
  date_relevance  
from uvekon.re_advert u
where 1=1
and u.ln_price_usd is not null
and u.ln_price_1sq_meter_usd is not null
and u.date_relevance='2017-12-31'
and u.id_poligon_level_3 is not null
GROUP BY
  id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_size_object, -- Код размера объекта (РАСЧЕТНОЕ)
  id_class_subsegment, -- Код класса подсегмента (РАСЧЕТНАЯ)
  id_poligon_level_3,
  date_relevance  
) t
where a.date_relevance=t.date_relevance
and a.level_poligon=3
and a.level_group=4
and a.id_poligon=t.id_poligon_level_3
and a.id_type_oper=t.id_type_oper
and a.id_segment =t.id_segment 
and a.id_subsegment=t.id_subsegment
and a.id_size_object=t.id_size_object
and a.id_class_subsegment=t.id_class_subsegment
);

----------- 4 level   4 gr --------------------------
update uvekon.re_aggregate_info a
set (avg_ln_price_usd,avg_ln_price_1sq_meter_usd,
std_ln_price_usd,STD_LN_price_1sq_meter_usd)  = 
(select s1,s2,s3,s4 from 
(
select sum(u.ln_price_usd)/count(u.ln_price_usd) s1,sum(ln_price_1sq_meter_usd)/count(*) s2,
stddev(ln_price_usd) s3,stddev(ln_price_1sq_meter_usd) s4,
id_segment,id_subsegment,id_type_oper, 
  id_size_object,id_class_subsegment,id_poligon_level_4,
  date_relevance  
from uvekon.re_advert u
where 1=1
and u.ln_price_usd is not null
and u.ln_price_1sq_meter_usd is not null
and u.date_relevance='2017-12-31'
and u.id_poligon_level_4 is not null
GROUP BY
  id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
  id_size_object, -- Код размера объекта (РАСЧЕТНОЕ)
  id_class_subsegment, -- Код класса подсегмента (РАСЧЕТНАЯ)
  id_poligon_level_4,
  date_relevance  
) t
where a.date_relevance=t.date_relevance
and a.level_poligon=4
and a.level_group=4
and a.id_poligon=t.id_poligon_level_4
and a.id_type_oper=t.id_type_oper
and a.id_segment =t.id_segment 
and a.id_subsegment=t.id_subsegment
and a.id_size_object=t.id_size_object
and a.id_class_subsegment=t.id_class_subsegment
);

--------------------- 3vgr ----------------------------


----------- 1 level   3 gr --------------------------
update uvekon.re_aggregate_info a
set (avg_ln_price_usd,avg_ln_price_1sq_meter_usd,
std_ln_price_usd,STD_LN_price_1sq_meter_usd)  = 
(select s1,s2,s3,s4 from 
(
select sum(u.ln_price_usd)/count(u.ln_price_usd) s1,sum(ln_price_1sq_meter_usd)/count(*) s2,
stddev(ln_price_usd) s3,stddev(ln_price_1sq_meter_usd) s4,
id_segment,id_subsegment,id_type_oper, 
  id_class_subsegment,id_poligon_level_1,
  date_relevance  
from uvekon.re_advert u
where 1=1
and u.ln_price_usd is not null
and u.ln_price_1sq_meter_usd is not null
and u.date_relevance='2017-12-31'
and u.id_poligon_level_1 is not null
GROUP BY
  id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
--  id_size_object, -- Код размера объекта (РАСЧЕТНОЕ)
  id_class_subsegment, -- Код класса подсегмента (РАСЧЕТНАЯ)
  id_poligon_level_1,
  date_relevance  
) t
where a.date_relevance=t.date_relevance
and a.level_poligon=1
and a.level_group=3
and a.id_poligon=t.id_poligon_level_1
and a.id_type_oper=t.id_type_oper
and a.id_segment =t.id_segment 
and a.id_subsegment=t.id_subsegment
and a.id_class_subsegment=t.id_class_subsegment
and a.id_size_object is null
);

----------- 2 level   3 gr --------------------------
update uvekon.re_aggregate_info a
set (avg_ln_price_usd,avg_ln_price_1sq_meter_usd,
std_ln_price_usd,STD_LN_price_1sq_meter_usd)  = 
(select s1,s2,s3,s4 from 
(
select sum(u.ln_price_usd)/count(u.ln_price_usd) s1,sum(ln_price_1sq_meter_usd)/count(*) s2,
stddev(ln_price_usd) s3,stddev(ln_price_1sq_meter_usd) s4,
id_segment,id_subsegment,id_type_oper, 
  id_class_subsegment,id_poligon_level_2,
  date_relevance  
from uvekon.re_advert u
where 1=1
and u.ln_price_usd is not null
and u.ln_price_1sq_meter_usd is not null
and u.date_relevance='2017-12-31'
and u.id_poligon_level_2 is not null
GROUP BY
  id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
--  id_size_object, -- Код размера объекта (РАСЧЕТНОЕ)
  id_class_subsegment, -- Код класса подсегмента (РАСЧЕТНАЯ)
  id_poligon_level_2,
  date_relevance  
) t
where a.date_relevance=t.date_relevance
and a.level_poligon=2
and a.level_group=3
and a.id_poligon=t.id_poligon_level_2
and a.id_type_oper=t.id_type_oper
and a.id_segment =t.id_segment 
and a.id_subsegment=t.id_subsegment
and a.id_class_subsegment=t.id_class_subsegment
and a.id_size_object is null
);

----------- 3 level   3 gr --------------------------
update uvekon.re_aggregate_info a
set (avg_ln_price_usd,avg_ln_price_1sq_meter_usd,
std_ln_price_usd,STD_LN_price_1sq_meter_usd)  = 
(select s1,s2,s3,s4 from 
(
select sum(u.ln_price_usd)/count(u.ln_price_usd) s1,sum(ln_price_1sq_meter_usd)/count(*) s2,
stddev(ln_price_usd) s3,stddev(ln_price_1sq_meter_usd) s4,
id_segment,id_subsegment,id_type_oper, 
  id_class_subsegment,id_poligon_level_3,
  date_relevance  
from uvekon.re_advert u
where 1=1
and u.ln_price_usd is not null
and u.ln_price_1sq_meter_usd is not null
and u.date_relevance='2017-12-31'
and u.id_poligon_level_3 is not null
GROUP BY
  id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
--  id_size_object, -- Код размера объекта (РАСЧЕТНОЕ)
  id_class_subsegment, -- Код класса подсегмента (РАСЧЕТНАЯ)
  id_poligon_level_3,
  date_relevance  
) t
where a.date_relevance=t.date_relevance
and a.level_poligon=3
and a.level_group=3
and a.id_poligon=t.id_poligon_level_3
and a.id_type_oper=t.id_type_oper
and a.id_segment =t.id_segment 
and a.id_subsegment=t.id_subsegment
and a.id_class_subsegment=t.id_class_subsegment
and a.id_size_object is null
);

----------- 4 level   3 gr --------------------------
update uvekon.re_aggregate_info a
set (avg_ln_price_usd,avg_ln_price_1sq_meter_usd,
std_ln_price_usd,STD_LN_price_1sq_meter_usd)  = 
(select s1,s2,s3,s4 from 
(
select sum(u.ln_price_usd)/count(u.ln_price_usd) s1,sum(ln_price_1sq_meter_usd)/count(*) s2,
stddev(ln_price_usd) s3,stddev(ln_price_1sq_meter_usd) s4,
id_segment,id_subsegment,id_type_oper, 
  id_size_object,id_class_subsegment,id_poligon_level_4,
  date_relevance  
from uvekon.re_advert u
where 1=1
and u.ln_price_usd is not null
and u.ln_price_1sq_meter_usd is not null
and u.date_relevance='2017-12-31'
and u.id_poligon_level_4 is not null
GROUP BY
  id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
--  id_size_object, -- Код размера объекта (РАСЧЕТНОЕ)
  id_class_subsegment, -- Код класса подсегмента (РАСЧЕТНАЯ)
  id_poligon_level_4,
  date_relevance  
) t
where a.date_relevance=t.date_relevance
and a.level_poligon=4
and a.level_group=3
and a.id_poligon=t.id_poligon_level_4
and a.id_type_oper=t.id_type_oper
and a.id_segment =t.id_segment 
and a.id_subsegment=t.id_subsegment
and a.id_size_object=t.id_size_object
and a.id_class_subsegment=t.id_class_subsegment
and a.id_size_object is null
);

------------------- 2vgr -----------------------------------------------


----------- 1 level   2 gr --------------------------
update uvekon.re_aggregate_info a
set (avg_ln_price_usd,avg_ln_price_1sq_meter_usd,
std_ln_price_usd,STD_LN_price_1sq_meter_usd)  = 
(select s1,s2,s3,s4 from 
(
select sum(u.ln_price_usd)/count(u.ln_price_usd) s1,sum(ln_price_1sq_meter_usd)/count(*) s2,
stddev(ln_price_usd) s3,stddev(ln_price_1sq_meter_usd) s4,
id_segment,id_subsegment,id_type_oper, 
  id_poligon_level_1,
  date_relevance  
from uvekon.re_advert u
where 1=1
and u.ln_price_usd is not null
and u.ln_price_1sq_meter_usd is not null
and u.date_relevance='2017-12-31'
and u.id_poligon_level_1 is not null
GROUP BY
  id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
--  id_size_object, -- Код размера объекта (РАСЧЕТНОЕ)
--  id_class_subsegment, -- Код класса подсегмента (РАСЧЕТНАЯ)
  id_poligon_level_1,
  date_relevance  
) t
where a.date_relevance=t.date_relevance
and a.level_poligon=1
and a.level_group=2
and a.id_poligon=t.id_poligon_level_1
and a.id_type_oper=t.id_type_oper
and a.id_segment =t.id_segment 
and a.id_subsegment=t.id_subsegment
and a.id_size_object is null
and a.id_class_subsegment is null
);

----------- 2 level   2 gr --------------------------
update uvekon.re_aggregate_info a
set (avg_ln_price_usd,avg_ln_price_1sq_meter_usd,
std_ln_price_usd,STD_LN_price_1sq_meter_usd)  = 
(select s1,s2,s3,s4 from 
(
select sum(u.ln_price_usd)/count(u.ln_price_usd) s1,sum(ln_price_1sq_meter_usd)/count(*) s2,
stddev(ln_price_usd) s3,stddev(ln_price_1sq_meter_usd) s4,
id_segment,id_subsegment,id_type_oper, 
  id_poligon_level_2,
  date_relevance  
from uvekon.re_advert u
where 1=1
and u.ln_price_usd is not null
and u.ln_price_1sq_meter_usd is not null
and u.date_relevance='2017-12-31'
and u.id_poligon_level_2 is not null
GROUP BY
  id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
--  id_size_object, -- Код размера объекта (РАСЧЕТНОЕ)
--  id_class_subsegment, -- Код класса подсегмента (РАСЧЕТНАЯ)
  id_poligon_level_2,
  date_relevance  
) t
where a.date_relevance=t.date_relevance
and a.level_poligon=2
and a.level_group=2
and a.id_poligon=t.id_poligon_level_2
and a.id_type_oper=t.id_type_oper
and a.id_segment =t.id_segment 
and a.id_subsegment=t.id_subsegment
and a.id_size_object is null
and a.id_class_subsegment is null
);

----------- 3 level   2 gr --------------------------
update uvekon.re_aggregate_info a
set (avg_ln_price_usd,avg_ln_price_1sq_meter_usd,
std_ln_price_usd,STD_LN_price_1sq_meter_usd)  = 
(select s1,s2,s3,s4 from 
(
select sum(u.ln_price_usd)/count(u.ln_price_usd) s1,sum(ln_price_1sq_meter_usd)/count(*) s2,
stddev(ln_price_usd) s3,stddev(ln_price_1sq_meter_usd) s4,
id_segment,id_subsegment,id_type_oper, 
  id_class_subsegment,id_poligon_level_3,
  date_relevance  
from uvekon.re_advert u
where 1=1
and u.ln_price_usd is not null
and u.ln_price_1sq_meter_usd is not null
and u.date_relevance='2017-12-31'
and u.id_poligon_level_3 is not null
GROUP BY
  id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
--  id_size_object, -- Код размера объекта (РАСЧЕТНОЕ)
--  id_class_subsegment, -- Код класса подсегмента (РАСЧЕТНАЯ)
  id_poligon_level_3,
  date_relevance  
) t
where a.date_relevance=t.date_relevance
and a.level_poligon=3
and a.level_group=2
and a.id_poligon=t.id_poligon_level_3
and a.id_type_oper=t.id_type_oper
and a.id_segment =t.id_segment 
and a.id_subsegment=t.id_subsegment
and a.id_size_object is null
and a.id_class_subsegment is null
);

----------- 4 level   2 gr --------------------------
update uvekon.re_aggregate_info a
set (avg_ln_price_usd,avg_ln_price_1sq_meter_usd,
std_ln_price_usd,STD_LN_price_1sq_meter_usd)  = 
(select s1,s2,s3,s4 from 
(
select sum(u.ln_price_usd)/count(u.ln_price_usd) s1,sum(ln_price_1sq_meter_usd)/count(*) s2,
stddev(ln_price_usd) s3,stddev(ln_price_1sq_meter_usd) s4,
id_segment,id_subsegment,id_type_oper, 
  id_poligon_level_4,
  date_relevance  
from uvekon.re_advert u
where 1=1
and u.ln_price_usd is not null
and u.ln_price_1sq_meter_usd is not null
and u.date_relevance='2017-12-31'
and u.id_poligon_level_4 is not null
GROUP BY
  id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
--  id_size_object, -- Код размера объекта (РАСЧЕТНОЕ)
--  id_class_subsegment, -- Код класса подсегмента (РАСЧЕТНАЯ)
  id_poligon_level_4,
  date_relevance  
) t
where a.date_relevance=t.date_relevance
and a.level_poligon=4
and a.level_group=2
and a.id_poligon=t.id_poligon_level_4
and a.id_type_oper=t.id_type_oper
and a.id_segment =t.id_segment 
and a.id_subsegment=t.id_subsegment
and a.id_size_object is null
and a.id_class_subsegment is null
);

------------------- 1 vgr -----------------------------------------------


----------- 1 level   1 gr --------------------------
update uvekon.re_aggregate_info a
set (avg_ln_price_usd,avg_ln_price_1sq_meter_usd,
std_ln_price_usd,STD_LN_price_1sq_meter_usd)  = 
(select s1,s2,s3,s4 from 
(
select sum(u.ln_price_usd)/count(u.ln_price_usd) s1,sum(ln_price_1sq_meter_usd)/count(*) s2,
stddev(ln_price_usd) s3,stddev(ln_price_1sq_meter_usd) s4,
id_segment,id_type_oper, 
  id_poligon_level_1,
  date_relevance  
from uvekon.re_advert u
where 1=1
and u.ln_price_usd is not null
and u.ln_price_1sq_meter_usd is not null
and u.date_relevance='2017-12-31'
and u.id_poligon_level_1 is not null
GROUP BY
  id_segment , -- Код сегмента (РАСЧЕТНОЕ)
--  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
--  id_size_object, -- Код размера объекта (РАСЧЕТНОЕ)
--  id_class_subsegment, -- Код класса подсегмента (РАСЧЕТНАЯ)
  id_poligon_level_1,
  date_relevance  
) t
where a.date_relevance=t.date_relevance
and a.level_poligon=1
and a.level_group=1
and a.id_poligon=t.id_poligon_level_1
and a.id_type_oper=t.id_type_oper
and a.id_segment =t.id_segment 
and a.id_subsegment=t.id_subsegment
and a.id_size_object is null
and a.id_class_subsegment is null
and a.id_subsegment is null
);

----------- 2 level   1 gr --------------------------
update uvekon.re_aggregate_info a
set (avg_ln_price_usd,avg_ln_price_1sq_meter_usd,
std_ln_price_usd,STD_LN_price_1sq_meter_usd)  = 
(select s1,s2,s3,s4 from 
(
select sum(u.ln_price_usd)/count(u.ln_price_usd) s1,sum(ln_price_1sq_meter_usd)/count(*) s2,
stddev(ln_price_usd) s3,stddev(ln_price_1sq_meter_usd) s4,
id_segment,id_type_oper, 
  id_poligon_level_2,
  date_relevance  
from uvekon.re_advert u
where 1=1
and u.ln_price_usd is not null
and u.ln_price_1sq_meter_usd is not null
and u.date_relevance='2017-12-31'
and u.id_poligon_level_2 is not null
GROUP BY
  id_segment , -- Код сегмента (РАСЧЕТНОЕ)
  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
--  id_size_object, -- Код размера объекта (РАСЧЕТНОЕ)
--  id_class_subsegment, -- Код класса подсегмента (РАСЧЕТНАЯ)
  id_poligon_level_2,
  date_relevance  
) t
where a.date_relevance=t.date_relevance
and a.level_poligon=2
and a.level_group=1
and a.id_poligon=t.id_poligon_level_2
and a.id_type_oper=t.id_type_oper
and a.id_segment =t.id_segment 
and a.id_subsegment=t.id_subsegment
and a.id_size_object is null
and a.id_class_subsegment is null
and a.id_subsegment is null
);

----------- 3 level   1 gr --------------------------
update uvekon.re_aggregate_info a
set (avg_ln_price_usd,avg_ln_price_1sq_meter_usd,
std_ln_price_usd,STD_LN_price_1sq_meter_usd)  = 
(select s1,s2,s3,s4 from 
(
select sum(u.ln_price_usd)/count(u.ln_price_usd) s1,sum(ln_price_1sq_meter_usd)/count(*) s2,
stddev(ln_price_usd) s3,stddev(ln_price_1sq_meter_usd) s4,
id_segment,id_type_oper, 
  id_class_subsegment,id_poligon_level_3,
  date_relevance  
from uvekon.re_advert u
where 1=1
and u.ln_price_usd is not null
and u.ln_price_1sq_meter_usd is not null
and u.date_relevance='2017-12-31'
and u.id_poligon_level_3 is not null
GROUP BY
  id_segment , -- Код сегмента (РАСЧЕТНОЕ)
--  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
--  id_size_object, -- Код размера объекта (РАСЧЕТНОЕ)
--  id_class_subsegment, -- Код класса подсегмента (РАСЧЕТНАЯ)
  id_poligon_level_3,
  date_relevance  
) t
where a.date_relevance=t.date_relevance
and a.level_poligon=3
and a.level_group=1
and a.id_poligon=t.id_poligon_level_3
and a.id_type_oper=t.id_type_oper
and a.id_segment =t.id_segment 
and a.id_subsegment=t.id_subsegment
and a.id_size_object is null
and a.id_class_subsegment is null
and a.id_subsegment is null
);

----------- 4 level   1 gr --------------------------
update uvekon.re_aggregate_info a
set (avg_ln_price_usd,avg_ln_price_1sq_meter_usd,
std_ln_price_usd,STD_LN_price_1sq_meter_usd)  = 
(select s1,s2,s3,s4 from 
(
select sum(u.ln_price_usd)/count(u.ln_price_usd) s1,sum(ln_price_1sq_meter_usd)/count(*) s2,
stddev(ln_price_usd) s3,stddev(ln_price_1sq_meter_usd) s4,
id_segment,id_type_oper, 
  id_poligon_level_4,
  date_relevance  
from uvekon.re_advert u
where 1=1
and u.ln_price_usd is not null
and u.ln_price_1sq_meter_usd is not null
and u.date_relevance='2017-12-31'
and u.id_poligon_level_4 is not null
GROUP BY
  id_segment , -- Код сегмента (РАСЧЕТНОЕ)
--  id_subsegment, -- Код подсегмента (РАСЧЕТНОЕ)
  id_type_oper, -- Код типа операции (РАСЧЕТНОЕ)
--  id_size_object, -- Код размера объекта (РАСЧЕТНОЕ)
--  id_class_subsegment, -- Код класса подсегмента (РАСЧЕТНАЯ)
  id_poligon_level_4,
  date_relevance  
) t
where a.date_relevance=t.date_relevance
and a.level_poligon=4
and a.level_group=1
and a.id_poligon=t.id_poligon_level_4
and a.id_type_oper=t.id_type_oper
and a.id_segment =t.id_segment 
and a.id_subsegment=t.id_subsegment
and a.id_size_object is null
and a.id_class_subsegment is null
and a.id_subsegment is null
);



