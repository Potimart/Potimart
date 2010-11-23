-- Schema: potimart

CREATE SCHEMA potimart
  AUTHORIZATION chouette;

-- Sequence: potimart.servicelinks_id_seq

-- DROP SEQUENCE potimart.servicelinks_id_seq;

CREATE SEQUENCE potimart.servicelinks_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 2147
  CACHE 1;
ALTER TABLE potimart.servicelinks_id_seq OWNER TO chouette;


-- DROP TABLE potimart.service_links;

CREATE TABLE potimart.service_links
(
  id integer NOT NULL DEFAULT nextval('potimart.servicelinks_id_seq'::regclass),
  line_id integer,
  route_id integer,
  journeypattern_id integer,
  stoparea_start_id integer,
  stoparea_arrival_id integer,
  departure_time timestamp without time zone,
  arrival_time timestamp without time zone,
  duration integer,
  created_at timestamp without time zone,
  updated_at timestamp without time zone,
  the_geom geometry,
  main_journey_pattern boolean,
  CONSTRAINT pathlinks_pkey PRIMARY KEY (id),
  CONSTRAINT enforce_dims_the_geom CHECK (ndims(the_geom) = 2),
  CONSTRAINT enforce_geotype_the_geom CHECK (geometrytype(the_geom) = 'LINESTRING'::text OR the_geom IS NULL),
  CONSTRAINT enforce_srid_the_geom CHECK (srid(the_geom) = 4326)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE potimart.service_links OWNER TO chouette;



-- Table: potimart.stop_area_geos
--DROP TABLE potimart.stop_area_geos;
CREATE TABLE potimart.stop_area_geos
(
  id serial NOT NULL,
  "name" character varying(255),
  area_type character varying(255),
  stoparea_id integer,
  created_at timestamp without time zone,
  updated_at timestamp without time zone,
  the_geom geometry,
  CONSTRAINT stop_area_geos_pkey PRIMARY KEY (id),
  CONSTRAINT enforce_dims_the_geom CHECK (ndims(the_geom) = 2),
  CONSTRAINT enforce_geotype_the_geom CHECK (geometrytype(the_geom) = 'POINT'::text OR the_geom IS NULL),
  CONSTRAINT enforce_srid_the_geom CHECK (srid(the_geom) = 4326)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE potimart.stop_area_geos OWNER TO chouette;

-- Table: potimart.stop_area_geo_indicators

-- DROP TABLE potimart.stop_area_geo_indicators;

CREATE TABLE potimart.stop_area_geo_indicators
(
  id serial NOT NULL,
  "name" character varying(255),
  "value" integer,
  stop_area_geo_id integer,
  start_date date,
  end_date date,
  created_at timestamp without time zone,
  updated_at timestamp without time zone,
  CONSTRAINT stop_area_geo_indicators_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE potimart.stop_area_geo_indicators OWNER TO chouette;

-- Index: potimart.index_stop_area_geo_indicators_on_name

-- DROP INDEX potimart.index_stop_area_geo_indicators_on_name;

CREATE INDEX index_stop_area_geo_indicators_on_name
  ON potimart.stop_area_geo_indicators
  USING btree
  (name);


-- DROP TABLE potimart.line_indicators;

CREATE TABLE potimart.line_indicators
(
  id serial NOT NULL,
  "name" character varying(255),
  "value" integer,
  line_id integer,
  start_date date,
  end_date date,
  created_at timestamp without time zone,
  updated_at timestamp without time zone,
  CONSTRAINT line_indicators_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE potimart.line_indicators OWNER TO chouette;

-- Index: potimart.index_line_indicators_on_name

-- DROP INDEX potimart.index_line_indicators_on_name;

CREATE INDEX index_line_indicators_on_name
  ON potimart.line_indicators
  USING btree
  (name);



