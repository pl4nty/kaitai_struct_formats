# Custom process `decompress(compression, compressor, max_size, padded)` for
# filesystem/squashfs.ksy. `compression` is true when the block is compressed
# (bit 15 of the metablock length clear); `compressor` is the superblock's
# compressor enum (1 zlib, 2 lzma, 3 lzo, 4 xz, 5 lz4, 6 zstd); `max_size` is
# the largest uncompressed size (8192 for metablocks, block_size for data
# blocks). `padded` (true for every data block but a file's last) is accepted
# and ignored: decompressing needs no padding. Only zlib, lzma and xz use the
# standard library; lz4 and zstd need the `lz4` / `zstandard` packages.
import lzma
import zlib


class Decompress(object):
    def __init__(self, compression, compressor, max_size, padded):
        self.compression = compression
        self.compressor = int(compressor)
        self.max_size = max_size
        self.padded = padded

    def decode(self, data):
        if not self.compression:
            return data
        c = self.compressor
        if c == 1:
            return zlib.decompress(data)
        if c == 2:
            return lzma.decompress(data, format=lzma.FORMAT_ALONE)
        if c == 4:
            return lzma.decompress(data, format=lzma.FORMAT_XZ)
        if c == 5:
            import lz4.block
            return lz4.block.decompress(data, uncompressed_size=self.max_size)
        if c == 6:
            import zstandard
            return zstandard.ZstdDecompressor().decompress(data, max_output_size=self.max_size)
        raise NotImplementedError("squashfs compressor %d" % c)
