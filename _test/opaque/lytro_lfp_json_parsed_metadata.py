# Opaque type `lytro_lfp_json_parsed_metadata` for image/lytro_lfp.ksy, from the
# doc of the spec's `json_metadata.parsed_metadata` instance. Deviations from the
# doc: the index is looked up via LytroLfpSectionsIndex (which is subscriptable
# here), and SectionLink gets (frame_no, type) in the order its fields are named.
import json
from enum import IntEnum

from kaitaistruct import KaitaiStruct


class ChunkType(IntEnum):
    metadata = 0
    private_metadata = 1
    image = 2


class Frame(object):
    def __init__(self, json_obj, index):
        self.metadata = index[json_obj["metadataRef"]]
        self.private_metadata = index[json_obj["privateMetadataRef"]]
        self.image = index[json_obj["imageRef"]]


class SectionLink(object):
    def __init__(self, type, frame_no):
        self.type = type
        self.frame_no = frame_no


class LytroLfpJsonParsedMetadata(KaitaiStruct):
    def __init__(self, json_str, root, _io, _parent=None, _root=None):
        self._io = _io
        self._parent = _parent
        self._root = _root
        self.json = json.loads(json_str)
        index = root.index
        pic = self.json["picture"]
        self.frames = []
        self.metadata_index = {}
        for i, f in enumerate(pic["frameArray"]):
            fr = Frame(f["frame"], index)
            self.frames.append(fr)
            self.metadata_index[fr.metadata] = SectionLink(ChunkType.metadata, i)
            self.metadata_index[fr.private_metadata] = SectionLink(ChunkType.private_metadata, i)
            self.metadata_index[fr.image] = SectionLink(ChunkType.image, i)
