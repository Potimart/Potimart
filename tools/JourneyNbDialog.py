# -*- coding: utf-8 -*-
"""
/***************************************************************************
JourneyNbDialog
A QGIS plugin
Nombre de courses passant par un point d’arrêt sur une période
                             -------------------
begin                : 2010-07-13
copyright            : (C) 2010 by MobiGIS
email                : mpena@mobigis.fr
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
from Ui_JourneyNb import Ui_JourneyNb

# create the dialog for zoom to point
class JourneyNbDialog(QtGui.QDialog):
  def __init__(self):
    QtGui.QDialog.__init__(self)
    # Set up the user interface from Designer.
    self.ui = Ui_JourneyNb()
    self.ui.setupUi(self)

##  def accept(self):
##    #self.indicator = self.ui.indicator.toPlainText()
##    QtGui.QDialog.accept(self)
