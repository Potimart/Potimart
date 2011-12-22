# -*- coding: utf-8 -*-
"""
/***************************************************************************
PotimartMaps
A QGIS plugin
Background Maps
                             -------------------
begin                : 2010-07-20
copyright            : (C) 2010 by dryade
email                : luc.donnet@dryade.net
 ***************************************************************************/

/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/
 This script initializes the plugin, making it known to QGIS.
"""
def name():
  return "Potimart"
def description():
  return "Visualisation d'un réseau de transport urbain"
def version():
  return "Version 0.1"
def qgisMinimumVersion():
  return "1.0"
def classFactory(iface):
  # load PotimartMaps class from file PotimartMaps
  from PotimartMaps import PotimartMaps
  return PotimartMaps(iface)


