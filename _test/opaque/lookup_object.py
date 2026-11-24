# Opaque type `lookup_object` for game/gbtd_gbr1.ksy: finds the object whose
# object_id equals master_id. After the example linked from the spec doc
# (ZetaTwo/gameboy-project gbm-parser/lookup_object.py); ksc calls it as
# LookupObject(objects, master_id, _io).
from kaitaistruct import KaitaiStruct


class LookupObject(KaitaiStruct):
    def __init__(self, objects, master_id, _io, _parent=None, _root=None):
        self._io = _io
        self._parent = _parent
        self._root = _root
        self.object = None
        for gbr_object in objects:
            if gbr_object.object_id == master_id:
                self.object = gbr_object
                break
