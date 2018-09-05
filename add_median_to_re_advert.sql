--- 4vgr --------------
----------- 1 level   4 gr --------------------------
update uvekon.re_aggregate_info a
set (median_cost_usd_norm, median_price_usd_norm )  = 
(
select median(price_usd) s1, median(price_1sq_meter_usd) s2
from uvekon.re_advert u
where 1=1
and u.price_usd is not null
and u.price_1sq_meter_usd is not null
and u.id_poligon_level_1 is not null
and a.date_relevance=u.date_relevance
and a.id_poligon=u.id_poligon_level_1
and a.id_type_oper=u.id_type_oper
and a.id_segment =u.id_segment 
and coalesce(a.id_subsegment,0)=coalesce(u.id_subsegment,0)
and coalesce(a.id_size_object,0)=coalesce(u.id_size_object,0)
and coalesce(a.id_class_subsegment,0)=coalesce(u.id_class_subsegment,0)
)
where a.median_cost_usd_norm is null
and a.count_advert > 2
and a.level_poligon=1
and a.level_group=4
and a.date_relevance='2017-11-30';

----------- 2 level   4 gr --------------------------
update uvekon.re_aggregate_info a
set (median_cost_usd_norm, median_price_usd_norm )  = 
(
select median(price_usd) s1, median(price_1sq_meter_usd) s2
from uvekon.re_advert u
where 1=1
and u.price_usd is not null
and u.price_1sq_meter_usd is not null
and u.id_poligon_level_2 is not null
and a.date_relevance=u.date_relevance
and a.id_poligon=u.id_poligon_level_2
and a.id_type_oper=u.id_type_oper
and a.id_segment =u.id_segment 
and coalesce(a.id_subsegment,0)=coalesce(u.id_subsegment,0)
and coalesce(a.id_size_object,0)=coalesce(u.id_size_object,0)
and coalesce(a.id_class_subsegment,0)=coalesce(u.id_class_subsegment,0)
)
where a.median_cost_usd_norm is null
and a.level_poligon=2
and a.level_group=4
and a.count_advert > 2
and a.date_relevance='2017-11-30';


----------- 3 level   4 gr --------------------------

update uvekon.re_aggregate_info a
set (median_cost_usd_norm, median_price_usd_norm )  = 
(
select median(price_usd) s1, median(price_1sq_meter_usd) s2
from uvekon.re_advert u
where 1=1
and u.price_usd is not null
and u.price_1sq_meter_usd is not null
and u.id_poligon_level_3 is not null
and a.date_relevance=u.date_relevance
and a.id_poligon=u.id_poligon_level_3
and a.id_type_oper=u.id_type_oper
and a.id_segment =u.id_segment 
and coalesce(a.id_subsegment,0)=coalesce(u.id_subsegment,0)
and coalesce(a.id_size_object,0)=coalesce(u.id_size_object,0)
and coalesce(a.id_class_subsegment,0)=coalesce(u.id_class_subsegment,0)
)
where a.median_cost_usd_norm is null
and a.count_advert > 2
and a.level_poligon=3
and a.level_group=4
and a.date_relevance='2017-11-30';


----------- 4 level   4 gr --------------------------

update uvekon.re_aggregate_info a
set (median_cost_usd_norm, median_price_usd_norm )  = 
(
select median(price_usd) s1, median(price_1sq_meter_usd) s2
from uvekon.re_advert u
where 1=1
and u.price_usd is not null
and u.price_1sq_meter_usd is not null
and u.id_poligon_level_4 is not null
and a.date_relevance=u.date_relevance
and a.id_poligon=u.id_poligon_level_4
and a.id_type_oper=u.id_type_oper
and a.id_segment =u.id_segment 
and coalesce(a.id_subsegment,0)=coalesce(u.id_subsegment,0)
and coalesce(a.id_size_object,0)=coalesce(u.id_size_object,0)
and coalesce(a.id_class_subsegment,0)=coalesce(u.id_class_subsegment,0)
)
where a.median_cost_usd_norm is null
and a.count_advert > 2
and a.level_poligon=4
and a.level_group=4
and a.date_relevance='2017-11-30';


--------------------- 3vgr ----------------------------

----------- 1 level   3 gr --------------------------
update uvekon.re_aggregate_info a
set (median_cost_usd_norm, median_price_usd_norm )  = 
(
select median(price_usd) s1, median(price_1sq_meter_usd) s2
from uvekon.re_advert u
where 1=1
and u.price_usd is not null
and u.price_1sq_meter_usd is not null
and u.id_poligon_level_1 is not null
and a.date_relevance=u.date_relevance
and a.id_poligon=u.id_poligon_level_1
and a.id_type_oper=u.id_type_oper
and a.id_segment =u.id_segment 
and coalesce(a.id_subsegment,0)=coalesce(u.id_subsegment,0)
and coalesce(a.id_class_subsegment,0)=coalesce(u.id_class_subsegment,0)
and a.id_size_object is null
)
where a.level_poligon=1
and a.level_group=3
and a.date_relevance='2017-12-31'
and a.median_cost_usd_norm is null;


