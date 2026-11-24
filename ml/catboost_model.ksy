meta:
  id: catboost_model
  title: CatBoost binary model
  application: CatBoost
  file-extension: cbm
  license: CC0-1.0
  ks-version: '0.9'
  encoding: UTF-8
  endian: le
doc: |
  Native binary model file of the CatBoost gradient boosting library
  (`save_model(..., format="cbm")`, the default). It is the 4-byte
  descriptor "CBM1", the size of the model core, the model core as a
  FlatBuffers buffer with root type `TModelCore`, and then the
  serialized "model parts" named in the core's `ModelPartIds` (static
  CTR provider, text and embedding processing collections), which use
  CatBoost's own serialization and are kept raw here.

  Coverage: the container and the top level of the FlatBuffers core:
  the format version string (currently "FlabuffersModel_v1"), the
  key/value model info map (training parameters, feature names, class
  names, ...) and the model part identifiers. The `ModelTrees` table
  (tree splits, leaf values, feature descriptions) is only located,
  not decoded.
doc-ref:
  - https://github.com/catboost/catboost/blob/b4310b26fb7ce5a08b08cf1b2bb2674dc89fc1be/catboost/libs/model/model.cpp
  - https://github.com/catboost/catboost/blob/b4310b26fb7ce5a08b08cf1b2bb2674dc89fc1be/catboost/libs/model/flatbuffers/model.fbs
  - https://github.com/catboost/catboost/blob/b4310b26fb7ce5a08b08cf1b2bb2674dc89fc1be/util/ysaveload.h
seq:
  - id: magic
    -orig-id: MODEL_FILE_DESCRIPTOR_CHARS
    contents: CBM1
  - id: len_core_32
    type: u4
    doc: Core size, or 0xFFFFFFFF if a 64-bit size follows (`SaveSize`).
  - id: len_core_64
    type: u8
    if: len_core_32 == 0xffff_ffff
  - id: core
    size: 'len_core_32 == 0xffff_ffff ? len_core_64 : len_core_32'
    type: model_core
  - id: model_parts
    size-eos: true
    doc: Serialized model parts listed in `core.root.model_part_ids`, in that order.
types:
  model_core:
    doc: FlatBuffers buffer whose root table is `TModelCore`.
    seq:
      - id: ofs_root
        type: u4
    instances:
      root:
        pos: ofs_root
        type: table(ofs_root)
        doc: The TModelCore table.
      fields:
        pos: 0
        type: core_table(ofs_root, root.vtable)
        doc: Fields of the TModelCore root table.
  table:
    doc: FlatBuffers table at offset `ofs` of the buffer.
    params:
      - id: ofs
        type: u4
    seq:
      - id: ofs_vtable_rel
        type: s4
        doc: The vtable is at `ofs - ofs_vtable_rel`.
    instances:
      vtable:
        pos: ofs - ofs_vtable_rel
        type: vtable
  vtable:
    seq:
      - id: len_vtable
        type: u2
      - id: len_table
        type: u2
      - id: field_offsets
        type: u2
        repeat: expr
        repeat-expr: (len_vtable - 4) / 2
        doc: Offset of each field from the table start; 0 means absent.
  core_table:
    doc: TModelCore fields, located through the root table's vtable.
    params:
      - id: ofs
        type: u4
      - id: vtable
        type: vtable
    instances:
      has_format_version:
        value: vtable.field_offsets.size > 0 and vtable.field_offsets[0] != 0
      format_version:
        pos: ofs + vtable.field_offsets[0]
        type: string_ref(ofs + vtable.field_offsets[0])
        if: has_format_version
      has_model_trees:
        value: vtable.field_offsets.size > 1 and vtable.field_offsets[1] != 0
      model_trees:
        pos: ofs + vtable.field_offsets[1]
        type: offset_ref(ofs + vtable.field_offsets[1])
        if: has_model_trees
        doc: Reference to the TModelTrees table (not decoded).
      has_info_map:
        value: vtable.field_offsets.size > 2 and vtable.field_offsets[2] != 0
      info_map:
        pos: ofs + vtable.field_offsets[2]
        type: key_value_vector_ref(ofs + vtable.field_offsets[2])
        if: has_info_map
      has_model_part_ids:
        value: vtable.field_offsets.size > 3 and vtable.field_offsets[3] != 0
      model_part_ids:
        pos: ofs + vtable.field_offsets[3]
        type: string_vector_ref(ofs + vtable.field_offsets[3])
        if: has_model_part_ids
  offset_ref:
    doc: FlatBuffers uoffset stored at `ofs`, relative to its own position.
    params:
      - id: ofs
        type: u4
    seq:
      - id: rel
        type: u4
    instances:
      target:
        value: ofs + rel
  string_ref:
    params:
      - id: ofs
        type: u4
    seq:
      - id: rel
        type: u4
    instances:
      value:
        pos: ofs + rel
        type: fb_string
  fb_string:
    seq:
      - id: len_value
        type: u4
      - id: value
        size: len_value
        type: str
  string_vector_ref:
    params:
      - id: ofs
        type: u4
    seq:
      - id: rel
        type: u4
    instances:
      num_items:
        pos: ofs + rel
        type: u4
      items:
        pos: ofs + rel + 4
        type: string_ref(ofs + rel + 4 + 4 * _index)
        repeat: expr
        repeat-expr: num_items
  key_value_vector_ref:
    params:
      - id: ofs
        type: u4
    seq:
      - id: rel
        type: u4
    instances:
      num_items:
        pos: ofs + rel
        type: u4
      items:
        pos: ofs + rel + 4
        type: key_value_ref(ofs + rel + 4 + 4 * _index)
        repeat: expr
        repeat-expr: num_items
  key_value_ref:
    doc: Reference to a TKeyValue table (Key, Value strings).
    params:
      - id: ofs
        type: u4
    seq:
      - id: rel
        type: u4
    instances:
      table:
        pos: ofs + rel
        type: table(ofs + rel)
      key:
        pos: ofs + rel + table.vtable.field_offsets[0]
        type: string_ref(ofs + rel + table.vtable.field_offsets[0])
      value:
        pos: ofs + rel + table.vtable.field_offsets[1]
        type: string_ref(ofs + rel + table.vtable.field_offsets[1])
