# -*- coding: utf-8 -*-

from PyQt4.QtCore import *
from PyQt4.QtGui import *
from qgis.core import *

# Import the code for the dialog
from IndicatorsDialog import IndicatorsDialog

from xml.dom import minidom

import PotiTools
import urllib
import time
import ConfigParser
import psycopg2

import os.path, sys
# Set up current path, so that we know where to look for init file
currentPath = os.path.dirname( __file__ )

class Indicator:
    name = None

    def __init__(self):
        pass

class LineIndicators():
    __currentNode__ = None
    __indicatorList__ = None

    def __init__(self, iface):
        self.iface = iface

        # Récupération de l'adresse du serveur Rails
        config = ConfigParser.RawConfigParser()
        config.read(os.path.abspath(currentPath) + "/../Potimart.cfg")
        srv_rails = config.get("rails", "server")

        # Récupération fichier XML des indicateurs via un url REST
        try:
            self.xmlDoc = minidom.parse(urllib.urlopen('http://' + srv_rails + '/line_indicator_names.xml'))
        except IOError:
            QMessageBox.critical(self.iface.mainWindow(), "Connexion au serveur RAILS",\
              QString.fromUtf8("Echec de la connexion.\nVérifier que le serveur est lancé et que les paramètres de connexion sont bons (menu Options)."), "Ok")
            return

        # Récupération des noeuds des indicateurs
        self.getIndicators()

        # create and show the dialog
        dlg = IndicatorsDialog()

        # Alimente la combobox du dialogue avec la liste des lignes
        for line in self.__indicatorList__:
            dlg.ui.IndicatorsComboBox.addItem(line.name)

        # show the dialog
        dlg.show()
        result = dlg.exec_()

        # See if OK was pressed
        if result == 1:
            # Récupération du fichier .geojson copié en local
            cleanIndicatorName = dlg.ui.IndicatorsComboBox.currentText().replace(" ","_").replace(":","-").replace("/","-")
            print "cleanIndicatorName = " + QString.fromUtf8(cleanIndicatorName)

            distant_geojson_filename = cleanIndicatorName + ".geojson"
            print "distant_geojson_filename = " + QString.fromUtf8(distant_geojson_filename)
##            distant_geojson_filename = dlg.ui.IndicatorsComboBox.currentText() + '.geojson'

            local_geojson_filename = os.path.abspath(currentPath) + "/../geojson/" + cleanIndicatorName + '.geojson'
            print "local_geojson_filename = " + QString.fromUtf8(local_geojson_filename)
##            local_geojson_filename = os.path.abspath(currentPath) + "/../geojson/" + dlg.ui.IndicatorsComboBox.currentText().replace(":"," ") + "_" + time.strftime('%Y-%m-%d_%H-%M-%S',time.localtime()) + '.geojson'

            urlAdress = 'http://' + srv_rails + '/lines_by_indicator/' + str(dlg.ui.IndicatorsComboBox.currentText()) + '.geojson'
            print "urlAdress = " + QString.fromUtf8(urlAdress)
            urllib.urlretrieve(urlAdress, QString.fromUtf8(local_geojson_filename))
            time.sleep(1)
##            urllib.urlretrieve('http://' + srv_rails + '/lines_by_indicator/' + str(distant_geojson_filename), local_geojson_filename)
##            time.sleep(1)

            # Envoi de la couche vers QGis :
            # QgsVectorLayer("/path/to/shapefile/file.shp", "layer_name_you_like", "ogr")
            layer = QgsVectorLayer(local_geojson_filename, "LIGNES - " + dlg.ui.IndicatorsComboBox.currentText(), "ogr")
##            line_indicators = QgsVectorLayer(local_geojson_filename, dlg.ui.IndicatorsComboBox.currentText().replace(":"," ") + "_" + time.strftime('%Y-%m-%d_%H-%M-%S',time.localtime()) , "ogr")
            # displayLayer(layer, layer_name, qml_file):
            PotiTools.displayLayer(layer, "LIGNES - " + dlg.ui.IndicatorsComboBox.currentText(), os.path.abspath(currentPath) + "/../qml/" + dlg.ui.IndicatorsComboBox.currentText() + ".qml")


    def getRootElement(self):
        if self.__currentNode__ == None:
            self.__currentNode__ = self.xmlDoc.documentElement

        return self.__currentNode__


    def getIndicators(self):
        if self.__indicatorList__ != None:
            return

        self.__indicatorList__ = []

        for indicators in self.getRootElement().getElementsByTagName("line-indicator"):
                indic = Indicator()

                try:
                    indic.name = self.getText(indicators.getElementsByTagName("name")[0])

                except:
                    print 'The followings TAG is missing : name'

                self.__indicatorList__.append(indic)

        return self.__indicatorList__


    def getText(self, node):
        return node.childNodes[0].nodeValue


