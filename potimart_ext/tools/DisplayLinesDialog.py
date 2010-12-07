# -*- coding: utf-8 -*-
"""
---------------------------------------------------------------------------
 Created on: 2010-11-23
 Author  : M. PENA
 Project : Potimart
 Company : (C) 2010 by MobIGIS, contact@mobigis.fr
 Usages  : create the dialog for display lines.

 Updates:
---------------------------------------------------------------------------
"""

from PyQt4 import QtCore, QtGui
from Ui_DisplayLines import Ui_DisplayLines

# create the dialog for display lines
class DisplayLinesDialog(QtGui.QDialog):
  def __init__(self):
    QtGui.QDialog.__init__(self)
    # Set up the user interface from Designer.
    self.ui = Ui_DisplayLines()
    self.ui.setupUi(self)

  def accept(self):
    #self.indicator = self.ui.indicator.toPlainText()
    QtGui.QDialog.accept(self)
