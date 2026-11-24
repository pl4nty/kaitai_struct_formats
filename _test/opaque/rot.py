# Custom process `rot(rot_value, chunk_size)` for game/qsp.ksy: adds rot_value to each
# chunk_size-byte unsigned integer, modulo 2**(8*chunk_size) (QSP stores UTF-16 code units
# shifted down by 5). Follows the Python code in the spec's own `doc` (classes GFOp and Rot),
# trimmed to what the spec uses. Departures: the doc's isPowerOf2() is inverted
# (`bool((x - 1) & x)` is true for non-powers of 2); this uses a plain modulo instead, which
# gives the same results for the default scale. An empty endianness means native order, as
# in the doc's struct format. A trailing partial chunk (the doc would fail on it) is copied as is.
import struct

_SIZES = {1: "B", 2: "H", 4: "I", 8: "Q"}
_ENDIANNESSES = {"": "", "le": "<", "be": ">"}


class Rot(object):
    def __init__(self, rotValue=13, chunkSize=1, endianness="", min=0, scale=None):
        self.chunkSize = chunkSize
        self.s = struct.Struct(_ENDIANNESSES[endianness] + _SIZES[chunkSize])
        if scale is None:
            scale = 2 ** (8 * chunkSize) - min
        self.scale = scale
        self.min = min
        self.rotValue = rotValue

    def decode(self, data):
        n = self.chunkSize
        out = bytearray(len(data))
        for p in range(0, len(data) - len(data) % n, n):
            v = self.s.unpack_from(data, p)[0]
            self.s.pack_into(out, p, self.min + (v - self.min + self.rotValue) % self.scale)
        out[len(data) - len(data) % n:] = data[len(data) - len(data) % n:]
        return bytes(out)
