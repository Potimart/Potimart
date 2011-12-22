# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'Ui_PotimartMaps.ui'
#
# Created: Tue Jul 20 15:08:37 2010
#      by: PyQt4 UI code generator 4.7.2
#
# WARNING! All changes made in this file will be lost!

from PyQt4 import QtCore, QtGui

class Ui_PotimartMaps(object):
    def setupUi(self, PotimartMaps):
        PotimartMaps.setObjectName("PotimartMaps")
        PotimartMaps.resize(400, 300)
        self.buttonBox = QtGui.QDialogButtonBox(PotimartMaps)
        self.buttonBox.setGeometry(QtCore.QRect(30, 240, 341, 32))
        self.buttonBox.setOrientation(QtCore.Qt.Horizontal)
        self.buttonBox.setStandardButtons(QtGui.QDialogButtonBox.Cancel|QtGui.QDialogButtonBox.Ok)
        self.buttonBox.setObjectName("buttonBox")
        self.label = QtGui.QLabel(PotimartMaps)
        self.label.setGeometry(QtCore.QRect(60, 50, 301, 131))
        self.label.setObjectName("label")

        self.retranslateUi(PotimartMaps)
        QtCore.QObject.connect(self.buttonBox, QtCore.SIGNAL("accepted()"), PotimartMaps.accept)
        QtCore.QObject.connect(self.buttonBox, QtCore.SIGNAL("rejected()"), PotimartMaps.reject)
        QtCore.QMetaObject.connectSlotsByName(PotimartMaps)

    def retranslateUi(self, PotimartMaps):
        PotimartMaps.setWindowTitle(QtGui.QApplication.translate("PotimartMaps", "PotimartMaps", None, QtGui.QApplication.UnicodeUTF8))
        self.label.setText(QtGui.QApplication.translate("PotimartMaps", "Vous allez importer les graphiques suivants : \n"
"- contours iris\n"
"- contours communes\n"
"- les tracé des lignes de transport\n"
"- les zones\n"
"", None, QtGui.QApplication.UnicodeUTF8))

