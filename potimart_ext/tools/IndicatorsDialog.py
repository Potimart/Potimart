"""
---------------------------------------------------------------------------
 Created on: 2010-11-23
 Author  : M. PENA
 Project : Potimart
 Company : (C) 2010 by MobIGIS, contact@mobigis.fr
 Usages  : create the dialog for indicators windows.

 Updates:
---------------------------------------------------------------------------
"""

from PyQt4 import QtCore, QtGui
from Ui_Indicators import Ui_Indicators

# create the dialog for indicators windows
class IndicatorsDialog(QtGui.QDialog):
  def __init__(self):
    QtGui.QDialog.__init__(self)
    # Set up the user interface from Designer.
    self.ui = Ui_Indicators()
    self.ui.setupUi(self)
