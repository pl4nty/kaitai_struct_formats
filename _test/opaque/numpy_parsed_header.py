# Opaque type `numpy_parsed_header` for serialization/numpy_npy.ksy.
# Taken from the doc of the spec's `parsed_header` instance (with its stray
# closing parenthesis fixed): a JSON-based surrogate of ast.literal_eval.
import json
import re

from kaitaistruct import KaitaiStruct

_brace_fixing_rx = re.compile(r",\s*([\]\}])")


def _literal_eval_surrogate(s):
    s = s.strip()
    s = s.replace("(", "[").replace(")", "]")
    s = _brace_fixing_rx.sub(lambda m: m.group(1), s)
    s = s.replace("True", "true").replace("False", "false")
    s = s.replace("'", '"')
    return json.loads(s)


class NumpyParsedHeader(KaitaiStruct):
    def __init__(self, header_str, _io, _parent=None, _root=None):
        self._io = _io
        self._parent = _parent
        self._root = _root
        header = _literal_eval_surrogate(header_str)
        self.item_type = header["descr"]
        if not isinstance(self.item_type, str):
            raise NotImplementedError(repr(self.item_type))
        if self.item_type[0] == "S" and (len(self.item_type) != 2 or self.item_type[1] != "1"):
            raise NotImplementedError(repr(self.item_type))
        self.fortran_order = header["fortran_order"]
        self.shape = header["shape"]
        self.dimensions = len(self.shape)
