# -*- coding: utf-8 -*-

from PyQt4 import QtCore, QtGui

from PyQt4.QtCore import *
from PyQt4.QtGui import *
from qgis.core import *

# Import the code for the dialog
from DisplayLinesDialog import DisplayLinesDialog

from xml.dom import minidom
import urllib
import time
import sys
import ConfigParser

import os.path
currentPath = os.path.dirname( __file__ )

import PotiTools
import psycopg2

class Line:
    id = None
    number = None
    name = None

    def __init__(self):
        pass

class DisplayLines:
    __currentNode__ = None
    __lineList__ = None
    dbame = None
    host = None
    port = None
    user = None
    password = None
    srv_rails = None

    # create the dialog
    dlg = DisplayLinesDialog()

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

        # Récupération fichier XML des lignes de bus via un url REST
        try:
            self.xmlDoc = minidom.parse(urllib.urlopen('http://' + self.srv_rails + '/lines.xml'))
        except IOError:
            QMessageBox.critical(self.iface.mainWindow(), "Connexion au serveur RAILS",\
            QString.fromUtf8("Echec de la connexion.\nVérifier que le serveur est lancé et que les paramètres de connexion sont bons (menu Options)."), "Ok")
            return

        # Récupération des lignes
        self.getLines()

        # Mise à jour de la liste déroulante des missions à partir de celle des lignes
        QtCore.QObject.connect(self.dlg.ui.LinesComboBox, QtCore.SIGNAL("currentIndexChanged(int)"), self.UpdateMissionsComboBox)

        # Alimente la combobox du dialogue avec la liste des lignes
        self.dlg.ui.LinesComboBox.clear()
        for line in self.__lineList__:
            self.dlg.ui.LinesComboBox.addItem(line.name)


        # Affichage du dialogue
        self.dlg.show()

        # See if OK was pressed
        result = self.dlg.exec_()
        if result == 1:

            # Identification de la ligne sélectionnée
            indexLineToDisplay = self.dlg.ui.LinesComboBox.currentIndex()
            line_id = str(self.__lineList__[indexLineToDisplay].number)
            print "line_id = " + str(line_id)

            #---------------------------------------------------------------------
            # Affichage de toutes les lignes (check-box), dans les deux directions
            #---------------------------------------------------------------------
            if self.dlg.ui.displayAllCheckBox.isChecked():
                self.displayAllLines()

            #--------------------------------------------
            # Affichage d'une seule ligne (check-box)
            #--------------------------------------------
            else:

                #---------------------------------
                # Affichage d'une seule mission
                #---------------------------------
                if self.dlg.ui.displayMissonCheckBox.isChecked():
                    # Identification de la ligne sélectionnée
                    indexMissionToDisplay = self.dlg.ui.MissionsComboBox.currentIndex()
                    print "indexMissionToDisplay = " + str(indexMissionToDisplay)
                    idMission = str(self.dlg.ui.MissionsComboBox.currentText()).split()[0]
                    print "idMission = " + str(self.dlg.ui.MissionsComboBox.currentText()).split()[0]
