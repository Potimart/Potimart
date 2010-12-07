# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'Ui_Indicators.ui'
#
# Created: Fri Oct 15 13:57:33 2010
#      by: PyQt4 UI code generator 4.7.4
#
# WARNING! All changes made in this file will be lost!

from PyQt4 import QtCore, QtGui

class Ui_Indicators(object):
    def setupUi(self, Indicators):
        Indicators.setObjectName("Indicators")
        Indicators.resize(401, 137)
        self.buttons = QtGui.QDialogButtonBox(Indicators)
        self.buttons.setGeometry(QtCore.QRect(220, 100, 160, 25))
        self.buttons.setOrientation(QtCore.Qt.Horizontal)
        self.buttons.setStandardButtons(QtGui.QDialogButtonBox.Cancel|QtGui.QDialogButtonBox.Ok)
        self.buttons.setObjectName("buttons")
        self.label_3 = QtGui.QLabel(Indicators)
        self.label_3.setGeometry(QtCore.QRect(20, 20, 281, 13))
        self.label_3.setObjectName("label_3")
        self.IndicatorsComboBox = QtGui.QComboBox(Indicators)
        self.IndicatorsComboBox.setEnabled(True)
        self.IndicatorsComboBox.setGeometry(QtCore.QRect(20, 50, 361, 20))
        sizePolicy = QtGui.QSizePolicy(QtGui.QSizePolicy.Fixed, QtGui.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.IndicatorsComboBox.sizePolicy().hasHeightForWidth())
        self.IndicatorsComboBox.setSizePolicy(sizePolicy)
        self.IndicatorsComboBox.setEditable(False)
        self.IndicatorsComboBox.setMaxVisibleItems(10)
        self.IndicatorsComboBox.setMaxCount(100)
        self.IndicatorsComboBox.setObjectName("IndicatorsComboBox")

        self.retranslateUi(Indicators)
        QtCore.QObject.connect(self.buttons, QtCore.SIGNAL("accepted()"), Indicators.accept)
        QtCore.QObject.connect(self.buttons, QtCore.SIGNAL("rejected()"), Indicators.reject)
        QtCore.QMetaObject.connectSlotsByName(Indicators)

    def retranslateUi(self, Indicators):
        Indicators.setWindowTitle(QtGui.QApplication.translate("Indicators", "Potimart", None, QtGui.QApplication.UnicodeUTF8))
        self.label_3.setText(QtGui.QApplication.translate("Indicators", "Sélectionner le nom de l\'indicateur dans la liste ci-dessous :", None, QtGui.QApplication.UnicodeUTF8))


if __name__ == "__main__":
    import sys
    app = QtGui.QApplication(sys.argv)
    Indicators = QtGui.QDialog()
    ui = Ui_Indicators()
    ui.setupUi(Indicators)
    Indicators.show()
    sys.exit(app.exec_())

