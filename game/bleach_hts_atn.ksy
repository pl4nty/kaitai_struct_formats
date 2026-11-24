# Imported from https://github.com/remixer-dec/GameTranslationPipelines/blob/b145e6972ee8ae8ed121c0ea64ffa49fbf71a189/PSP/Bleach%20Heat%20The%20Soul%20series/structs/atn.ksy
meta:
  id: bleach_hts_atn
  title: Bleach Heat The Soul 7 Attachment/Material Sprite Sequence Definition
  file-extension: atn
  license: LicenseRef-All-Rights-Reserved
  endian: le

seq:
  - id: entries
    # Each entry represents a definition for a specific ID (e.g., item, effect)
    # The size of 168 bytes is implicitly defined by the structure below.
    type: attachment_definition
    repeat: eos

types:
  attachment_definition:
    # Total size = 7 sections * 24 bytes/section = 168 bytes
    seq:
      # The 7 sections within each 168-byte entry.
      # Named based on the param_3 value used in copyAttachmentData to select them.
      - id: section_for_type_0 # Selected when param_3 == 0
        type: sprite_sequence_section
      - id: section_for_type_7 # Selected when param_3 == 7
        type: sprite_sequence_section
      - id: section_for_type_8 # Selected when param_3 == 8
        type: sprite_sequence_section
      - id: section_for_type_9 # Selected when param_3 == 9
        type: sprite_sequence_section
      - id: section_for_type_10 # Selected when param_3 == 10
        type: sprite_sequence_section
      - id: section_for_type_11 # Selected when param_3 == 11
        type: sprite_sequence_section
      - id: section_for_type_12 # Selected when param_3 == 12
        type: sprite_sequence_section

  sprite_sequence_section:
    # Total size = 12 shorts * 2 bytes/short = 24 bytes
    seq:
      # Each section contains exactly 12 shorts
      - id: sprite_ids_or_codes
        # These are primarily sprite IDs for atlas lookup, but can include
        # control codes like 0xFF20 (handled by rendering funcs),
        # or the terminator 0xFFFF.
        type: s2
        repeat: expr
        repeat-expr: 12
    instances:
      # Calculate the position of the first terminator (-1 / 0xFFFF)
      # This indicates the actual length of the sequence stored in the file.
      # The consuming application can use this value to slice the
      # 'sprite_ids_or_codes' array if needed.
      terminator_pos:
        value: |
          (sprite_ids_or_codes[0] == -1) ? 0 :
          (sprite_ids_or_codes[1] == -1) ? 1 :
          (sprite_ids_or_codes[2] == -1) ? 2 :
          (sprite_ids_or_codes[3] == -1) ? 3 :
          (sprite_ids_or_codes[4] == -1) ? 4 :
          (sprite_ids_or_codes[5] == -1) ? 5 :
          (sprite_ids_or_codes[6] == -1) ? 6 :
          (sprite_ids_or_codes[7] == -1) ? 7 :
          (sprite_ids_or_codes[8] == -1) ? 8 :
          (sprite_ids_or_codes[9] == -1) ? 9 :
          (sprite_ids_or_codes[10] == -1) ? 10 :
          (sprite_ids_or_codes[11] == -1) ? 11 : 12
