meta:
  id: mozilla_startup_cache
  title: Mozilla startup cache (startupCache.8.little)
  application: Mozilla Firefox
  file-extension: little
  license: CC0-1.0
  ks-version: '0.9'
  endian: le
doc: |
  Startup cache of Gecko-based applications, stored in the profile's local
  directory as `startupCache/startupCache.<word size>.<endianness>` (e.g.
  `startupCache.8.little`). It caches the results of expensive startup work,
  such as compiled scripts, under string keys (typically URLs).

  The file is the 17-byte magic `startupcache0002` (with its terminating NUL
  byte), the size of the header table, the header table and the entry data.
  Each table record gives the offset (relative to the end of the table) and
  compressed size of an entry, its uncompressed size and its key. Records
  are sorted in the order the entries were requested, and the data of the
  entries follows in the same order. Each entry's data is one LZ4 frame
  (with content checksum), which this spec does not decompress.

  All integers are little-endian, whatever the endianness in the file name.
  The original design of the startup cache (see the Mozilla wiki) used a JAR
  archive instead; this spec only covers the current format.
doc-ref:
  - https://wiki.mozilla.org/StartupCache
  - https://github.com/mozilla-firefox/firefox/blob/111f74f986165ccb9912108fbc927732bc273c94/startupcache/StartupCache.cpp#L273-L365
  - https://github.com/mozilla-firefox/firefox/blob/111f74f986165ccb9912108fbc927732bc273c94/startupcache/StartupCache.cpp#L518-L613
  - https://github.com/mozilla-firefox/firefox/blob/111f74f986165ccb9912108fbc927732bc273c94/js/xpconnect/loader/IOBuffers.h
seq:
  - id: magic
    contents: [startupcache0002, 0]
  - id: len_header
    type: u4
  - id: header
    size: len_header
    type: header_table
instances:
  ofs_entries_base:
    value: 17 + 4 + len_header
    doc: Offset of the entry data; entry offsets are relative to it.
types:
  header_table:
    seq:
      - id: entries
        type: entry
        repeat: eos
  entry:
    seq:
      - id: ofs_data
        type: u4
        doc: Offset of the compressed data, relative to the end of the header table.
      - id: len_data_compressed
        type: u4
      - id: len_data_uncompressed
        type: u4
      - id: len_key
        type: u2
      - id: key
        size: len_key
        type: str
        encoding: UTF-8
        doc: Key of the entry, typically a URL.
    instances:
      data_compressed:
        io: _root._io
        pos: _root.ofs_entries_base + ofs_data
        size: len_data_compressed
        doc: |
          LZ4 frame holding `len_data_uncompressed` bytes of data, with a content
          checksum.
