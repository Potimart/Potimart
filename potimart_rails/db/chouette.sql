CREATE SCHEMA chouette;

CREATE SEQUENCE chouette.line_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

CREATE TABLE chouette.line (
    ptnetworkid bigint,
    companyid bigint,
    objectid character varying(255),
    objectversion bigint,
    creationtime timestamp without time zone,
    creatorid character varying(255),
    name character varying(255),
    number character varying(255),
    publishedname character varying(255),
    transportmodename character varying(255),
    registrationnumber character varying(255),
    comment character varying(255),
    id bigint NOT NULL DEFAULT nextval('chouette.line_seq') PRIMARY KEY
);

ALTER TABLE ONLY chouette.line
    ADD CONSTRAINT line_objectid_key UNIQUE (objectid);
ALTER TABLE ONLY chouette.line
    ADD CONSTRAINT line_registrationnumber_key UNIQUE (registrationnumber);