\timing

insert into observation_fact_cgates
        (encounter_num,
     patient_num,
     concept_cd,
     start_date,
     modifier_cd,
     valtype_cd,
     tval_char,
     nval_num,
     units_cd,
     sourcesystem_cd,
     import_date,
     valueflag_cd,
     provider_id,
     location_cd,
     instance_num
        )
WITH patient AS (
    SELECT DISTINCT patient_num, sourcesystem_cd
            from i2b2demodata.patient_dimension
            where sourcesystem_cd in (select usubjid from tm_wz.wrk_clinical_data)
            ORDER BY patient_num)
SELECT patient.patient_num,
		   patient.patient_num,
		   i.c_basecode,
		   coalesce(a.date_timestamp, 'infinity'),
		   coalesce(a.modifier_cd, '@'),
		   a.data_type,
		   case when a.data_type = 'T' then a.data_value
				else 'E'  --Stands for Equals for numeric types
				end,
		   case when a.data_type = 'N' then a.data_value::numeric
				else null --Null for text types
				end,
                   a.units_cd,
		   a.study_id, 
		   current_timestamp, 
		   '@',
		   '@',
		   '@',
                   1
	from tm_wz.wrk_clinical_data a
		,tm_wz.wt_trial_nodes t
		,i2b2metadata.i2b2 i
        ,patient
	where a.usubjid = patient.sourcesystem_cd
	  and coalesce(a.category_cd,'@') = coalesce(t.category_cd,'@')
	  and coalesce(a.data_label,'**NULL**') = coalesce(t.data_label,'**NULL**')
	  and coalesce(a.visit_name,'**NULL**') = coalesce(t.visit_name,'**NULL**')
	  and case when a.data_type = 'T' then a.data_value else '**NULL**' end = coalesce(t.data_value,'**NULL**')
	  and t.leaf_node = i.c_fullname
	  and not exists		-- don't insert if lower level node exists
		 (select 1 from tm_wz.wt_trial_nodes x
		 where (substr(x.leaf_node, 1, tm_cz.instr(x.leaf_node, '\', -2))) = t.leaf_node)
	  and a.data_value is not null
;
