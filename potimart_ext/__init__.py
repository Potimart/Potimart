# -*- coding: utf-8 -*-
"""
---------------------------------------------------------------------------
 Created on: 2010-07-20
 Author  : L. Donnet
 Project : Potimart
 Company : (C) 2010 by Dryade, luc.donnet@dryade.net
 Usages  : This script initializes the plugin, making it known to QGIS.

 Updates:
        23/11/2010 by M. PENA  : Updated
---------------------------------------------------------------------------
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


