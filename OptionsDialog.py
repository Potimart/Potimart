# -*- coding: utf-8 -*-

from PyQt4 import QtCore, QtGui
from Ui_Options import Ui_Options

# create the dialog for display lines
class OptionsDialog(QtGui.QDialog):
  def __init__(self):
    QtGui.QDialog.__init__(self)
    # Set up the user interface from Designer.
    self.ui = Ui_Options()
    self.ui.setupUi(self)

  def accept(self):
    #self.indicator = self.ui.indicator.toPlainText()
    QtGui.QDialog.accept(self)
