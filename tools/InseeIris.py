# -*- coding: utf-8 -*-

from PyQt4.QtCore import *
from qgis.core import *

import PotiTools

class InseeIris():

  def __init__(self, iface):
    self.iface = iface

    db = PotiTools.setPostGresDataSource("public", "insee_iris", "the_geom", "")
    layer = QgsVectorLayer(db.uri(), QString.fromUtf8("Insee Iris"), "postgres")
    PotiTools.displayLayer(layer, "Insee Iris", "../qml/insee_iris.qml")