##                    QMessageBox.critical(self.iface.mainWindow(), "idMission", QString.fromUtf8(idMission), "Ok")
                    self.displaySelectedMission(line_id, idMission)

                else:
                    # Requètes SENS DE LA LIGNE : ALLER / RETOUR /LES DEUX
                    # Les 2 SENS
                    if self.dlg.ui.bothRadioButton.isChecked():
                        self.displayOneLineAllDirections(indexLineToDisplay)


                    # ALLER ou RETOUR
                    else :
                        # Récupération du sens de la ligne (checkboxs)
                        if self.dlg.ui.fwRadioButton.isChecked():
                            sens = "A"
                        elif self.dlg.ui.bwRadioButton.isChecked():
                            sens = "R"

                        self.displayOneLineOneDirection(indexLineToDisplay, sens)


    def displaySelectedMission(self, line_id, idMission):
        print "line_id = " + str(line_id)
        # service_links
        whereClause = "journeypattern_id = " + str(idMission)
        db = PotiTools.setPostGresDataSource("potimart", "service_links", "the_geom", whereClause)
        layer = QgsVectorLayer(db.uri(), QString.fromUtf8("LIGNE " + line_id + " - Mission " + idMission), "postgres")
        PotiTools.displayLayer(layer, "LIGNE " + line_id + " - Mission " + idMission, os.path.abspath(currentPath) + "/../qml/missions.qml")

        # Stopareas
        whereClause = "stoparea_id IN ("
        whereClause += "SELECT DISTINCT stop_area_geos.stoparea_id "
        whereClause += "FROM potimart.stop_area_geos, potimart.service_links "
        whereClause += "WHERE service_links.journeypattern_id = " + str(idMission) + " AND "
        whereClause += "(stop_area_geos.stoparea_id = service_links.stoparea_start_id OR "
        whereClause += "stop_area_geos.stoparea_id = service_links.stoparea_arrival_id)"
        whereClause += ")"
        db = PotiTools.setPostGresDataSource("potimart", "stop_area_geos", "the_geom", whereClause)
        layer = QgsVectorLayer(db.uri(), QString.fromUtf8("ARRETS " + line_id + " - Mission " + idMission), "postgres")
        PotiTools.displayLayer(layer, "ARRETS " + line_id + " - Mission " + idMission, os.path.abspath(currentPath) + "/../qml/stop_areas.qml")


    def UpdateMissionsComboBox(self):
        indexLineToDisplay = self.dlg.ui.LinesComboBox.currentIndex()
        self.getMissionList(self.__lineList__[indexLineToDisplay].id)


    def getMissionList(self, line_id):
        # Connexion à la base de donnée PostgreSQL via psycopg2
        try:
            connect_string = "dbname='" + self.dbame + "' host='" + self.host + "' port='" + self.port + "' user='" + self.user + "' password='" + self.password + "'"
            conn = psycopg2.connect(connect_string)
            print "Connexion via Psycopg2 : OK"
        except:
            print "Impossible de se connecter à la base de donnée."

        # Création d'un curseur sur la base
        cur = conn.cursor()

        # Exécution de la requète
        try:
            cur.execute("" " SELECT DISTINCT service_links.journeypattern_id, journeypattern.name, route.direction \
                             FROM   potimart.service_links, chouette.journeypattern, chouette.route \
                             WHERE  service_links.journeypattern_id = journeypattern.id AND \
                                    service_links.route_id = route.id AND \
                                    service_links.line_id = " + str(line_id) + " ;" "")

        except:
           print "I can't drop our test database, check your isolation level."

        # Alimente la combobox du dialogue avec la liste des missions
        self.dlg.ui.MissionsComboBox.clear()
        for mission in cur.fetchall():
