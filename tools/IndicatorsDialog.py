"""
/***************************************************************************
PotimartDialog
A QGIS plugin
Use url REST
                             -------------------
begin                : 2010-06-18
copyright            : (C) 2010 by Dryade
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
from Ui_Indicators import Ui_Indicators
# create the dialog for zoom to point
class IndicatorsDialog(QtGui.QDialog):
  def __init__(self):
    QtGui.QDialog.__init__(self)
    # Set up the user interface from Designer.
    self.ui = Ui_Indicators()
    self.ui.setupUi(self)

##  def accept(self):
##    self.indicator = self.ui.indicator.toPlainText()
##    QtGui.QDialog.accept(self)