----------- 2 level   3 gr --------------------------
update uvekon.re_aggregate_info a
set (median_cost_usd_norm, median_price_usd_norm )  = 
(
select median(price_usd) s1, median(price_1sq_meter_usd) s2
from uvekon.re_advert u
where 1=1
and u.price_usd is not null
and u.price_1sq_meter_usd is not null
and u.id_poligon_level_2 is not null
and a.date_relevance=u.date_relevance
and a.id_poligon=u.id_poligon_level_2
and a.id_type_oper=u.id_type_oper
and a.id_segment =u.id_segment 
and coalesce(a.id_subsegment,0)=coalesce(u.id_subsegment,0)
and coalesce(a.id_class_subsegment,0)=coalesce(u.id_class_subsegment,0)
and a.id_size_object is null
)
where a.level_poligon=2
and a.level_group=3
and a.date_relevance='2017-12-31'
and a.median_cost_usd_norm is null;



----------- 3 level   3 gr --------------------------

update uvekon.re_aggregate_info a
set (median_cost_usd_norm, median_price_usd_norm )  = 
(
select median(price_usd) s1, median(price_1sq_meter_usd) s2
from uvekon.re_advert u
where 1=1
and u.price_usd is not null
and u.price_1sq_meter_usd is not null
and u.id_poligon_level_3 is not null
and a.date_relevance=u.date_relevance
and a.id_poligon=u.id_poligon_level_3
and a.id_type_oper=u.id_type_oper
and a.id_segment =u.id_segment 
and coalesce(a.id_subsegment,0)=coalesce(u.id_subsegment,0)
and coalesce(a.id_class_subsegment,0)=coalesce(u.id_class_subsegment,0)
and a.id_size_object is null
)
where a.level_poligon=3
and a.level_group=3
and a.date_relevance='2017-12-31'
and a.median_cost_usd_norm is null;




----------- 4 level   3 gr --------------------------

update uvekon.re_aggregate_info a
set (median_cost_usd_norm, median_price_usd_norm )  = 
(
select median(price_usd) s1, median(price_1sq_meter_usd) s2
from uvekon.re_advert u
where 1=1
and u.price_usd is not null
and u.price_1sq_meter_usd is not null
and u.id_poligon_level_4 is not null
and a.date_relevance=u.date_relevance
and a.id_poligon=u.id_poligon_level_4
and a.id_type_oper=u.id_type_oper
and a.id_segment =u.id_segment 
and coalesce(a.id_subsegment,0)=coalesce(u.id_subsegment,0)
and coalesce(a.id_class_subsegment,0)=coalesce(u.id_class_subsegment,0)
and a.id_size_object is null
)
where a.median_cost_usd_norm is null;
and a.level_poligon=4
and a.level_group=3
and a.date_relevance='2017-12-31';




------------------- 2vgr -----------------------------------------------

----------- 1 level   2 gr --------------------------
update uvekon.re_aggregate_info a
set (median_cost_usd_norm, median_price_usd_norm )  = 
(
select median(price_usd) s1, median(price_1sq_meter_usd) s2
from uvekon.re_advert u
where 1=1
and u.price_usd is not null
and u.price_1sq_meter_usd is not null
and u.id_poligon_level_1 is not null
and a.date_relevance=u.date_relevance
and a.id_poligon=u.id_poligon_level_1
and a.id_type_oper=u.id_type_oper
and a.id_segment =u.id_segment 
and coalesce(a.id_subsegment,0)=coalesce(u.id_subsegment,0)
and a.id_class_subsegment is null
and a.id_size_object is null
)
where a.level_poligon=1
and a.level_group=2
and a.count_advert > 2
and a.date_relevance='2017-11-30'
and a.median_cost_usd_norm is null;

----------- 2 level   2 gr --------------------------
update uvekon.re_aggregate_info a
set (median_cost_usd_norm, median_price_usd_norm )  = 
(
select median(price_usd) s1, median(price_1sq_meter_usd) s2
from uvekon.re_advert u
where 1=1
and u.price_usd is not null
and u.price_1sq_meter_usd is not null
and u.id_poligon_level_2 is not null
and a.date_relevance=u.date_relevance
and a.id_poligon=u.id_poligon_level_2
and a.id_type_oper=u.id_type_oper
and a.id_segment =u.id_segment 
and coalesce(a.id_subsegment,0)=coalesce(u.id_subsegment,0)
and a.id_class_subsegment is null
and a.id_size_object is null
)
where a.level_poligon=2
and a.level_group=2
and a.count_advert > 2
and a.date_relevance='2017-11-30'
and a.median_cost_usd_norm is null;



----------- 3 level   2 gr --------------------------

