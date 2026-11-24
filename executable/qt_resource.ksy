# Imported from https://github.com/armijnhemel/binaryanalysis-ng/blob/d72f0d9c5c4e5484878f357d07690e68334365db/src/bang/parsers/misc/qt_resource/qt_resource.ksy
# Tree node layout from https://github.com/mblsha/binja-qresource/blob/1f692758f08defb61ed80b72f4214b28c94288eb/qresource_tree.ksy
meta:
  id: qt_resource
  title: Qt binary resource file (rcc)
  application: Qt resource compiler (rcc)
  file-extension: rcc
  license: MIT
  endian: be
doc: |
  Standalone binary resource file written by Qt's `rcc -binary` and loaded
  with `QResource::registerResource()`. A `qres` header gives the offsets
  of three blocks: the file data (each entry a u4 length followed by the
  bytes, possibly zlib or zstd compressed), the name table (each entry a u2
  length, a u4 Qt hash and the UTF-16BE name) and the tree of directory and
  file nodes. The same three blocks are what `rcc` embeds into executables;
  `qt_resource_tree` describes such an embedded tree on its own.
doc-ref:
  - https://github.com/qt/qtbase/blob/dev/src/tools/rcc/rcc.cpp
  - https://github.com/qt/qtbase/blob/dev/src/corelib/io/qresource.cpp
seq:
  - id: magic
    contents: qres
  - id: version
    type: u4
    doc: Format version, 1 to 3.
  - id: ofs_tree
    type: u4
  - id: ofs_data
    type: u4
  - id: ofs_name_table
    type: u4
  - id: flags
    type: u4
    if: version >= 3
    doc: Compression algorithms used by the file entries (version 3 and later).
instances:
  node_size:
    value: 'version >= 2 ? 22 : 14'
    doc: Size of one tree node in bytes.
  root:
    pos: ofs_tree
    type: tree_node
    doc: Root directory node of the resource tree.
types:
  tree_node:
    seq:
      - id: name_offset
        type: u4
        doc: Offset of this node's name, relative to the name table.
      - id: flags
        type: u2
      - id: num_children
        type: u4
        if: is_directory
      - id: first_child_index
        type: u4
        if: is_directory
        doc: Index of the first child node in the tree.
      - id: locale
        type: locale_info
        if: not is_directory
      - id: data_offset
        type: u4
        if: not is_directory
        doc: Offset of the file entry, relative to the data block.
      - id: last_modified
        type: u8
        if: _root.version >= 2
        doc: Modification time in milliseconds since the Unix epoch, 0 if unknown.
    instances:
      is_compressed:
        value: (flags & 0x01) != 0
        doc: The file data is zlib compressed (with a u4 uncompressed size prefix).
      is_directory:
        value: (flags & 0x02) != 0
      is_compressed_zstd:
        value: (flags & 0x04) != 0
      name:
        io: _root._io
        pos: _root.ofs_name_table + name_offset
        type: name_entry
        doc: Node name; meaningless for the root node.
      children:
        io: _root._io
        pos: _root.ofs_tree + first_child_index * _root.node_size
        type: tree_node
        repeat: expr
        repeat-expr: num_children
        if: is_directory
      file:
        io: _root._io
        pos: _root.ofs_data + data_offset
        type: data_entry
        if: not is_directory
  locale_info:
    seq:
      - id: territory
        type: u2
      - id: language
        type: u2
  name_entry:
    seq:
      - id: len_name
        type: u2
        doc: Name length in UTF-16 code units.
      - id: hash
        type: u4
        doc: qt_hash() of the name.
      - id: name
        size: len_name * 2
        type: str
        encoding: UTF-16BE
  data_entry:
    seq:
      - id: len_data
        type: u4
      - id: data
        size: len_data
