# -*- coding: utf-8 -*-
"""
---------------------------------------------------------------------------
 Created on: 2010-11-23
 Author  : M. PENA
 Project : Potimart
 Company : (C) 2010 by MobIGIS, contact@mobigis.fr
 Usages  : create the journeynb indicator dialog.

 Updates:
---------------------------------------------------------------------------
"""

from PyQt4 import QtCore, QtGui
from Ui_JourneyNb import Ui_JourneyNb

# create the journeynb indicator dialog
class JourneyNbDialog(QtGui.QDialog):
  def __init__(self):
    QtGui.QDialog.__init__(self)
    # Set up the user interface from Designer.
    self.ui = Ui_JourneyNb()
    self.ui.setupUi(self)
