# Imported from https://github.com/desuex/torus-tools/blob/b2bdf033a06e70c7342ecce8f54172726b7b6568/TorusTool/Formats/Schemas/hunk_container.ksy
meta:
  id: torus_hunk_container
  title: Torus Games Hunk Archive Container
  application: Torus Games engine (Monster High New Ghoul in School and others)
  file-extension: hnk
  license: MIT OR WTFPL
  endian: le

doc: |
  Outer container for Torus Games asset archives. A flat sequence of records,
  each carrying a 32-bit size, a 32-bit type tag, and `size` bytes of body.
  The container is always little-endian regardless of console platform; the
  internal layout of each body depends on the type tag and is parsed by
  per-type schemas.

seq:
  - id: records
    type: record
    repeat: eos

types:
  record:
    seq:
      - id: len_body
        type: u4
        doc: Size of body in bytes (excludes the 8-byte header).
      - id: record_type
        type: u4
        enum: record_type
      - id: body
        size: len_body

enums:
  record_type:
    0x40002: abstract_hash_identifier
    0x40070: header
    0x40071: filename_header
    0x40072: empty
    0x4100f: tse_string_table_main
    0x41150: tse_texture_header
    0x40151: tse_texture_data
    0x801151: tse_texture_data_2
    0x800151: tse_texture_data_ps3
    0x202151: tse_texture_data_wii
    0x41007: tse_render_sprite
    0x43087: tse_font_descriptor_data
    0x42087: tse_font_descriptor_data_v1
    0x43083: tse_data_table_data_1
    0x4008a: tse_data_table_data_2
    0x45100: clank_body_template_main
    0x402100: clank_body_template_secondary
    0x43100: clank_body_template_name
    0x44100: clank_body_template_data
    0x404100: clank_body_template_data_2
    0x4300c: lite_script_main
    0x4200c: lite_script_data
    0x4100c: lite_script_data_2
    0x204090: squeak_sample_data
    0x204092: squeak_stream_data
    0x201092: squeak_stream_data_2
    0x101050: render_model_template_header
    0x40054: render_model_template_data
    0x20055: render_model_template_data_table
    0x42005: animation_data
    0x41005: animation_data_2
    0x43112: effects_params_data
    0x43088: state_flow_template_data
    0x42088: state_flow_template_data_2
    0x42009: entity_placement_data
    0x103009: entity_placement_data_2
    0x101009: entity_placement_bcc_data
    0x102009: entity_placement_level_data
    0x101008: entity_template_data
