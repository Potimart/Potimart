# -*- coding: utf-8 -*-

from PyQt4.QtCore import *
from qgis.core import *

import PotiTools
import psycopg2
import ConfigParser

import os.path
currentPath = os.path.dirname( __file__ )

class StopAreaGeos():
    dbame = None
    host = None
    port = None
    user = None
    password = None
    srv_rails = None

    def __init__(self, iface):
        self.iface = iface

        # Récupération des données de connexion
        config = ConfigParser.RawConfigParser()
        config.read(os.path.abspath(currentPath) + "/../Potimart.cfg")
        self.dbame = config.get("postgres", "dbname")
        self.host = config.get("postgres", "host")
        self.port = config.get("postgres", "port")
        self.user = config.get("postgres", "username")
        self.password = config.get("postgres", "password")
        self.srv_rails = config.get("rails", "server")

        # Connexion à la base de donnée PostgreSQL via psycopg2
        try:
            connect_string = "dbname='" + self.dbame + "' host='" + self.host + "' port='" + self.port + "' user='" + self.user + "' password='" + self.password + "'"
            print connect_string
            conn = psycopg2.connect(connect_string)
            print "Connexion via Psycopg2 : OK"
        except:
            print "Impossible de se connecter à la base de donnée."

        # Création d'un curseur sur la base
        cur = conn.cursor()

        # Exécution de la requète
        try:
            cur.execute("" " SELECT DISTINCT stop_area_geos.area_type FROM potimart.stop_area_geos ;" "")
        except:
           print "I can't drop our test database, check your isolation level."

        for areaType in cur.fetchall():
            areaTypeName = str(areaType).replace("(", "").replace(")", "").replace(",", "").replace("'", "")
            print areaTypeName

            if areaTypeName == "StopPlace":
                # Load layer
                db = PotiTools.setPostGresDataSource("potimart", "stop_area_geos", "the_geom", "area_type = '" + areaTypeName + "'")
                layer = QgsVectorLayer(db.uri(), areaTypeName, "postgres")
                PotiTools.displayLayer(layer, areaTypeName, os.path.abspath(currentPath) + "/../qml/stop_place.qml")

            elif areaTypeName == "CommercialStopPoint":
                # Load layer
                db = PotiTools.setPostGresDataSource("potimart", "stop_area_geos", "the_geom", "area_type = '" + areaTypeName + "'")
                layer = QgsVectorLayer(db.uri(), areaTypeName, "postgres")
                PotiTools.displayLayer(layer, areaTypeName, os.path.abspath(currentPath) + "/../qml/commercial_stop_points.qml")

            elif areaTypeName == "BoardingPosition":
                # Load layer
                db = PotiTools.setPostGresDataSource("potimart", "stop_area_geos", "the_geom", "area_type = '" + areaTypeName + "'")
                layer = QgsVectorLayer(db.uri(), areaTypeName, "postgres")
                PotiTools.displayLayer(layer, areaTypeName, os.path.abspath(currentPath) + "/../qml/boarding_positions.qml")

            elif areaTypeName == "Quay":
                # Load layer
                db = PotiTools.setPostGresDataSource("potimart", "stop_area_geos", "the_geom", "area_type = '" + areaTypeName + "'")
                layer = QgsVectorLayer(db.uri(), areaTypeName, "postgres")
                PotiTools.displayLayer(layer, areaTypeName, os.path.abspath(currentPath) + "/../qml/quay.qml")
