# -*- coding: utf-8 -*-
"""
---------------------------------------------------------------------------
 Created on: 2010-11-23
 Author  : M. PENA
 Project : Potimart
 Company : (C) 2010 by MobIGIS, contact@mobigis.fr
 Usages  : Test and configure connexions with Rails and PostGis servers.

 Updates:
---------------------------------------------------------------------------
"""

from PyQt4.QtCore import *
from PyQt4.QtGui import *
from qgis.core import *

# Import the code for the dialog
from OptionsDialog import OptionsDialog

import os.path
currentPath = os.path.dirname( __file__ )

import ConfigParser
import urllib
import PotiTools

class Options:

    def __init__(self, iface):
        self.iface = iface

        # Création du dialogue
        dlg = OptionsDialog()

        # Lecture du fichier de config
        config = ConfigParser.RawConfigParser()
        print os.path.abspath(currentPath) + "/Potimart.cfg"
        config.read(os.path.abspath(currentPath) + "/Potimart.cfg")
        print config._sections

        # Mise à jour des champs de la fenêtre d'options
        dlg.ui.hostLineEdit.setText(config.get("postgres", "host"))
        dlg.ui.portLineEdit.setText(config.get("postgres", "port"))
        dlg.ui.dbnameLineEdit.setText(config.get("postgres", "dbname"))
        dlg.ui.usernameLineEdit.setText(config.get("postgres", "username"))
        dlg.ui.passwordLineEdit.setText(config.get("postgres", "password"))
        dlg.ui.railsLineEdit.setText(config.get("rails", "server"))

        # Affichage du dialogue
        dlg.show()

        # See if OK was pressed
        result = dlg.exec_()
        if result == 1:
            # Test de connexion à la base PostgreSQL
            uri = QgsDataSourceURI()
            # set host name, port, database name, username and password
            uri.setConnection(  str(dlg.ui.hostLineEdit.text()),\
                                str(dlg.ui.portLineEdit.text()),\
                                str(dlg.ui.dbnameLineEdit.text()),\
                                str(dlg.ui.usernameLineEdit.text()),\
                                str(dlg.ui.passwordLineEdit.text())     )
            uri.setDataSource("potimart", "service_links", "the_geom", "")
            layer = QgsVectorLayer(uri.uri(), "Test", "postgres")

            if layer.isValid():
                QMessageBox.information(self.iface.mainWindow(), QString.fromUtf8("Test de connexion à la base PostgreSQL"), QString.fromUtf8("Connexion à la base PostgreSQL réussi."), "Ok")
                # Mise à jour des infos de connexions
                config.set("postgres", "host", str(dlg.ui.hostLineEdit.text()))
                config.set("postgres", "port", str(dlg.ui.portLineEdit.text()))
                config.set("postgres", "dbname", str(dlg.ui.dbnameLineEdit.text()))
                config.set("postgres", "username", str(dlg.ui.usernameLineEdit.text()))
                config.set("postgres", "password", str(dlg.ui.passwordLineEdit.text()))
                config.set("rails", "server", str(dlg.ui.railsLineEdit.text()))

                # MAJ du fichier de config
                configFile = open(os.path.abspath(currentPath) + "/Potimart.cfg", 'w')
                config.write(configFile)
                configFile.close()
            else:
                QMessageBox.critical(self.iface.mainWindow(), QString.fromUtf8("Test de connexion à la base PostgreSQL"),\
                    QString.fromUtf8("Echec de la connexion, vérifier les paramètres entrés."), "Ok")

            # Test de connexion au serveur Rails (localhost:3000 par exemple)
            srv_rails = config.get("rails", "server")
            try:
                url_rails = urllib.urlopen('http://' + srv_rails + '/lines.xml')
                QMessageBox.information(self.iface.mainWindow(), QString.fromUtf8("Test de connexion au serveur RAILS"), \
                    QString.fromUtf8("Connexion au serveur RAILS réussi."), "Ok")
            except IOError:
                QMessageBox.critical(self.iface.mainWindow(), "Test de connexion au serveur RAILS",\
                  QString.fromUtf8("Echec de la connexion, vérifier les paramètres entrés."), "Ok")




