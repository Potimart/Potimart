# -*- coding: utf-8 -*-
"""
---------------------------------------------------------------------------
 Created on: 2010-07-20
 Author  : Luc DONNET
 Project : Potimart
 Company : (C) 2010 by Dryade, luc.donnet@dryade.net
 Usages  : create interface and dialogs for QGIS extension.

 Updates:
     2010-11-23 by M. PENA (MobiGIS) : update menu content
---------------------------------------------------------------------------
"""

# Import the PyQt and QGIS libraries
from PyQt4.QtCore import *
from PyQt4.QtGui import *
from qgis.core import *

# Initialize Qt resources from file resources.py
import resources

# Import the code for the dialog
from PotimartMapsDialog import PotimartMapsDialog

# Set up current path, so that we know where to look for modules
import os.path, sys
currentPath = os.path.dirname( __file__ )
sys.path.append( os.path.abspath(os.path.dirname( __file__ ) + '/tools' ) )
sys.path.append( os.path.abspath(os.path.dirname( __file__ ) + '/qml' ) )
sys.path.append( os.path.abspath(os.path.dirname( __file__ ) + '/icons' ) )

import InseeCommunes, InseeIris, StopAreaGeos, StopAreaGeoIndicators, DisplayLines, LineIndicators, JourneyNb, Options

class PotimartMaps:

  def __init__(self, iface):
    # Save reference to the QGIS interface
    self.iface = iface

  def initGui(self):
    self.menu = QMenu()
    self.menu.setTitle("Potimart")

    # Menu Affichage du réseau
    self.menuDisplayNetwork = self.menu.addMenu(QString.fromUtf8("Affichage du réseau"))

    self.display_lines = QAction( QIcon("./icons/pathlinks.png"), QString.fromUtf8("Ligne(s)"), self.iface.mainWindow() )
    QObject.connect( self.display_lines , SIGNAL( "triggered()" ), self.doDisplayLines )
    self.menuDisplayNetwork.addAction(self.display_lines)

    self.stop_area_geos = QAction( QIcon("./icons/stop_area_geos.png"), QString.fromUtf8("Arrêts"), self.iface.mainWindow() )
    QObject.connect( self.stop_area_geos , SIGNAL( "triggered()" ), self.doStopAreaGeos )
    self.menuDisplayNetwork.addAction(self.stop_area_geos)

    # Menu Affichage indicateurs
    self.menuDisplayIndicators = self.menu.addMenu(QString.fromUtf8("Affichage d'indicateurs"))

    self.stop_area_geo_indicators = QAction( QIcon("./icons/stop_area_geos.png"), QString.fromUtf8("Sur les arrêts"), self.iface.mainWindow() )
    QObject.connect( self.stop_area_geo_indicators , SIGNAL( "triggered()" ), self.doStopAreaGeoIndicators )
    self.menuDisplayIndicators.addAction(self.stop_area_geo_indicators)

    self.line_indicators = QAction( QIcon("./icons/stop_area_geos.png"), QString.fromUtf8("Sur les lignes"), self.iface.mainWindow() )
    QObject.connect( self.line_indicators , SIGNAL( "triggered()" ), self.doLineIndicators )
    self.menuDisplayIndicators.addAction(self.line_indicators)


    # Menu Calcul d'indicateurs
    self.menuEvalIndicators = self.menu.addMenu(QString.fromUtf8("Calcul d'indicateurs"))

    self.journey_nb = QAction( QIcon("./icons/stop_area_geos.png"), QString.fromUtf8("Nombre de passages sur une période"), self.iface.mainWindow() )
    QObject.connect( self.journey_nb , SIGNAL( "triggered()" ), self.doJourneyNb )
    self.menuEvalIndicators.addAction(self.journey_nb)

    # Options
    self.options = QAction( QIcon("./map.png"), QString.fromUtf8("Options"), self.iface.mainWindow() )
    QObject.connect( self.options , SIGNAL( "triggered()" ), self.doOptions )
    self.menu.addAction(self.options)

    menu_bar = self.iface.mainWindow().menuBar()
    menu_bar.addMenu(self.menu )

  def unload(self):
    pass

  def doInseeCommunes( self ):
    InseeCommunes.InseeCommunes( self.iface )

  def doInseeIris( self ):
    InseeIris.InseeIris( self.iface )

  def doStopAreaGeos( self ):
    StopAreaGeos.StopAreaGeos( self.iface )

  def doStopAreaGeoIndicators( self ):
    StopAreaGeoIndicators.StopAreaGeoIndicators( self.iface )

  def doDisplayLines( self ):
    DisplayLines.DisplayLines( self.iface )

  def doLineIndicators( self ):
    LineIndicators.LineIndicators( self.iface )

  def doJourneyNb( self ):
    JourneyNb.JourneyNb( self.iface )

  def doOptions( self ):
    Options.Options( self.iface )