##            self.dlg.ui.MissionsComboBox.addItem(str(mission).replace("(","").replace(")","").replace(",","") + " - " + sens + " - ")
            self.dlg.ui.MissionsComboBox.addItem(str(mission).replace("(","").replace(")","").replace(",",""))


    def displayOneLineOneDirection(self, indexLineToDisplay, sens):
        # service_links
        pathlink_query =  "SELECT DISTINCT service_links.id "
        pathlink_query += "FROM potimart.service_links, chouette.route "
        pathlink_query += "WHERE service_links.route_id = route.id AND "
        pathlink_query += "route.wayback = '" + sens + "' AND "
        pathlink_query += "line_id = " + str(self.__lineList__[indexLineToDisplay].id)
        whereClause = "id IN (" + pathlink_query + ")"
        db = PotiTools.setPostGresDataSource("potimart", "service_links", "the_geom", whereClause)
        layer = QgsVectorLayer(db.uri(), QString.fromUtf8("LIGNE " + str(self.__lineList__[indexLineToDisplay].number)) + " - " + sens, "postgres")
        PotiTools.displayLayer(layer, "LIGNE " + str(self.__lineList__[indexLineToDisplay].number) + " - " + sens, os.path.abspath(currentPath) + "/../qml/service_links.qml")

        # Stopareas
        stoparea_query =  "SELECT DISTINCT stop_area_geos.stoparea_id "
        stoparea_query += "FROM potimart.stop_area_geos, potimart.service_links, chouette.route "
        stoparea_query += "WHERE service_links.line_id = " + str(self.__lineList__[indexLineToDisplay].id) + " AND "
        stoparea_query += "(stop_area_geos.stoparea_id = service_links.stoparea_start_id OR "
        stoparea_query += "stop_area_geos.stoparea_id = service_links.stoparea_arrival_id) AND "
        stoparea_query += "service_links.route_id = route.id AND route.wayback = '" + sens + "'"
        whereClause = "stoparea_id IN (" + stoparea_query + ")"
        db = PotiTools.setPostGresDataSource("potimart", "stop_area_geos", "the_geom", whereClause)
        layer = QgsVectorLayer(db.uri(), QString.fromUtf8("ARRETS " + str(self.__lineList__[indexLineToDisplay].number) + " - " + sens), "postgres")
        PotiTools.displayLayer(layer, "ARRETS " + str(self.__lineList__[indexLineToDisplay].number) + " - " + sens, os.path.abspath(currentPath) + "/../qml/stop_areas.qml")


    def displayOneLineAllDirections(self, indexLineToDisplay):
       # service_links
        whereClause = "line_id = " + str(self.__lineList__[indexLineToDisplay].id)
        db = PotiTools.setPostGresDataSource("potimart", "service_links", "the_geom", whereClause)
        layer = QgsVectorLayer(db.uri(), QString.fromUtf8("LIGNE " + str(self.__lineList__[indexLineToDisplay].number) + " - AR"), "postgres")
        PotiTools.displayLayer(layer, "LIGNE " + str(self.__lineList__[indexLineToDisplay].number) + " - AR", os.path.abspath(currentPath) + "/../qml/service_links.qml")

        # Stopareas
        whereClause = "stoparea_id IN ("
        whereClause += "SELECT DISTINCT stop_area_geos.stoparea_id "
        whereClause += "FROM potimart.stop_area_geos, potimart.service_links "
        whereClause += "WHERE service_links.line_id = " + str(self.__lineList__[indexLineToDisplay].id) + " AND "
        whereClause += "(stop_area_geos.stoparea_id = service_links.stoparea_start_id OR "
        whereClause += "stop_area_geos.stoparea_id = service_links.stoparea_arrival_id)"
        whereClause += ")"
        db = PotiTools.setPostGresDataSource("potimart", "stop_area_geos", "the_geom", whereClause)
        layer = QgsVectorLayer(db.uri(), QString.fromUtf8("ARRETS " + str(self.__lineList__[indexLineToDisplay].number) + " - AR"), "postgres")
        PotiTools.displayLayer(layer, "ARRETS " + str(self.__lineList__[indexLineToDisplay].number) + " - AR", os.path.abspath(currentPath) + "/../qml/stop_areas.qml")


    def displayAllLines(self):
        # service_links
        db = PotiTools.setPostGresDataSource("potimart", "service_links", "the_geom", \
                "id IN (SELECT DISTINCT service_links.id FROM potimart.service_links)")
        layer = QgsVectorLayer(db.uri(), QString.fromUtf8("LIGNES"), "postgres")
        PotiTools.displayLayer(layer, "LIGNES", os.path.abspath(currentPath) + "/../qml/service_links.qml")

        # Stopareas: tous les arrêts même ceux n'appartenant pas à aucunes lignes (arrêts orphelins)
        db = PotiTools.setPostGresDataSource("potimart", "stop_area_geos", "the_geom", \
                "stoparea_id in (SELECT DISTINCT stop_area_geos.stoparea_id FROM potimart.stop_area_geos)")
        layer = QgsVectorLayer(db.uri(), QString.fromUtf8("ARRETS"), "postgres")
        PotiTools.displayLayer(layer, "ARRETS", os.path.abspath(currentPath) + "/../qml/stop_areas.qml")

    def getRootElement(self):
        if self.__currentNode__ == None:
            self.__currentNode__ = self.xmlDoc.documentElement

        return self.__currentNode__


    def getLines(self):
        if self.__lineList__ != None:
            return

        self.__lineList__ = []

        for lines in self.getRootElement().getElementsByTagName("line"):
                l = Line()

                try:
                    l.id = self.getText(lines.getElementsByTagName("id")[0])
                    l.number = self.getText(lines.getElementsByTagName("number")[0])
                    l.name = self.getText(lines.getElementsByTagName("name")[0])
##                    print "l.id = " + l.id + " - l.number = " + l.number + " - l.name = " + l.name
                except:
                    print 'One of the followings TAGS is missing : id, number, name'

                self.__lineList__.append(l)

        return self.__lineList__


    def getText(self, node):
        return node.childNodes[0].nodeValue
