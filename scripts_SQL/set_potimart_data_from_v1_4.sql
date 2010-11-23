-- Localisation des stoparea sur la base des longitudes/latitudes 
truncate table potimart.stop_area_geo_indicators;
truncate table potimart.stop_area_geos;
INSERT INTO potimart.stop_area_geos  ("name" , area_type ,  stoparea_id ,  the_geom )
  SELECT  "name", areatype, id, PointFromText('POINT(' || longitude || ' ' || latitude || ')',4326)
  FROM stoparea
  WHERE longitude is not null
  AND latitude is not null;

truncate table potimart.line_indicators;
truncate table potimart.service_links ;
select potimart.insert_servicelinks(t.id) from journeypattern t order by t.id;


