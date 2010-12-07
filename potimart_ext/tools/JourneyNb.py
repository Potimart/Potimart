# -*- coding: utf-8 -*-
"""
---------------------------------------------------------------------------
 Created on: 2010-07-13
 Author  : Luc DONNET
 Project : Potimart
 Company : (C) 2010 by Dryade, luc.donnet@dryade.net
 Usages  : display JourneyNb indicator
           Nombre de courses passant par un point d’arret sur une période.

 Updates:
     2010-11-23 by M. PENA (MobiGIS) : update interface
---------------------------------------------------------------------------
"""

# Import the PyQt and QGIS libraries
from PyQt4.QtCore import *
from PyQt4.QtGui import *
from qgis.core import *

# Import the code for the dialog
from JourneyNbDialog import JourneyNbDialog

import PotiTools
import psycopg2
import urllib, time, os.path, sys
import ConfigParser

# Set up current path, so that we know where to look for init file
currentPath = os.path.dirname( __file__ )

class JourneyNb:
    dbame = None
    host = None
    port = None
    user = None
    password = None
    srv_rails = None

    def __init__(self, iface):
        # Save reference to the QGIS interface
        self.iface = iface

        # create and show the dialog
        dlg = JourneyNbDialog()
        # show the dialog
        dlg.show()
        result = dlg.exec_()

        # See if OK was pressed
        if result == 1:

            # Récupération des paramètres saisis
            the_date = str(dlg.ui.dateEdit.date().toString("yyyy/MM/dd"))
            starthour = str(dlg.ui.startTimeEdit.time().toString())
            endhour = str(dlg.ui.endTimeEdit.time().toString())
            #the_date = "2009-08-15"; starthour = "05:00:00"; endhour = "21:00:00";
            print the_date + " - " + starthour + " - " + endhour

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
                cur.execute("""SELECT potimart.stoparea_journeynb_indicator(%s,%s,%s);""",(the_date, starthour, endhour))
                conn.commit()
            except:
               print "I can't drop our test database, check your isolation level."

            # Récupération du fichier .geojson copié en local
            # Dessertes_du_11-12-2007_entre_05:00:00_et_21:00:00
            dispDate = str(dlg.ui.dateEdit.date().toString("dd-MM-yyyy"))
##            cleanIndicatorName = dlg.ui.IndicatorsComboBox.currentText().replace(" ","_").replace(":","-").replace("/","-")
            normalIndicatorName = "Dessertes_du_" + dispDate + "_entre_" + starthour + "_et_" + endhour
            print "normalIndicatorName = " + QString.fromUtf8(normalIndicatorName)
            cleanIndicatorName = normalIndicatorName.replace(" ","_").replace(":","-").replace("/","-")
            print "cleanIndicatorName = " + QString.fromUtf8(cleanIndicatorName)

            distant_geojson_filename = cleanIndicatorName + '.geojson'
            print "distant_geojson_filename = " + QString.fromUtf8(distant_geojson_filename)

            local_geojson_filename = os.path.abspath(currentPath) + "/../geojson/" + cleanIndicatorName + '.geojson'
            print "local_geojson_filename = " + QString.fromUtf8(local_geojson_filename)

            urlAdress = 'http://' + self.srv_rails + '/stop_area_geos_by_indicator/' + str(normalIndicatorName) + '.geojson'
            print "urlAdress = " + QString.fromUtf8(urlAdress)

            urllib.urlretrieve(urlAdress, QString.fromUtf8(local_geojson_filename))
            time.sleep(1)

            # Envoi de la couche vers QGis :
            # QgsVectorLayer("/path/to/shapefile/file.shp", "layer_name_you_like", "ogr")
            layer = QgsVectorLayer(local_geojson_filename, "ARRETS - " + normalIndicatorName, "ogr")
            # displayLayer(layer, layer_name, qml_file):
            PotiTools.displayLayer(layer, "ARRETS - " + normalIndicatorName, os.path.abspath(currentPath) + "/../qml/journeynb.qml")
