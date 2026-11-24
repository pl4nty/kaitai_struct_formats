meta:
  id: cern_root
  title: CERN ROOT file
  application: ROOT data analysis framework
  file-extension: root
  license: CC0-1.0
  ks-version: '0.11'
  encoding: UTF-8
  endian: be
doc: |
  Container file of the ROOT data analysis framework developed at CERN, used
  throughout high-energy physics to store serialized C++ objects (histograms,
  trees, ...).

  A ROOT file starts with a header (at offset 0, `fBEGIN` = 100 bytes long),
  followed by consecutive records up to `fEND`. Every record is either a free
  gap (negative `nbytes`) or a `TKey`: a key header (class name, object name
  and title, cycle number, ...) followed by the object data. Object data is
  compressed when `obj_len` differs from `nbytes - key_len`; it is then made of
  one or more compressed blocks with a 9-byte header each, and blocks
  compressed with zlib (`ZL`) are decompressed here. The serialized objects
  themselves (described by the `TStreamerInfo` record) are not parsed.

  The first record (class `TFile`) holds the file's name and title, and the
  top-level `TDirectory` header follows at `fBEGIN + fNbytesName`; its
  `seek_keys` points to the record containing the list of keys of the
  top directory.

  Files larger than 2 GB use a header version >= 1000000 and keys/directories
  with version > 1000; these use 64-bit file offsets.
doc-ref:
  - https://root.cern.ch/doc/master/classTFile.html
  - https://github.com/root-project/root/blob/master/io/io/src/TFile.cxx
  - https://github.com/scikit-hep/uproot5/blob/v5.4.1/src/uproot/reading.py
seq:
  - id: header
    type: file_header
instances:
  records:
    pos: header.ofs_begin
    size: header.ofs_end - header.ofs_begin
    type: record_list
  top_directory:
    pos: header.ofs_begin + header.len_name
    type: directory
