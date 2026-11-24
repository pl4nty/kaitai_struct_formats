meta:
  id: moarvm_bytecode
  title: MoarVM bytecode file
  application:
    - MoarVM
    - NQP
    - Rakudo
  file-extension: moarvm
  license: CC0-1.0
  ks-version: '0.9'
  endian: le
doc: |
  Compilation unit for MoarVM, the virtual machine behind Rakudo (Raku)
  and NQP. The file starts with a header of offsets and counts for its
  segments: string heap, serialization context (SC) dependencies,
  extension ops, static frames, callsites, serialized SC data, the
  bytecode itself and line-number annotations.

  This spec targets bytecode version 7, the only version accepted by
  current MoarVM. It parses the header, the string heap, the SC
  dependency and extension op tables, every frame description (local
  and lexical types, exception handlers, static lexical values and
  debug names, with each frame's bytecode exposed as raw bytes), the
  callsites and the annotations. The serialized SC data and the
  instruction stream are left raw.
doc-ref:
  - https://github.com/MoarVM/MoarVM/blob/c5a08f1e79ea03df43051866bdfec75841372e81/src/core/bytecode.c
  - https://github.com/MoarVM/MoarVM/blob/c5a08f1e79ea03df43051866bdfec75841372e81/docs/bytecode.md
  - https://github.com/MoarVM/MoarVM/blob/c5a08f1e79ea03df43051866bdfec75841372e81/src/core/compunit.c
seq:
  - id: magic
    contents: "MOARVM\r\n"
  - id: version
    type: u4
    valid: 7
  - id: ofs_sc_deps
    type: u4
  - id: num_sc_deps
    type: u4
  - id: ofs_extops
    type: u4
  - id: num_extops
    type: u4
  - id: ofs_frames
    type: u4
  - id: num_frames
    type: u4
  - id: ofs_callsites
    type: u4
  - id: num_callsites
    type: u4
  - id: ofs_strings
    type: u4
  - id: num_strings
    type: u4
  - id: ofs_sc_data
    type: u4
  - id: len_sc_data
    type: u4
  - id: ofs_bytecode
    type: u4
  - id: len_bytecode
    type: u4
  - id: ofs_annotations
    type: u4
  - id: len_annotations
    type: u4
  - id: hll_name
    type: u4
    doc: String heap index of the name of the HLL the unit was compiled from.
  - id: mainline_frame
    type: u4
    doc: Index + 1 of the mainline frame; 0 if none.
  - id: main_frame
    type: u4
    doc: Index + 1 of the main entry point frame; 0 if none.
  - id: load_frame
    type: u4
    doc: Index + 1 of the library load frame; 0 if none.
  - id: deserialize_frame
    type: u4
    doc: Index + 1 of the deserialization frame; 0 if none.
instances:
  strings:
    pos: ofs_strings
    type: heap_string
    repeat: expr
    repeat-expr: num_strings
  sc_deps:
    pos: ofs_sc_deps
    type: u4
    repeat: expr
    repeat-expr: num_sc_deps
    doc: String heap indexes of the unique IDs of the SCs this unit references.
  extops:
    pos: ofs_extops
    type: extop
    repeat: expr
    repeat-expr: num_extops
  frames:
    pos: ofs_frames
    type: frame
    repeat: expr
    repeat-expr: num_frames
  callsites:
    pos: ofs_callsites
    type: callsite
    repeat: expr
    repeat-expr: num_callsites
  sc_data:
    pos: ofs_sc_data
    size: len_sc_data
    doc: Serialized objects of the unit's serialization context.
  bytecode:
    pos: ofs_bytecode
    size: len_bytecode
  annotations:
    pos: ofs_annotations
    size: len_annotations
    type: annotations
types:
  heap_string:
    seq:
      - id: len_and_flag
        type: u4
        doc: Byte length shifted left by one; bit 0 set means UTF-8, clear means Latin-1.
      - id: value
        size: len_and_flag >> 1
        doc: Encoded string; decode as UTF-8 or ISO-8859-1 according to `is_utf8`.
      - id: padding
        size: (4 - (len_and_flag >> 1) % 4) % 4
    instances:
      is_utf8:
        value: len_and_flag & 1 != 0
  extop:
    seq:
      - id: name
        type: u4
        doc: String heap index of the extension op name.
      - id: operand_descriptor
        size: 8
        doc: One MVMOpInfo operand descriptor byte per operand, zero-padded.
  frame:
    seq:
      - id: ofs_bytecode
        -orig-id: bytecode_pos
        type: u4
        doc: Offset of the frame's code within the bytecode segment.
      - id: len_bytecode
        -orig-id: bytecode_size
        type: u4
      - id: num_locals
        type: u4
      - id: num_lexicals
        type: u4
      - id: cuuid
        type: u4
        doc: String heap index of the frame's compilation unit unique ID.
      - id: name
        type: u4
        doc: String heap index of the frame name.
      - id: outer
        type: u2
        doc: Index of the outer frame; equal to this frame's own index if none.
      - id: ofs_annotations
        type: u4
        doc: Offset of the frame's annotations within the annotation segment.
      - id: num_annotations
        type: u4
      - id: num_handlers
        type: u4
      - id: flags
        type: u2
        doc: 1 = has exit handler, 2 = is a thunk, 8 = no inline.
      - id: num_static_lexical_values
        type: u2
      - id: code_obj_sc_dep_idx
        type: u4
        doc: Index + 1 into the SC dependencies of the code object's SC; 0 if none.
      - id: code_obj_sc_idx
        type: u4
      - id: num_local_debug_names
        type: u4
      - id: local_types
        type: u2
        repeat: expr
        repeat-expr: num_locals
        doc: Register kinds (1-4 int8-int64, 5-6 num32/64, 7 str, 8 obj, 17-20 uint8-uint64).
      - id: lexicals
        type: lexical
        repeat: expr
        repeat-expr: num_lexicals
      - id: handlers
        type: handler
        repeat: expr
        repeat-expr: num_handlers
      - id: static_lexical_values
        type: static_lexical_value
        repeat: expr
        repeat-expr: num_static_lexical_values
      - id: local_debug_names
        type: local_debug_name
        repeat: expr
        repeat-expr: num_local_debug_names
    instances:
      code:
        io: _root._io
        pos: _root.ofs_bytecode + ofs_bytecode
        size: len_bytecode
  lexical:
    seq:
      - id: lexical_type
        type: u2
      - id: name
        type: u4
        doc: String heap index of the lexical's name.
  handler:
    seq:
      - id: start_offset
        type: u4
        doc: Start of the protected region (inclusive), relative to the frame's code.
      - id: end_offset
        type: u4
        doc: End of the protected region (exclusive).
      - id: category_mask
        type: u4
      - id: action
        type: u2
      - id: block_reg
        type: u2
      - id: goto_offset
        type: u4
      - id: label_reg
        type: u2
        if: category_mask & 4096 != 0
        doc: Present when the category mask has MVM_EX_CAT_LABELED (4096).
  static_lexical_value:
    seq:
      - id: lexical_index
        type: u2
      - id: flags
        type: u2
        doc: 0 = static value, 1 = container var (cloned per frame), 2 = state var.
      - id: sc_dep_idx
        type: u4
      - id: sc_obj_idx
        type: u4
  local_debug_name:
    seq:
      - id: local_index
        type: u2
      - id: name
        type: u4
        doc: String heap index of the debug name.
  callsite:
    seq:
      - id: num_arg_flags
        type: u2
      - id: arg_flags
        type: 'arg_flag(_index == 0 ? 0 : arg_flags[_index - 1].num_names_upto)'
        repeat: expr
        repeat-expr: num_arg_flags
      - id: padding
        size: num_arg_flags % 2
      - id: arg_names
        type: u4
        repeat: expr
        repeat-expr: 'num_arg_flags == 0 ? 0 : arg_flags.last.num_names_upto'
        doc: |
          String heap indexes of the names of the named, non-flattening
          arguments, in order.
  arg_flag:
    params:
      - id: num_names_before
        type: u4
    seq:
      - id: is_uint
        type: b1
        doc: MVM_CALLSITE_ARG_UINT (128)
      - id: is_flat
        type: b1
        doc: MVM_CALLSITE_ARG_FLAT (64)
      - id: is_named
        type: b1
        doc: MVM_CALLSITE_ARG_NAMED (32)
      - id: is_literal
        type: b1
        doc: MVM_CALLSITE_ARG_LITERAL (16)
      - id: is_str
        type: b1
        doc: MVM_CALLSITE_ARG_STR (8)
      - id: is_num
        type: b1
        doc: MVM_CALLSITE_ARG_NUM (4)
      - id: is_int
        type: b1
        doc: MVM_CALLSITE_ARG_INT (2)
      - id: is_obj
        type: b1
        doc: MVM_CALLSITE_ARG_OBJ (1)
    instances:
      num_names_upto:
        value: 'num_names_before + (is_named and not is_flat ? 1 : 0)'
        doc: Number of argument names needed by this and the preceding flags.
  annotations:
    seq:
      - id: entries
        type: annotation
        repeat: eos
  annotation:
    seq:
      - id: ofs_bytecode
        type: u4
        doc: Offset into the bytecode segment.
      - id: filename
        type: u4
        doc: String heap index of the file name.
      - id: line
        type: u4
