# Custom process `concat(...)` for filesystem/squashfs.ksy.
# The spec applies it to a 0-byte field and passes the metablocks as the
# argument; decode() ignores its input and returns the concatenated
# decompressed payloads. The argument is either a metablock_list (field
# `metablock`: list of metablock) or a list of metablock_reference (each with
# a `metablock` instance). A metablock's payload is `metablock.data.data`
# (uncompressed_data, already run through the `decompress` process).


class Concat(object):
    def __init__(self, metablocks):
        self.metablocks = metablocks

    def decode(self, data):
        src = self.metablocks
        blocks = src if isinstance(src, list) else src.metablock
        out = bytearray(data)
        for b in blocks:
            mb = getattr(b, "metablock", b)  # metablock_reference -> metablock
            out += mb.data.data
        return bytes(out)
