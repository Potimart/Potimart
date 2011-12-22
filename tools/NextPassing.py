# -*- coding: utf-8 -*-

from PyQt4 import QtCore, QtGui

from PyQt4.QtCore import *
from PyQt4.QtGui import *
from qgis.core import *

# Import the code for the dialog
#from DisplayLinesDialog import DisplayLinesDialog

from xml.dom import minidom
import urllib
import time
import sys
import ConfigParser

import os.path
currentPath = os.path.dirname( __file__ )

import PotiTools



class NextPassing:
       # create the dialog
    #dlg = DisplayLinesDialog()

    def __init__(self, iface):
        self.iface = iface

        QMessageBox.information(self.iface.mainWindow(), "Test",\
        QString.fromUtf8("Texte test"), "Ok")