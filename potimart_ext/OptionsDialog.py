# -*- coding: utf-8 -*-
"""
---------------------------------------------------------------------------
 Created on: 2010-11-23
 Author  : M. PENA
 Project : Potimart
 Company : (C) 2010 by MobIGIS, contact@mobigis.fr
 Usages  : create the dialog for option window.

 Updates:
---------------------------------------------------------------------------
"""

from PyQt4 import QtCore, QtGui
from Ui_Options import Ui_Options

# Create the dialog for option window
class OptionsDialog(QtGui.QDialog):
  def __init__(self):
    QtGui.QDialog.__init__(self)
    # Set up the user interface from Designer.
    self.ui = Ui_Options()
    self.ui.setupUi(self)

  def accept(self):
    #self.indicator = self.ui.indicator.toPlainText()
    QtGui.QDialog.accept(self)
