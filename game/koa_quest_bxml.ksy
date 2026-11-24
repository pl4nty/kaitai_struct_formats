# Imported from https://github.com/sorche942/koa-formats-kaitai/blob/efc04be2db704e88200d287aa5c583c05ec09282/quest_bxml.ksy
meta:
  id: koa_quest_bxml
  title: Kingdoms of Amalur quest BXML
  file-extension: quest_bxml
  license: LicenseRef-All-Rights-Reserved
  ks-version: 0.11
  endian: le

doc: |
  Reverse-engineered quest BXML container used by Kingdoms of Amalur.
  Confirmed layout from koa.exe (Build 2026-02-13 analysis).
  Standard quest payloads use a fixup-relocated binary object graph.
  Runtime decode path: BHG::Quest::virtual_12 (0x00FF1B00) -> 0x00A6E7C0.
  Confidence tags used below:
  - [C] confirmed directly from runtime code and corpus checks
  - [I] inferred from naming/use context
  - [U] unresolved semantics

seq:
  - id: main_block_len
    type: u4
    doc: Size of the main serialized quest payload block.
  - id: fixup_block_len
    type: u4
    doc: Size in bytes of the trailing fixup-offset block.
  - id: main_block
    size: main_block_len
    type: main_block
    if: is_standard_container
  - id: fixups
    type: fixup_entry(main_block)
    repeat: expr
    repeat-expr: fixup_block_len / 4
    if: is_standard_container and fixup_block_size_matches_count
    doc: Trailing offset list (relative to start of main_block) used by runtime patch-up.

instances:
  expected_file_size:
    value: 8 + main_block_len + fixup_block_len
  has_size_mismatch:
    value: expected_file_size != _io.size
  fixup_count:
    value: fixup_block_len / 4
  fixup_block_size_matches_count:
    value: fixup_count * 4 == fixup_block_len
  is_standard_container:
    value: (not has_size_mismatch) and fixup_block_size_matches_count
  is_nonstandard_container:
    value: not is_standard_container
  is_stub:
    value: main_block_len == 0x00020800
  is_batch:
    value: main_block_len == 1

