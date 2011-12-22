"""
/***************************************************************************
PotimartMapsDialog
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
"""

from PyQt4 import QtCore, QtGui 
from Ui_PotimartMaps import Ui_PotimartMaps
# create the dialog for zoom to point
class PotimartMapsDialog(QtGui.QDialog):
  def __init__(self): 
    QtGui.QDialog.__init__(self) 
    # Set up the user interface from Designer. 
    self.ui = Ui_PotimartMaps()
    self.ui.setupUi(self) 

