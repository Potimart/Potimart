-- insertion des donnees dans la table pathlinks cree par Luc
--   Cette table semble etre une table contenant les missions
CREATE OR REPLACE FUNCTION potimart.insert_servicelinks(journeypattern_id bigint)  returns text AS $$
declare
stop_area RECORD;
query TEXT;
long_start double precision ;
lat_start double precision;
id_startarea integer;

begin
lat_start=0.0;

-- LOOP itineraire
FOR stop_area IN SELECT DISTINCT sa.longitude,sa.latitude,sa.id as sa_id, ln.id as lnid, rt.id as rtid, "position"
       FROM vehiclejourney vj,vehiclejourneyatstop vjat, stoppoint sp, stoparea sa, route rt, line ln
       WHERE vj.journeypatternid = journeypattern_id
           AND   vjat.vehiclejourneyid=vj.id
           AND   sp.id = vjat.stoppointid
           AND   sp.stopareaid = sa.id
           AND   sp.routeid = rt.id
           AND   rt.lineid = ln.id
           -- On ne prend pas les points qui font partie des lignes mal construites, ie celles qui
           --    possèdent un point d'arret dans les choux (longitude < 0 par exemple)
           --AND   sp.iditineraire NOT IN (SELECT DISTINCT rtbis.id FROM route rtbis, stoppoint spbis, stoparea sabis
           --                      WHERE spbis.idphysique = sabis.id
           --                      AND spbis.iditineraire = rtbis.id
           --                      AND sabis.latitude <30)
           ORDER BY "position"
LOOP

      -- RAISE NOTICE 'mission = %', journeypattern_id;
      -- IF first point has already been handled
      IF lat_start <> 0.0 THEN
        --query := 'select nextval(''missionlink_sequence'');';
        --RAISE NOTICE 'stop area id %', stop_area.sa_id;
        query := 'INSERT INTO potimart.service_links (line_id , route_id , journeypattern_id , stoparea_start_id , stoparea_arrival_id , the_geom) 
                         VALUES ('|| stop_area.lnid || ','  || stop_area.rtid || ','  || journeypattern_id  || ','  || id_startarea || ','  || stop_area.sa_id || ',
                                 LinestringFromText(' || '''LINESTRING(' || long_start || ' ' || lat_start || ',' || stop_area.longitude || ' ' || stop_area.latitude ||')''' || ', 4326 ) );';

        RAISE NOTICE 'request %', query;
        EXECUTE query;

      END IF;
      -- Keep point's data : used when next point is considered
      lat_start = stop_area.latitude;
      long_start = stop_area.longitude;
      id_startarea = stop_area.sa_id;
end loop;
RETURN 'Mission ' || journeypattern_id || ' : servicelink inserted' ;
end;
$$
LANGUAGE 'plpgsql'