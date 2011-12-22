# -*- coding: utf-8 -*-

from PyQt4.QtCore import *
from PyQt4.QtGui import *
from qgis.core import *

import os.path
currentPath = os.path.dirname( __file__ )

import urllib
import ConfigParser

def setPostGresDataSource(schema, table_name, geom_column, where_clause):
    config = ConfigParser.RawConfigParser()
    config.read(os.path.abspath(currentPath) + "/../Potimart.cfg")

    uri = QgsDataSourceURI()
    # set host name, port, database name, username and password
    uri.setConnection(  config.get("postgres", "host"),\
                        config.get("postgres", "port"),\
                        config.get("postgres", "dbname"),\
                        config.get("postgres", "username"),\
                        config.get("postgres", "password"))

    # set database schema, table name, geometry column and optionaly subset (WHERE clause)
    uri.setDataSource(schema, table_name, geom_column, where_clause)

    return uri


def displayLayer(layer, layer_name, qml_file):
    # Couche valide
    if layer.isValid():

        # Test du fichier de symbologie
        if qml_file <> "":
            layer_qml_loaded = layer.loadNamedStyle(qml_file)
            if layer_qml_loaded[1]:
              print __file__ + QString.fromUtf8(" : Symbology loaded for layer " + layer_name)
            else:
              print __file__ + " : ERROR : failed to load symbology for layer " + layer_name + " !"

        print __file__ + " : Layer " +  layer_name + " loaded."
        QgsMapLayerRegistry.instance().addMapLayer(layer)

    # Couche invalide
    else:
      print __file__ + QString.fromUtf8(" : ERROR : " + layer_name + "' is an invalid layer !")

