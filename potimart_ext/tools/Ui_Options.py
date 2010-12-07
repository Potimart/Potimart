# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'Ui_Options.ui'
#
# Created: Fri Aug 27 15:53:40 2010
#      by: PyQt4 UI code generator 4.7.4
#
# WARNING! All changes made in this file will be lost!

from PyQt4 import QtCore, QtGui

class Ui_Options(object):
    def setupUi(self, Options):
        Options.setObjectName("Options")
        Options.resize(342, 353)
        self.buttonBox = QtGui.QDialogButtonBox(Options)
        self.buttonBox.setGeometry(QtCore.QRect(150, 310, 181, 32))
        self.buttonBox.setOrientation(QtCore.Qt.Horizontal)
        self.buttonBox.setStandardButtons(QtGui.QDialogButtonBox.Cancel|QtGui.QDialogButtonBox.Ok)
        self.buttonBox.setObjectName("buttonBox")
        self.groupBox = QtGui.QGroupBox(Options)
        self.groupBox.setGeometry(QtCore.QRect(10, 10, 321, 201))
        self.groupBox.setObjectName("groupBox")
        self.label = QtGui.QLabel(self.groupBox)
        self.label.setGeometry(QtCore.QRect(21, 40, 111, 16))
        self.label.setObjectName("label")
        self.label_2 = QtGui.QLabel(self.groupBox)
        self.label_2.setGeometry(QtCore.QRect(21, 69, 27, 16))
        self.label_2.setObjectName("label_2")
        self.label_3 = QtGui.QLabel(self.groupBox)
        self.label_3.setGeometry(QtCore.QRect(21, 99, 84, 16))
        self.label_3.setObjectName("label_3")
        self.label_4 = QtGui.QLabel(self.groupBox)
        self.label_4.setGeometry(QtCore.QRect(21, 129, 55, 16))
        self.label_4.setObjectName("label_4")
        self.label_5 = QtGui.QLabel(self.groupBox)
        self.label_5.setGeometry(QtCore.QRect(21, 159, 71, 16))
        self.label_5.setObjectName("label_5")
        self.hostLineEdit = QtGui.QLineEdit(self.groupBox)
        self.hostLineEdit.setGeometry(QtCore.QRect(140, 39, 161, 20))
        self.hostLineEdit.setText("")
        self.hostLineEdit.setObjectName("hostLineEdit")
        self.portLineEdit = QtGui.QLineEdit(self.groupBox)
        self.portLineEdit.setGeometry(QtCore.QRect(140, 69, 161, 20))
        self.portLineEdit.setObjectName("portLineEdit")
        self.dbnameLineEdit = QtGui.QLineEdit(self.groupBox)
        self.dbnameLineEdit.setGeometry(QtCore.QRect(140, 99, 161, 20))
        self.dbnameLineEdit.setObjectName("dbnameLineEdit")
        self.usernameLineEdit = QtGui.QLineEdit(self.groupBox)
        self.usernameLineEdit.setGeometry(QtCore.QRect(140, 129, 161, 20))
        self.usernameLineEdit.setObjectName("usernameLineEdit")
        self.passwordLineEdit = QtGui.QLineEdit(self.groupBox)
        self.passwordLineEdit.setGeometry(QtCore.QRect(140, 159, 161, 20))
        self.passwordLineEdit.setObjectName("passwordLineEdit")
        self.groupBox_2 = QtGui.QGroupBox(Options)
        self.groupBox_2.setGeometry(QtCore.QRect(10, 220, 321, 80))
        self.groupBox_2.setObjectName("groupBox_2")
        self.railsLineEdit = QtGui.QLineEdit(self.groupBox_2)
        self.railsLineEdit.setGeometry(QtCore.QRect(139, 39, 161, 20))
        self.railsLineEdit.setText("")
        self.railsLineEdit.setObjectName("railsLineEdit")
        self.label_11 = QtGui.QLabel(self.groupBox_2)
        self.label_11.setGeometry(QtCore.QRect(20, 40, 111, 16))
        self.label_11.setObjectName("label_11")

        self.retranslateUi(Options)
        QtCore.QObject.connect(self.buttonBox, QtCore.SIGNAL("accepted()"), Options.accept)
        QtCore.QObject.connect(self.buttonBox, QtCore.SIGNAL("rejected()"), Options.reject)
        QtCore.QMetaObject.connectSlotsByName(Options)

    def retranslateUi(self, Options):
        Options.setWindowTitle(QtGui.QApplication.translate("Options", "Options", None, QtGui.QApplication.UnicodeUTF8))
        self.groupBox.setTitle(QtGui.QApplication.translate("Options", "Paramètres de connexion à la base PostgreSQL", None, QtGui.QApplication.UnicodeUTF8))
        self.label.setText(QtGui.QApplication.translate("Options", "Serveur PosgreSQL :", None, QtGui.QApplication.UnicodeUTF8))
        self.label_2.setText(QtGui.QApplication.translate("Options", "Port :", None, QtGui.QApplication.UnicodeUTF8))
        self.label_3.setText(QtGui.QApplication.translate("Options", "Base de donnée :", None, QtGui.QApplication.UnicodeUTF8))
        self.label_4.setText(QtGui.QApplication.translate("Options", "Utilisateur :", None, QtGui.QApplication.UnicodeUTF8))
        self.label_5.setText(QtGui.QApplication.translate("Options", "Mot de passe :", None, QtGui.QApplication.UnicodeUTF8))
        self.portLineEdit.setInputMask(QtGui.QApplication.translate("Options", "9999; ", None, QtGui.QApplication.UnicodeUTF8))
        self.groupBox_2.setTitle(QtGui.QApplication.translate("Options", "Serveur Rails", None, QtGui.QApplication.UnicodeUTF8))
        self.railsLineEdit.setToolTip(QtGui.QApplication.translate("Options", "LOCAL    : localhost:3000\n"
"DISTANT : ara:3000 ou potimart.dryadebox.net", None, QtGui.QApplication.UnicodeUTF8))
        self.label_11.setText(QtGui.QApplication.translate("Options", "Adresse du serveur :", None, QtGui.QApplication.UnicodeUTF8))


if __name__ == "__main__":
    import sys
    app = QtGui.QApplication(sys.argv)
    Options = QtGui.QDialog()
    ui = Ui_Options()
    ui.setupUi(Options)
    Options.show()
    sys.exit(app.exec_())

