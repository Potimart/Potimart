# -*- coding: utf-8 -*-
"""
---------------------------------------------------------------------------
 Created on: 2010-07-20
 Author  : Luc DONNET
 Project : Potimart
 Company : (C) 2010 by Dryade, luc.donnet@dryade.net
 Usages  : load InseeCommunes layer.

 Updates:
---------------------------------------------------------------------------
"""

from PyQt4.QtCore import *
from qgis.core import *

import PotiTools

class InseeCommunes():

  def __init__(self, iface):
    self.iface = iface

    db = PotiTools.setPostGresDataSource("public", "insee_communes", "the_geom", "")
    layer = QgsVectorLayer(db.uri(), QString.fromUtf8("Insee Communes"), "postgres")
    PotiTools.displayLayer(layer, "Insee Communes", "../qml/insee_communes.qml")