types:
  main_block:
    seq:
      - id: quest_id
        type: u4
        doc: "[C] Script-facing quest ID."
      - id: header_token_04
        type: u4
        doc: "[U] Header scalar at +0x04."
      - id: guid_hash_lo
        type: u4
      - id: guid_hash_hi
        type: u4
      - id: variant
        type: u4
        doc: "[I] Quest variant/type discriminator used by runtime logic."
      - id: paired_id
        type: u4
        doc: "[C] Related/paired quest ID copied to runtime quest object +0x08."
      - id: runtime_scalar_74
        type: u4
        doc: |
          [C/I] Scalar copied to runtime quest object +0x74; later stamped onto desc7
          runtime rows (+0x10).
      - id: steps_ptr
        type: u4
        doc: "[C] Pointer to step rows (stride 0x38)."
      - id: steps_count
        type: u4
        doc: "[C] Number of step rows."
      - id: variables_ptr
        type: u4
        doc: "[C] Pointer to variable rows (stride 0x1C)."
      - id: variables_count
        type: u4
        doc: "[C] Number of variable rows."
      - id: stages_ptr
        type: u4
        doc: "[C] Pointer to stage rows (stride 0x70)."
      - id: stages_count
        type: u4
        doc: "[C] Number of stage rows."
      - id: quest_id_list_ptr
        type: u4
        doc: "[C] Pointer to u32 ID list."
      - id: quest_id_list_count
        type: u4
        doc: "[C] Number of u32 IDs in quest_id_list_ptr."
      - id: name
        type: string_obj_14
        doc: |
          [C/I] 0x14-byte header object; v0 commonly points to quest key text in raw
          files.
      - id: aux_a_ptr
        type: u4
        doc: "[C/I] Header word at +0x50. In runtime tuple view, this behaves as desc7_ptr."
      - id: aux_a_count_like
        type: u4
        doc: "[C/I] Header word at +0x54. In runtime tuple view, this behaves as desc7_count."
      - id: aux_b_ptr
        type: u4
        doc: "[U] Raw header word at +0x58 (legacy parse view)."
      - id: aux_b_count_like
        type: u4
        doc: "[U] Raw header word at +0x5C (legacy parse view)."
      - id: requirement_groups_ptr
        type: u4
        doc: "[U] Raw header word at +0x60 (legacy parse view)."
      - id: requirement_groups_count
        type: u4
        doc: "[U] Raw header word at +0x64 (legacy parse view)."

    instances:
      guid_hash:
        value: (guid_hash_hi << 32) | guid_hash_lo
      runtime_aux_a_ptr:
        value: name.v4
      runtime_aux_a_count_like:
        value: name.ptr
      runtime_aux_b_ptr:
        value: name.len
      runtime_aux_b_count_like:
        value: name.v10
      runtime_aux_b_len_aligned_4:
        value: ((runtime_aux_b_count_like + 3) / 4) * 4
      runtime_desc7_ptr:
        value: aux_a_ptr
      runtime_desc7_count:
        value: aux_a_count_like
      runtime_desc7_ptr_matches_aux_b_tail:
        value: runtime_desc7_ptr == runtime_aux_b_ptr + runtime_aux_b_len_aligned_4
      runtime_aux_b_span_bytes_ok:
        value: runtime_aux_b_count_like == 0 or (runtime_aux_b_ptr >= 8 and (runtime_aux_b_ptr - 8) + runtime_aux_b_count_like <= _root.main_block_len)
      runtime_desc7_span_ok:
        value: runtime_desc7_count == 0 or (runtime_desc7_ptr >= 8 and (runtime_desc7_ptr - 8) + runtime_desc7_count * 0x0C <= _root.main_block_len)
      runtime_desc7_rows_raw:
        pos: runtime_desc7_ptr - 8
        type: desc7_row_0c_raw
        repeat: expr
        repeat-expr: runtime_desc7_count
        if: runtime_desc7_span_ok and runtime_desc7_ptr >= 8
      runtime_desc7_groups:
        pos: runtime_desc7_ptr - 8
        type: quest_requirement_group
        repeat: expr
        repeat-expr: runtime_desc7_count
        if: runtime_desc7_span_ok and runtime_desc7_ptr >= 8
      aux_a_span_14_ok:
        value: aux_a_count_like == 0 or (aux_a_ptr >= 8 and (aux_a_ptr - 8) + aux_a_count_like * 0x14 <= _root.main_block_len)
      aux_b_span_14_ok:
        value: aux_b_count_like == 0 or (aux_b_ptr >= 8 and (aux_b_ptr - 8) + aux_b_count_like * 0x14 <= _root.main_block_len)
      aux_a_span_bytes_ok:
        value: aux_a_count_like == 0 or (aux_a_ptr >= 8 and (aux_a_ptr - 8) + aux_a_count_like <= _root.main_block_len)
      aux_b_span_bytes_ok:
        value: aux_b_count_like == 0 or (aux_b_ptr >= 8 and (aux_b_ptr - 8) + aux_b_count_like <= _root.main_block_len)
      aux_b_len_aligned_4:
        value: ((aux_b_count_like + 3) / 4) * 4
      desc7_ptr_matches_aux_b_tail:
        value: requirement_groups_ptr == aux_b_ptr + aux_b_len_aligned_4
      requirement_groups_span_ok:
        value: requirement_groups_count == 0 or (requirement_groups_ptr >= 8 and (requirement_groups_ptr - 8) + requirement_groups_count * 0x0C <= _root.main_block_len)
      steps:
        pos: steps_ptr - 8
        type: quest_step
        repeat: expr
        repeat-expr: steps_count
        if: steps_ptr >= 8
      variables:
        pos: variables_ptr - 8
        type: quest_variable
        repeat: expr
        repeat-expr: variables_count
        if: variables_ptr >= 8
      stages:
        pos: stages_ptr - 8
        type: quest_stage
        repeat: expr
        repeat-expr: stages_count
        if: stages_ptr >= 8
      quest_id_list:
        pos: quest_id_list_ptr - 8
        type: u4
        repeat: expr
        repeat-expr: quest_id_list_count
        if: quest_id_list_ptr >= 8
      aux_a_rows_raw:
        pos: aux_a_ptr - 8
        type: aux_desc_row_14_raw
        repeat: expr
        repeat-expr: aux_a_count_like
        if: aux_a_span_14_ok and aux_a_ptr >= 8
      aux_b_rows_raw:
        pos: aux_b_ptr - 8
        type: aux_desc_row_14_raw
        repeat: expr
        repeat-expr: aux_b_count_like
        if: aux_b_span_14_ok and aux_b_ptr >= 8
      aux_a_blob:
        pos: aux_a_ptr - 8
        size: aux_a_count_like
        if: aux_a_span_bytes_ok and aux_a_ptr >= 8
      aux_b_blob:
        pos: aux_b_ptr - 8
        size: aux_b_count_like
        if: aux_b_span_bytes_ok and aux_b_ptr >= 8
      desc7_rows_raw:
        pos: requirement_groups_ptr - 8
        type: desc7_row_0c_raw
        repeat: expr
        repeat-expr: requirement_groups_count
        if: requirement_groups_span_ok and requirement_groups_ptr >= 8
      requirement_groups:
        pos: requirement_groups_ptr - 8
        type: quest_requirement_group
        repeat: expr
        repeat-expr: requirement_groups_count
        if: requirement_groups_span_ok and requirement_groups_ptr >= 8

  string_obj_14:
    doc: Standard BHG 0x14-byte string runtime object.
    seq:
      - id: v0
        type: u4
      - id: v4
        type: u4
      - id: ptr
        type: u4
      - id: len
        type: u4
      - id: v10
        type: u4
    instances:
      value:
        pos: ptr - 8
        size: len
        type: str
        encoding: ASCII
        if: ptr >= 8
      v0_value:
        pos: v0 - 8
        size-eos: true
        type: str
        encoding: ASCII
        if: v0 >= 8

  aux_desc_row_14_raw:
    doc: Raw 0x14-byte descriptor row used by aux descriptor families.
    seq:
      - id: v0
        type: u4
      - id: v4
        type: u4
      - id: v8
        type: u4
      - id: vc
        type: u4
      - id: v10
        type: u4

  desc7_row_0c_raw:
    doc: |
      Raw 0x0C descriptor source row consumed by desc7 init helper (0x00FEEB90).
      Runtime probe mapping from desc7_init logs:
      - runtime.v0 <- v8
      - runtime.v8 <- 0x34
      - runtime.vc <- v0
    seq:
      - id: v0
        type: u4
      - id: v4
        type: u4
      - id: v8
        type: u4
    instances:
      source_token:
        value: v0
      source_payload_ptr:
        value: v4
      source_count_like:
        value: v8
      group_token:
        value: source_token
      requirement_entries_ptr:
        value: source_payload_ptr
      requirement_entries_count:
        value: source_count_like
      init_expected_runtime_v0:
        value: v8
      init_expected_runtime_v8:
        value: 0x34
      init_expected_runtime_vc:
        value: v0
      payload_entries_0c_span_ok:
        value: source_count_like == 0 or (source_payload_ptr >= 8 and (source_payload_ptr - 8) + source_count_like * 0x0C <= _root.main_block_len)
      requirement_entries_span_ok:
        value: payload_entries_0c_span_ok
      payload_values_u4_span_ok:
        value: source_count_like == 0 or (source_payload_ptr >= 8 and (source_payload_ptr - 8) + source_count_like * 0x04 <= _root.main_block_len)
      payload_entries_0c:
        pos: source_payload_ptr - 8
        type: quest_requirement_entry
        repeat: expr
        repeat-expr: source_count_like
        if: payload_entries_0c_span_ok and source_payload_ptr >= 8
      requirement_entries:
        value: payload_entries_0c
      payload_values_u4:
        pos: source_payload_ptr - 8
        type: u4
        repeat: expr
        repeat-expr: source_count_like
        if: payload_values_u4_span_ok and source_payload_ptr >= 8

  quest_variable:
    doc: "Stride: 0x1C bytes."
    seq:
      - id: variable_token
        type: u4
        doc: "[C/U] Variable token copied into runtime variable row."
      - id: variable_meta
        type: u4
        doc: "[U] Variable metadata/type-like scalar."
      - id: name
        type: string_obj_14
        doc: "[C] Variable name/key string object."

  quest_step:
    doc: "Stride: 0x38 bytes."
    seq:
      - id: step_id
        type: u4
        doc: "[I] Step identifier."
      - id: step_token_04
        type: u4
        doc: "[U] Step token at +0x04."
      - id: step_token_08
        type: u4
        doc: "[C/U] Step token copied to runtime step +0x18."
      - id: step_token_0c
        type: u4
        doc: "[C/U] Step token copied to runtime step +0x1C."
      - id: name_hash_ref
        type: u4
        doc: "[C] HashName reference used by step init."
      - id: step_token_14
        type: u4
        doc: "[U] Step token at +0x14."
      - id: step_token_18
        type: u4
        doc: "[C/U] Step token copied to runtime step +0x10."
      - id: step_token_1c
        type: u4
        doc: "[C/U] Step token copied to runtime step +0x14."
      - id: ref_rows_ptr
        type: u4
        doc: "[C] Pointer to ref rows (stride 0x10)."
      - id: ref_rows_count
        type: u4
        doc: "[C] Number of ref rows."
      - id: payload_rows_ptr
        type: u4
        doc: "[C] Pointer to payload rows (stride 0x20)."
      - id: payload_rows_count
        type: u4
        doc: "[C] Number of payload rows."
      - id: step_flags
        type: u1
        doc: "[C] Step flag byte copied into runtime step flags."
      - id: pad_31_37
        size: 7
    instances:
      ref_rows:
        pos: ref_rows_ptr - 8
        type: quest_step_ref_row
        repeat: expr
        repeat-expr: ref_rows_count
        if: ref_rows_ptr >= 8
      payload_rows:
        pos: payload_rows_ptr - 8
        type: quest_step_payload_row
        repeat: expr
        repeat-expr: payload_rows_count
        if: payload_rows_ptr >= 8

  quest_step_ref_row:
    doc: "Stride: 0x10 bytes in file."
    seq:
      - id: ref_token
        type: u4
        doc: "[C/U] Ref token copied to runtime row +0x00."
      - id: ref_param
        type: u4
        doc: "[C/U] Ref token copied to runtime row +0x04."
      - id: ref_name_hash
        type: u4
        doc: "[C] Hash/token converted via fcn.00af4d40."
      - id: ref_value
        type: u4
        doc: "[C/U] Ref value copied to runtime row +0x14."

  quest_step_payload_row:
    doc: "Stride: 0x20 bytes in file."
    seq:
      - id: payload_token
        type: u4
        doc: "[C/U] Payload token copied to runtime row +0x00."
      - id: payload_param
        type: u4
        doc: "[C/U] Payload token copied to runtime row +0x04."
      - id: payload_name
        type: string_obj_14
        doc: "[C] String/hash object consumed during step init."
      - id: payload_value
        type: u4
        doc: "[C/U] Extra scalar copied to runtime payload row +0x14."

  quest_stage:
    doc: "Stride: 0x70 bytes."
    seq:
      - id: stage_token_00
        type: u4
        doc: "[C/U] Stage token copied to runtime stage +0x18."
      - id: stage_token_04
        type: u4
        doc: "[C/U] Stage token copied to runtime stage +0x1C."
      - id: stage_token_08
        type: u4
        doc: "[C/U] Stage token copied to runtime stage +0x54."
      - id: stage_token_0c
        type: u4
        doc: "[C/U] Stage token copied to runtime stage +0x50."
      - id: stage_token_10
        type: u4
        doc: "[C/U] Stage token copied to runtime stage +0xBC."
      - id: stage_s16_14
        type: s2
        doc: "[C/U] Stage signed scalar copied to runtime stage +0xC0."
      - id: stage_s16_16
        type: s2
        doc: "[C/U] Stage signed scalar copied to runtime stage +0xC4."
      - id: stage_token_18
        type: u4
        doc: "[C/U] Stage token copied to runtime stage +0xC8."
      - id: stage_token_1c
        type: u4
        doc: "[C/U] Stage token copied to runtime stage +0xB8."
      - id: stage_token_20
        type: u4
        doc: "[C/U] Stage token copied to runtime stage +0xB4."
      - id: stage_token_24
        type: u4
        doc: "[C/U] Stage token copied to runtime stage +0xD8."
      - id: stage_token_28
        type: u4
        doc: "[C/U] Stage token copied to runtime stage +0xD4."
      - id: stage_token_2c
        type: u4
        doc: "[C/U] Stage token copied to runtime stage +0x4C."
      - id: stage_token_30
        type: u4
        doc: "[C/U] Stage token copied to runtime stage +0xCC."
      - id: tags_ptr
        type: u4
        doc: "[C] Pointer to tag rows (stride 0x08)."
      - id: tags_count
        type: u4
        doc: "[C] Number of tag rows."
      - id: stage_slot_ids
        type: u4
        repeat: expr
        repeat-expr: 6
        doc: "[C/I] Six stage slot IDs consumed/reordered by stage init logic."
      - id: stage_name
        type: string_obj_14
        doc: "[C] Stage name/key string object."
      - id: objectives_ptr
        type: u4
        doc: "[C] Pointer to objective rows (stride 0x40)."
      - id: objectives_count
        type: u4
        doc: "[C] Number of objective rows."
    instances:
      tags:
        pos: tags_ptr - 8
        type: quest_stage_tag
        repeat: expr
        repeat-expr: tags_count
        if: tags_ptr >= 8
      objectives:
        pos: objectives_ptr - 8
        type: quest_objective
        repeat: expr
        repeat-expr: objectives_count
        if: objectives_ptr >= 8

  quest_stage_tag:
    doc: "Stride: 0x08 bytes."
    seq:
      - id: tag_token
        type: u4
        doc: "[C/U] Objective/tag token."
      - id: class_flag_a
        type: u1
        doc: "[C/U] Tag classification flag A."
      - id: class_flag_b
        type: u1
        doc: "[C/U] Tag classification flag B."
      - id: pad_06
        type: u2

  quest_objective:
    doc: "Stride: 0x40 bytes."
    seq:
      - id: objective_token_00
        type: u4
        doc: "[C/U] Objective token copied to runtime objective +0x08."
      - id: objective_token_04
        type: u4
        doc: "[C/U] Objective token copied to runtime objective +0x0C."
      - id: objective_flag_08
        type: u1
        doc: "[C] Mapped to runtime objective flags bit 0x02."
      - id: pad_09_0b
        size: 3
      - id: objective_token_0c
        type: u4
        doc: "[C/U] Objective token copied to runtime objective +0x2C."
      - id: objective_token_10
        type: u4
        doc: "[C/U] Objective token copied to runtime objective +0x28."
      - id: requirements_ptr
        type: u4
        doc: "[C] Pointer to requirement rows (stride 0x08)."
      - id: requirements_count
        type: u4
        doc: "[C] Number of requirement rows."
      - id: objective_token_1c
        type: u4
        doc: "[C/U] Objective token copied to runtime objective +0x10."
      - id: objective_token_20
        type: u4
        doc: "[C/U] Objective token copied to runtime objective +0x14."
      - id: objective_token_24
        type: u4
        doc: "[C/U] Objective token copied to runtime objective +0x18."
      - id: objective_flag_28
        type: u1
        doc: "[C] Mapped to runtime objective flags bit 0x04."
      - id: objective_flag_29
        type: u1
        doc: "[U] Additional objective flag byte."
      - id: pad_2a_2b
        size: 2
      - id: objective_token_2c
        type: u4
        doc: "[C/U] Copied to runtime objective +0x1C."
      - id: objective_token_30
        type: u4
        doc: "[C/U] Copied to runtime objective +0x20."
      - id: objective_token_34
        type: u4
        doc: "[C/U] Copied to runtime objective +0x24."
      - id: objective_flag_38
        type: u1
        doc: "[C] Mapped to runtime objective flags bit 0x10."
      - id: objective_flag_39
        type: u1
        doc: "[U] Additional objective flag byte."
      - id: pad_3a_3f
        size: 6
    instances:
      requirement_rows:
        pos: requirements_ptr - 8
        type: quest_objective_requirement_row
        repeat: expr
        repeat-expr: requirements_count
        if: requirements_ptr >= 8

  quest_objective_requirement_row:
    doc: "Stride: 0x08 bytes in file."
    seq:
      - id: requirement_token
        type: u4
        doc: "[C/U] Requirement token/opcode."
      - id: requirement_param
        type: u4
        doc: "[C/U] Requirement parameter/value."

  quest_requirement_group:
    doc: "Stride: 0x0C bytes."
    seq:
      - id: group_token
        type: u4
        doc: |
          [C/I] Copied to runtime req-group +0x0C and canonicalized via QuestMgr in
          virtual_16.
      - id: requirement_entries_ptr
        type: u4
        doc: "[C] Pointer to requirement entries (stride 0x0C)."
      - id: requirement_entries_count
        type: u4
        doc: "[C] Number of requirement entries."
    instances:
      requirement_entries_span_ok:
        value: requirement_entries_count == 0 or (requirement_entries_ptr >= 8 and (requirement_entries_ptr - 8) + requirement_entries_count * 0x0C <= _root.main_block_len)
      requirement_entries:
        pos: requirement_entries_ptr - 8
        type: quest_requirement_entry
        repeat: expr
        repeat-expr: requirement_entries_count
        if: requirement_entries_span_ok and requirement_entries_ptr >= 8

  quest_requirement_entry:
    doc: "Stride: 0x0C bytes."
    seq:
      - id: entry_token
        type: u4
        doc: "[C/U] Entry token copied to runtime req-entry +0x00."
      - id: entry_values_ptr
        type: u4
        doc: "[C] Pointer to u32 entry values array."
      - id: entry_values_count
        type: u4
        doc: "[C] Number of u32 entry values."
    instances:
      entry_values_span_ok:
        value: entry_values_count == 0 or (entry_values_ptr >= 8 and (entry_values_ptr - 8) + entry_values_count * 0x04 <= _root.main_block_len)
      entry_values:
        pos: entry_values_ptr - 8
        type: u4
        repeat: expr
        repeat-expr: entry_values_count
        if: entry_values_span_ok and entry_values_ptr >= 8

  fixup_entry:
    params:
      - id: main
        type: main_block
    seq:
      - id: offset
        type: u4
