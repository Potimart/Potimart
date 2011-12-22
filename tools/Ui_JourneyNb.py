# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'Ui_JourneyNb.ui'
#
# Created: Thu Nov 04 22:13:34 2010
#      by: PyQt4 UI code generator 4.7.4
#
# WARNING! All changes made in this file will be lost!

from PyQt4 import QtCore, QtGui

class Ui_JourneyNb(object):
    def setupUi(self, JourneyNb):
        JourneyNb.setObjectName("JourneyNb")
        JourneyNb.resize(400, 230)
        self.buttonBox = QtGui.QDialogButtonBox(JourneyNb)
        self.buttonBox.setGeometry(QtCore.QRect(50, 190, 341, 32))
        self.buttonBox.setOrientation(QtCore.Qt.Horizontal)
        self.buttonBox.setStandardButtons(QtGui.QDialogButtonBox.Cancel|QtGui.QDialogButtonBox.Ok)
        self.buttonBox.setObjectName("buttonBox")
        self.groupBox = QtGui.QGroupBox(JourneyNb)
        self.groupBox.setGeometry(QtCore.QRect(10, 10, 381, 171))
        self.groupBox.setObjectName("groupBox")
        self.layoutWidget = QtGui.QWidget(self.groupBox)
        self.layoutWidget.setGeometry(QtCore.QRect(30, 43, 331, 121))
        self.layoutWidget.setObjectName("layoutWidget")
        self.gridLayout = QtGui.QGridLayout(self.layoutWidget)
        self.gridLayout.setHorizontalSpacing(22)
        self.gridLayout.setObjectName("gridLayout")
        self.label = QtGui.QLabel(self.layoutWidget)
        self.label.setObjectName("label")
        self.gridLayout.addWidget(self.label, 0, 0, 1, 1)
        self.label_2 = QtGui.QLabel(self.layoutWidget)
        self.label_2.setObjectName("label_2")
        self.gridLayout.addWidget(self.label_2, 1, 0, 1, 1)
        self.label_3 = QtGui.QLabel(self.layoutWidget)
        self.label_3.setObjectName("label_3")
        self.gridLayout.addWidget(self.label_3, 2, 0, 1, 1)
        self.dateEdit = QtGui.QDateEdit(self.layoutWidget)
        self.dateEdit.setDateTime(QtCore.QDateTime(QtCore.QDate(2009, 7, 9), QtCore.QTime(0, 0, 0)))
        self.dateEdit.setTime(QtCore.QTime(0, 0, 0))
        self.dateEdit.setDate(QtCore.QDate(2009, 7, 9))
        self.dateEdit.setObjectName("dateEdit")
        self.gridLayout.addWidget(self.dateEdit, 0, 1, 1, 1)
        self.startTimeEdit = QtGui.QTimeEdit(self.layoutWidget)
        self.startTimeEdit.setDateTime(QtCore.QDateTime(QtCore.QDate(2000, 1, 1), QtCore.QTime(5, 0, 0)))
        self.startTimeEdit.setObjectName("startTimeEdit")
        self.gridLayout.addWidget(self.startTimeEdit, 1, 1, 1, 1)
        self.endTimeEdit = QtGui.QTimeEdit(self.layoutWidget)
        self.endTimeEdit.setDateTime(QtCore.QDateTime(QtCore.QDate(2000, 1, 1), QtCore.QTime(21, 0, 0)))
        self.endTimeEdit.setObjectName("endTimeEdit")
        self.gridLayout.addWidget(self.endTimeEdit, 2, 1, 1, 1)
        self.label_4 = QtGui.QLabel(self.groupBox)
        self.label_4.setGeometry(QtCore.QRect(10, 20, 361, 21))
        self.label_4.setObjectName("label_4")

        self.retranslateUi(JourneyNb)
        QtCore.QObject.connect(self.buttonBox, QtCore.SIGNAL("accepted()"), JourneyNb.accept)
        QtCore.QObject.connect(self.buttonBox, QtCore.SIGNAL("rejected()"), JourneyNb.reject)
        QtCore.QMetaObject.connectSlotsByName(JourneyNb)
        JourneyNb.setTabOrder(self.endTimeEdit, self.buttonBox)
        JourneyNb.setTabOrder(self.buttonBox, self.startTimeEdit)
        JourneyNb.setTabOrder(self.startTimeEdit, self.dateEdit)

    def retranslateUi(self, JourneyNb):
        JourneyNb.setWindowTitle(QtGui.QApplication.translate("JourneyNb", "Nombre de passages sur une période", None, QtGui.QApplication.UnicodeUTF8))
        self.groupBox.setTitle(QtGui.QApplication.translate("JourneyNb", "Paramètres", None, QtGui.QApplication.UnicodeUTF8))
        self.label.setText(QtGui.QApplication.translate("JourneyNb", "Date (\'JJ/MM/AAAA\')", None, QtGui.QApplication.UnicodeUTF8))
        self.label_2.setText(QtGui.QApplication.translate("JourneyNb", "Heure début (\'HH:MM:SS\')", None, QtGui.QApplication.UnicodeUTF8))
        self.label_3.setText(QtGui.QApplication.translate("JourneyNb", "Heure fin (\'HH:MM:SS\')", None, QtGui.QApplication.UnicodeUTF8))
        self.label_4.setText(QtGui.QApplication.translate("JourneyNb", "Nombre de courses passant par le point d\'arrêt sur une période définie :", None, QtGui.QApplication.UnicodeUTF8))


if __name__ == "__main__":
    import sys
    app = QtGui.QApplication(sys.argv)
    JourneyNb = QtGui.QDialog()
    ui = Ui_JourneyNb()
    ui.setupUi(JourneyNb)
    JourneyNb.show()
    sys.exit(app.exec_())

