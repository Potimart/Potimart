"""
---------------------------------------------------------------------------
 Created on: 2010-11-23
 Author  : M. PENA
 Project : Potimart
 Company : (C) 2010 by MobIGIS, contact@mobigis.fr
 Usages  : create the extension interface dialog.

 Updates:
---------------------------------------------------------------------------
"""

from PyQt4 import QtCore, QtGui
from Ui_PotimartMaps import Ui_PotimartMaps

# create the extension interface dialog
class PotimartMapsDialog(QtGui.QDialog):
  def __init__(self):
    QtGui.QDialog.__init__(self)
    # Set up the user interface from Designer.
    self.ui = Ui_PotimartMaps()
    self.ui.setupUi(self)

