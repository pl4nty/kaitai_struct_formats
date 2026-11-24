# Opaque type `lytro_lfp_sections_index` for image/lytro_lfp.ksy, from the doc
# of the spec's `index` instance: maps section identifier (SHA-1 ref) -> section_contents.
from kaitaistruct import KaitaiStruct


class LytroLfpSectionsIndex(KaitaiStruct):
    def __init__(self, sections, _io, _parent=None, _root=None):
        self._io = _io
        self._parent = _parent
        self._root = _root
        self.index = {}
        for s in sections:
            if s.is_section:
                c = s.contents
                if c.size:
                    self.index[c.identifier] = c

    def __getitem__(self, key):
        return self.index[key]
