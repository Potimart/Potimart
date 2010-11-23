-- Function: potimart.stoparea_journeynb_indicator(text, text, text)

-- DROP FUNCTION potimart.stoparea_journeynb_indicator(text, text, text);

CREATE OR REPLACE FUNCTION potimart.stoparea_journeynb_indicator(the_date text, starthour text, endhour text)
  RETURNS text AS
$BODY$
declare
stop_area RECORD;
query TEXT;
journey_nb integer;

stopareageoindicator_id integer;
stopareageos_id integer;
indicator_name TEXT;
next_index integer;


begin
indicator_name := 'Dessertes_du_' || to_char(to_date('' || the_date || '','YYYY-MM-DD'), 'DD-MM-YYYY') || '_entre_' || starthour || '_et_' || endhour;



--suppprimer les indicateurs qui existent déjà
delete from potimart.stop_area_geo_indicators where "name" =indicator_name;

FOR stop_area IN SELECT id FROM chouette.stoparea WHERE areatype='Quay' OR areatype='BoardingPosition' LOOP
             -- areatype='Quay' OR areatype='BoardingPosition' ORDER BY id LOOP


   --------
   ---- CREATION de l'indicateur pour le stoparea : new record dans table stop_area_geo_indicators
   --------
   
   -- get the associated stop_area_geos record id
   query := 'SELECT id  FROM potimart.stop_area_geos WHERE stoparea_id = ' ||stop_area.id;
   EXECUTE query INTO stopareageos_id;
   -- RAISE NOTICE 'stop_area_geos id= %', stopareageos_id || ' is associated with stoparea id=' || stop_area.id;

   -- Create the indicator for the current stop area, value = 0
   INSERT INTO potimart.stop_area_geo_indicators ("name", "value", stop_area_geo_id)
         VALUES (indicator_name, 0, stopareageos_id);

   --------
   ---- FIN CREATION de l'indicateur pour le stoparea
   --------


   --------
   ---- Valorisation de l'idicateur journeynb pour le stoparea
   --------

   -- Requete pour les horaires définis sur une plage de jours
   query := 'SELECT count(*)
           FROM vehiclejourney vj, vehiclejourneyatstop vjat, stoppoint sp, timetable tm, timetable_period tmp, timetablevehiclejourney tmvj
           WHERE  vjat.vehiclejourneyid=vj.id
           AND    vjat.departuretime  > to_timestamp(''' || starthour ||''' ,''HH24:MI:SS'')::time without time zone
           AND    vjat.arrivaltime  < to_timestamp(''' || endhour ||''',''HH24:MI:SS'')::time without time zone
           AND    vjat.stoppointid = sp.id
           AND    sp.stopareaid = ' ||stop_area.id ||'
           AND    tmp.timetableid = tmvj.timetableid
           AND    tmvj.vehiclejourneyid = vj.id
           AND   (to_date(to_date('''||the_date||''',''YYYY-MM-DD'')::text,''YYYY-MM-DD'')) between tmp.periodstart and tmp.periodend
           AND (
	          (to_char(to_date('''||the_date||''',''YYYY-MM-DD''),''D'') = ''1'' AND ((tm.intdaytypes & 256)=256) ) -- dimanche
               OR (to_char(to_date('''||the_date||''',''YYYY-MM-DD''),''D'') = ''2'' AND ((tm.intdaytypes & 4)  =4  ) ) -- lundi
               OR (to_char(to_date('''||the_date||''',''YYYY-MM-DD''),''D'') = ''3'' AND ((tm.intdaytypes & 8)  =8  ) ) -- mardi
               OR (to_char(to_date('''||the_date||''',''YYYY-MM-DD''),''D'') = ''4'' AND ((tm.intdaytypes & 16) =16 ) ) -- mercredi
               OR (to_char(to_date('''||the_date||''',''YYYY-MM-DD''),''D'') = ''5'' AND ((tm.intdaytypes & 32) =32 ) ) -- jeudi
               OR (to_char(to_date('''||the_date||''',''YYYY-MM-DD''),''D'') = ''6'' AND ((tm.intdaytypes & 64) =64 ) ) -- vendredi
               OR (to_char(to_date('''||the_date||''',''YYYY-MM-DD''),''D'') = ''7'' AND ((tm.intdaytypes & 128)=128) ) -- samedi
             )';

    EXECUTE query into journey_nb;
    
    -- RAISE NOTICE 'stop_area id, %', stop_area.id || ' journeynb=' || journey_nb;
    UPDATE potimart.stop_area_geo_indicators
      SET "value"="value"+journey_nb
      WHERE stop_area_geo_id=stopareageos_id
      AND   "name" = indicator_name ;

    -- Requete pour les horaires définis spécifiquement pour un jour donné
    query := 'SELECT count(*)
           FROM stoppoint sp, timetable_date tmd, timetablevehiclejourney tmvj, vehiclejourney vj, vehiclejourneyatstop vjat
           WHERE  tmvj.timetableid = tmd.timetableid
             AND    tmd.date = to_date(to_date('''||the_date||''',''YYYY-MM-DD'')::text,''YYYY-MM-DD'')
             AND    vj.id= tmvj.vehiclejourneyid
             AND    vjat.stoppointid = sp.id
             AND    sp.stopareaid = ' ||stop_area.id ||'
             AND    vjat.vehiclejourneyid=vj.id
             AND    vjat.departuretime  > to_timestamp(''' || starthour ||''' ,''HH24:MI:SS'')::time without time zone
             AND    vjat.arrivaltime  < to_timestamp(''' || endhour ||''',''HH24:MI:SS'')::time without time zone';

    EXECUTE query into journey_nb;
    --RAISE NOTICE 'query= %s', query;
    
    RAISE NOTICE 'stoparea id= %', stop_area.id || ' journey_nb=' || journey_nb;

    UPDATE potimart.stop_area_geo_indicators
      SET "value"="value"+journey_nb
      WHERE stop_area_geo_id=stopareageos_id
      AND   "name" = indicator_name ;


 END LOOP;
RETURN 'journeynb is updated for all stoparea';
end;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION potimart.stoparea_journeynb_indicator(text, text, text) OWNER TO chouette;