update uvekon.re_aggregate_info a
set (median_cost_usd_norm, median_price_usd_norm )  = 
(
select median(price_usd) s1, median(price_1sq_meter_usd) s2
from uvekon.re_advert u
where 1=1
and u.price_usd is not null
and u.price_1sq_meter_usd is not null
and u.id_poligon_level_3 is not null
and a.date_relevance=u.date_relevance
and a.id_poligon=u.id_poligon_level_3
and a.id_type_oper=u.id_type_oper
and a.id_segment =u.id_segment 
and coalesce(a.id_subsegment,0)=coalesce(u.id_subsegment,0)
and a.id_class_subsegment is null
and a.id_size_object is null
)
where a.level_poligon=3
and a.level_group=2
and a.date_relevance='2017-12-31'
and a.median_cost_usd_norm is null;





----------- 4 level   2 gr --------------------------

update uvekon.re_aggregate_info a
set (median_cost_usd_norm, median_price_usd_norm )  = 
(
select median(price_usd) s1, median(price_1sq_meter_usd) s2
from uvekon.re_advert u
where 1=1
and u.price_usd is not null
and u.price_1sq_meter_usd is not null
and u.id_poligon_level_4 is not null
and a.date_relevance=u.date_relevance
and a.id_poligon=u.id_poligon_level_4
and a.id_type_oper=u.id_type_oper
and a.id_segment =u.id_segment 
and coalesce(a.id_subsegment,0)=coalesce(u.id_subsegment,0)
and a.id_class_subsegment is null
and a.id_size_object is null
)
where a.level_poligon=4
and a.level_group=2
and a.date_relevance='2017-12-31'
and a.median_cost_usd_norm is null;



------------------- 1 vgr -----------------------------------------------

----------- 1 level   1 gr --------------------------
update uvekon.re_aggregate_info a
set (median_cost_usd_norm, median_price_usd_norm )  = 
(
select median(price_usd) s1, median(price_1sq_meter_usd) s2
from uvekon.re_advert u
where 1=1
and u.price_usd is not null
and u.price_1sq_meter_usd is not null
and u.id_poligon_level_1 is not null
and a.date_relevance=u.date_relevance
and a.id_poligon=u.id_poligon_level_1
and a.id_type_oper=u.id_type_oper
and a.id_segment =u.id_segment 
and a.id_subsegment is null
and a.id_class_subsegment is null
and a.id_size_object is null
)
where a.level_poligon=1
and a.level_group=1
and a.count_advert > 2
and a.date_relevance='2017-11-30'
and a.median_cost_usd_norm is null;


----------- 2 level   1 gr --------------------------
update uvekon.re_aggregate_info a
set (median_cost_usd_norm, median_price_usd_norm )  = 
(
select median(price_usd) s1, median(price_1sq_meter_usd) s2
from uvekon.re_advert u
where 1=1
and u.price_usd is not null
and u.price_1sq_meter_usd is not null
and u.id_poligon_level_2 is not null
and a.date_relevance=u.date_relevance
and a.id_poligon=u.id_poligon_level_2
and a.id_type_oper=u.id_type_oper
and a.id_segment =u.id_segment 
and a.id_subsegment is null
and a.id_class_subsegment is null
and a.id_size_object is null
)
where a.level_poligon=2
and a.level_group=1
and a.count_advert > 2
and a.date_relevance='2017-11-30';
and a.median_cost_usd_norm is null;



----------- 3 level   1 gr --------------------------

update uvekon.re_aggregate_info a
set (median_cost_usd_norm, median_price_usd_norm )  = 
(
select median(price_usd) s1, median(price_1sq_meter_usd) s2
from uvekon.re_advert u
where 1=1
and u.price_usd is not null
and u.price_1sq_meter_usd is not null
and u.id_poligon_level_3 is not null
and a.date_relevance=u.date_relevance
and a.id_poligon=u.id_poligon_level_3
and a.id_type_oper=u.id_type_oper
and a.id_segment =u.id_segment 
and a.id_subsegment is null
and a.id_class_subsegment is null
and a.id_size_object is null
)
where a.level_poligon=3
and a.level_group=1
and a.date_relevance='2017-12-31'
and a.median_cost_usd_norm is null;



----------- 4 level   1 gr --------------------------

update uvekon.re_aggregate_info a
set (median_cost_usd_norm, median_price_usd_norm )  = 
(
select median(price_usd) s1, median(price_1sq_meter_usd) s2
from uvekon.re_advert u
where 1=1
and u.price_usd is not null
and u.price_1sq_meter_usd is not null
and u.id_poligon_level_4 is not null
and a.date_relevance=u.date_relevance
and a.id_poligon=u.id_poligon_level_4
and a.id_type_oper=u.id_type_oper
and a.id_segment =u.id_segment 
and a.id_subsegment is null
and a.id_class_subsegment is null
and a.id_size_object is null
)
where a.level_poligon=4
and a.level_group=1
and a.date_relevance='2017-12-31'
and a.median_cost_usd_norm is null;





