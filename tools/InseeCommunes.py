# -*- coding: utf-8 -*-

from PyQt4.QtCore import *
from qgis.core import *

import PotiTools

class InseeCommunes():

  def __init__(self, iface):
    self.iface = iface

    db = PotiTools.setPostGresDataSource("public", "insee_communes", "the_geom", "")
    layer = QgsVectorLayer(db.uri(), QString.fromUtf8("Insee Communes"), "postgres")
    PotiTools.displayLayer(layer, "Insee Communes", "../qml/insee_communes.qml")
