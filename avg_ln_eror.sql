-- обработка для одной записи
update uvekon.re_aggregate_info a
set (avg_ln_price_usd,avg_ln_price_1sq_meter_usd,
std_ln_price_usd,STD_LN_price_1sq_meter_usd)  = 
(
select sum(u.ln_price_usd)/count(u.ln_price_usd) s1,sum(ln_price_1sq_meter_usd)/count(*) s2,
stddev(ln_price_usd) s3,stddev(ln_price_1sq_meter_usd) s4 
from uvekon.re_advert u
where 1=1
and u.ln_price_usd is not null
and u.ln_price_1sq_meter_usd is not null
and u.id_poligon_level_3 is not null
and a.date_relevance=u.date_relevance
and a.id_poligon=u.id_poligon_level_3
and a.id_type_oper=u.id_type_oper
and a.id_segment =u.id_segment 
and a.id_subsegment=u.id_subsegment
and a.id_size_object=u.id_size_object
and a.id_class_subsegment=u.id_class_subsegment
)
where a.level_poligon=3
and a.level_group=4
and a.date_relevance='2017-12-31'
and a.avg_ln_price_usd is null
and a.id_re_agg_sq=2766857;

--проверка этой же записи
select * from uvekon.re_aggregate_info
where level_poligon=3
and level_group=4
and date_relevance='2017-12-31'
order by id_re_agg_sq asc

and a.id_re_agg_sq between 2850253 and 2850253+10000

select * from uvekon.re_aggregate_info
where level_poligon=2
and level_group=2
and date_relevance='2017-10-31'
and avg_ln_price_usd is null
and count_advert > 2;

select * from uvekon.re_aggregate_info
where level_poligon=2
and level_group=3
and date_relevance='2017-11-30'
and avg_ln_price_usd is null
order by id_re_agg_sq asc

AND upper(addr_all) like upper('%Дніпро %') or upper(addr_all) like upper('%Дніпропетровськ)%')




// your jsreport script
const { Client } = require('pg')
const config = 'postgresql://postgres:cQ8ID6Ty0LEn@185.67.2.163:5432/gis' // e.g. postgres://user:password@host:5432/database
const querys = {
    top10UpReg: { 
        text: "SELECT * FROM uvekon.re_aggregate_info WHERE  1=1  AND date_relevance='2017-12-31' AND level_group = 2 AND id_type_oper = 1 AND id_segment = 1 AND id_subsegment = 2 AND level_poligon = 1 ORDER BY price_1sq_meter_usd desc limit 10"
    },
    top10DownReg: { 
        text: "SELECT * FROM uvekon.re_aggregate_info WHERE  1=1  AND date_relevance='2017-12-31' AND level_group = 2 AND id_type_oper = 1 AND id_segment = 1 AND id_subsegment = 2 AND level_poligon = 1 ORDER BY price_1sq_meter_usd asc limit 10"
    }
}
const client = new Client({
  connectionString: config,
});

function beforeRender(req, res, done) {
  client.connect((err) => {
    if (err) {
      console.error('connection error', err.stack)
      return done(err)
    } else {
      console.log('connected')
      client.query(querys.top10UpReg, (err, result) => {
        if (err) throw err
        // next line fill the data that your current report is going to use
        req.data = result.rows; // results should containing the data of your query (array, object, etc)
        req.data = Object.assign({}, req.data, {topRegions: result.rows});
        console.log(req.data);
        client.end();
        done();
      })

    }
  })
};