types:
  file_header:
    seq:
      - id: magic
        contents: root
      - id: version
        -orig-id: fVersion
        type: s4
        doc: Format version (ROOT version number), plus 1000000 for large files.
      - id: ofs_begin
        -orig-id: fBEGIN
        type: s4
        doc: Offset of the first record, normally 100.
      - id: ofs_end
        -orig-id: fEND
        type:
          switch-on: is_large
          cases:
            true: s8
            false: s4
        doc: Offset of the first free byte at the end of the file.
      - id: ofs_free
        -orig-id: fSeekFree
        type:
          switch-on: is_large
          cases:
            true: s8
            false: s4
        doc: Offset of the record holding the list of free segments.
      - id: len_free
        -orig-id: fNbytesFree
        type: s4
      - id: num_free
        -orig-id: nfree
        type: s4
      - id: len_name
        -orig-id: fNbytesName
        type: s4
        doc: Size of the key and TNamed of the first (TFile) record.
      - id: units
        -orig-id: fUnits
        type: u1
        doc: Size of file offsets, 4 or 8.
      - id: compress
        -orig-id: fCompress
        type: s4
        doc: 100 * algorithm + level.
      - id: ofs_info
        -orig-id: fSeekInfo
        type:
          switch-on: is_large
          cases:
            true: s8
            false: s4
        doc: Offset of the TStreamerInfo record.
      - id: len_info
        -orig-id: fNbytesInfo
        type: s4
      - id: uuid_version
        type: u2
      - id: uuid
        -orig-id: fUUID
        size: 16
    instances:
      is_large:
        value: version >= 1000000
  record_list:
    seq:
      - id: records
        type: record
        repeat: eos
  record:
    seq:
      - id: nbytes
        -orig-id: Nbytes
        type: s4
        valid:
          expr: _ != 0
        doc: |
          Size of the whole record. A negative value marks a free gap of
          `-nbytes` bytes.
      - id: body
        size: '(nbytes < 0 ? -nbytes : nbytes) - 4'
        type:
          switch-on: nbytes > 0
          cases:
            true: key(nbytes)
    instances:
      is_gap:
        value: nbytes < 0
  key:
    params:
      - id: nbytes
        type: s4
    seq:
      - id: version
        type: s2
        doc: TKey version; > 1000 means 64-bit offsets.
      - id: obj_len
        -orig-id: ObjLen
        type: s4
        doc: Size of the uncompressed object.
      - id: datime
        type: datime
        doc: Date and time when the object was written.
      - id: key_len
        -orig-id: KeyLen
        type: s2
        doc: Size of the key header, including `nbytes`.
      - id: cycle
        type: s2
      - id: ofs_key
        -orig-id: SeekKey
        type:
          switch-on: is_large
          cases:
            true: s8
            false: s4
        doc: Offset of this record itself.
      - id: ofs_parent_dir
        -orig-id: SeekPdir
        type:
          switch-on: is_large
          cases:
            true: s8
            false: s4
        doc: Offset of the directory this key belongs to.
      - id: class_name
        type: tstring
      - id: name
        type: tstring
      - id: title
        type: tstring
      - id: key_extra
        size: key_len - 4 - _io.pos
      - id: data
        size-eos: true
        type:
          switch-on: is_compressed
          cases:
            true: compressed_data
    instances:
      is_large:
        value: version > 1000
      is_compressed:
        value: obj_len != nbytes - key_len
  compressed_data:
    seq:
      - id: blocks
        type: compressed_block
        repeat: eos
  compressed_block:
    seq:
      - id: algorithm
        size: 2
        type: str
        doc: '`ZL` (zlib), `XZ` (LZMA), `L4` (LZ4), `ZS` (Zstandard), `CS` (old).'
      - id: method
        type: u1
      - id: len_compressed
        type: u3le
      - id: len_uncompressed
        type: u3le
      - id: data
        size: len_compressed.value
        type:
          switch-on: algorithm
          cases:
            '"ZL"': zlib_data
        doc: For `L4`, the first 8 bytes are an xxHash64 checksum of the rest.
  zlib_data:
    seq:
      - id: uncompressed
        size-eos: true
        process: zlib
  u3le:
    seq:
      - id: b0
        type: u1
      - id: b1
        type: u1
      - id: b2
        type: u1
    instances:
      value:
        value: b0 | b1 << 8 | b2 << 16
  tstring:
    seq:
      - id: len_short
        type: u1
      - id: len_long
        type: u4
        if: len_short == 255
      - id: value
        size: 'len_short == 255 ? len_long : len_short'
        type: str
  datime:
    seq:
      - id: year_since_1995
        type: b6
      - id: month
        type: b4
      - id: day
        type: b5
      - id: hour
        type: b5
      - id: minute
        type: b6
      - id: second
        type: b6
    instances:
      year:
        value: year_since_1995 + 1995
  directory:
    doc: TDirectory header, as stored after the TNamed of a directory's key.
    seq:
      - id: version
        type: s2
        doc: Directory version; > 1000 means 64-bit offsets.
      - id: datime_created
        -orig-id: fDatimeC
        type: datime
      - id: datime_modified
        -orig-id: fDatimeM
        type: datime
      - id: len_keys
        -orig-id: fNbytesKeys
        type: s4
      - id: len_name
        -orig-id: fNbytesName
        type: s4
      - id: ofs_dir
        -orig-id: fSeekDir
        type:
          switch-on: is_large
          cases:
            true: s8
            false: s4
      - id: ofs_parent
        -orig-id: fSeekParent
        type:
          switch-on: is_large
          cases:
            true: s8
            false: s4
      - id: ofs_keys
        -orig-id: fSeekKeys
        type:
          switch-on: is_large
          cases:
            true: s8
            false: s4
        doc: Offset of the record holding this directory's list of keys.
    instances:
      is_large:
        value: version > 1000
