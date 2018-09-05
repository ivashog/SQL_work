-- FUNCTION: uvekon.set_suburb_by_koatuu(text)
 -- DROP FUNCTION uvekon.set_suburb_by_koatuu(text);

CREATE OR REPLACE FUNCTION uvekon.set_suburb_by_koatuu( vkcodemask text) RETURNS integer LANGUAGE 'plpgsql' COST 100 VOLATILE AS $BODY$

/*	простановка koatuu_code пригорода по тексту объявления и справочнику uvekon.re_dic_koatuu_suburb.
*/
	 DECLARE
			prec     record;
			vRegEx   text;
			vRegExTrash   text;
			nRes     int :=0;
			nCurrentUpdate int;
	 BEGIN
			if (length(vkcodemask)=0 or (position('%' in vkcodemask)=0 and position('?' in vkcodemask)=0 ) ) then
				vkcodemask := vkcodemask || '%';
			end if;
			FOR prec IN (select t.*, k.district,
													((case when t.koatuu_code_city like '__00000000' then 100 else 0 end)
														+
													 (case when t.koatuu_code_suburb not like '__2__00000' and t.koatuu_code_suburb not like '__00000000' then 1
																 when t.koatuu_code_suburb like '__2__00000' then 2
																 when t.koatuu_code_suburb  like '__00000000' then 3
															 else 5
														end)
													)    as forder
									 from uvekon.re_dic_koatuu_suburb t, uvekon.re_dic_koatuu k
			 where t.koatuu_code_city like  vkcodemask
												 and  t.koatuu_code_city is not null
												 and  t.region <> '80'
															and addr_mask <> ''   and k.koatuu_code = t.koatuu_code_suburb
									 order by  t.region, t.koatuu_code_city, forder
		)
			LOOP
				vRegEx := uvekon.prepare_multimask_to_regex (prec.addr_mask);
				vRegExTrash := uvekon.prepare_multimask_to_regex (prec.trash_mask);
				if (length(vRegExTrash)<>0) then
							update uvekon.re_advert_load a
							set koatuu_code = prec.koatuu_code_suburb, id_region = prec.region, id_kotuu_district=prec.district
							where         koatuu_code = prec.koatuu_code_city
														and upper(a.advert_text) ~ vRegEx and not upper(a.advert_text) ~ vRegExTrash;
					else
							update uvekon.re_advert_load a
							set koatuu_code = prec.koatuu_code_suburb, id_region = prec.region, id_kotuu_district=prec.district
							where         koatuu_code = prec.koatuu_code_city
														and upper(a.advert_text) ~ vRegEx;
			 end if;
			 GET DIAGNOSTICS nCurrentUpdate := ROW_COUNT;
			 nRes := nRes + nCurrentUpdate;
			END LOOP;
			return nRes;
	 END;

$BODY$;


ALTER FUNCTION uvekon.set_suburb_by_koatuu(text) OWNER TO postgres;


--

/*	простановка koatuu_code пригорода по тексту объявления и справочнику uvekon.re_dic_koatuu_suburb.
*/
	 DECLARE
			prec     record;
			vRegEx   text;
			vRegExTrash   text;
			nRes     int :=0;
			nCurrentUpdate int;
	 BEGIN
			if (length(vkcodemask)=0 or (position('%' in vkcodemask)=0 and position('?' in vkcodemask)=0 ) ) then
				vkcodemask := vkcodemask || '%';
			end if;
			FOR prec IN (select t.*, k.district, k.coordinate_n, k.coordinate_e,
													((case when t.koatuu_code_city like '__00000000' then 100 else 0 end)
														+
													 (case when t.koatuu_code_suburb not like '__2__00000' and t.koatuu_code_suburb not like '__00000000' then 1
																 when t.koatuu_code_suburb like '__2__00000' then 2
																 when t.koatuu_code_suburb  like '__00000000' then 3
															 else 5
														end)
													)    as forder
									 from uvekon.re_dic_koatuu_suburb t, uvekon.re_dic_koatuu k
			 where t.koatuu_code_city like  vkcodemask
												 and  t.koatuu_code_city is not null
												 and  t.region <> '80'
															and addr_mask <> ''   and k.koatuu_code = t.koatuu_code_suburb
									 order by  t.region, t.koatuu_code_city, forder
		)
			LOOP
				vRegEx := uvekon.prepare_multimask_to_regex (prec.addr_mask);
				vRegExTrash := uvekon.prepare_multimask_to_regex (prec.trash_mask);
				if (length(vRegExTrash)<>0) then
							update uvekon.re_advert_load a
							set koatuu_code = prec.koatuu_code_suburb, id_region = prec.region, id_kotuu_district=prec.district,
									coordinate_n = prec.coordinate_n, coordinate_e = prec.coordinate_e
							where         koatuu_code = prec.koatuu_code_city
														and upper(a.advert_text) ~ vRegEx and not upper(a.advert_text) ~ vRegExTrash;
					else
							update uvekon.re_advert_load a
							set koatuu_code = prec.koatuu_code_suburb, id_region = prec.region, id_kotuu_district=prec.district
							where         koatuu_code = prec.koatuu_code_city
														and upper(a.advert_text) ~ vRegEx;
			 end if;
			 GET DIAGNOSTICS nCurrentUpdate := ROW_COUNT;
			 nRes := nRes + nCurrentUpdate;
			END LOOP;
			return nRes;
	 END;