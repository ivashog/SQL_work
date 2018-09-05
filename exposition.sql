update uvekon.re_advert_load
set date_advert0_d=TO_DATE(substr(date_advert0,1,10),'YYYY-MM-DD'),
time_exposition=date_advert_d - date_advert0_d
where date_advert0 is not null
and date_advert_d is not null;