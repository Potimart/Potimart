/*
 You may need to run before :

 echo "CREATE LANGUAGE plpgsql;" | psql chouette_test
 psql chouette_test < /usr/share/postgresql-8.3-postgis/lwpostgis.sql
 psql chouette_test < /usr/share/postgresql-8.3-postgis/spatial_ref_sys.sql
*/

SET STANDARD_CONFORMING_STRINGS TO ON;
BEGIN;
CREATE TABLE "ign_routes" (gid serial PRIMARY KEY,
"id" varchar(24),
"prec_plani" float8,
"prec_alti" float8,
"nature" varchar(19),
"numero" varchar(10),
"nom_rue_g" varchar(100),
"nom_rue_d" varchar(100),
"importance" varchar(2),
"cl_admin" varchar(14),
"gestion" varchar(3),
"mise_serv" varchar(10),
"it_vert" varchar(3),
"it_europ" varchar(10),
"fictif" varchar(3),
"franchisst" varchar(13),
"largeur" float8,
"nom_iti" varchar(70),
"nb_voies" int2,
"pos_sol" int2,
"sens" varchar(7),
"inseecom_g" varchar(5),
"inseecom_d" varchar(5),
"codevoie_g" varchar(9),
"codevoie_d" varchar(9),
"typ_adres" varchar(9),
"bornedeb_g" int8,
"bornedeb_d" int8,
"bornefin_g" int8,
"bornefin_d" int8,
"etat" varchar(15),
"z_ini" float8,
"z_fin" float8);
SELECT AddGeometryColumn('','ign_routes','the_geom','-1','MULTILINESTRING',4);
END;
