# Imported from https://github.com/deefha/klan2016-re/blob/e48e34b7abbc9da902e03c0763f48bb7ede2582f/structs/music_v2.ksy
meta:
  id: klan_music_v2
  title: KLAN music library v2
  application: KLAN discmag engine
  file-extension: lib
  license: LicenseRef-All-Rights-Reserved
  imports:
    - klan_t_header
  encoding: ASCII
  endian: le

doc-ref: https://wiki.klan2016.cz/knihovny/hudba.html

seq:
  - id: header
    type: klan_t_header
  - id: header2
    type: t_header2
  - id: fat_mods
    type: t_fat_mods
  - id: fat_samples
    type: t_fat_samples
  - id: data
    type: t_data

types:
  t_header2:
    seq:
      - id: count_mods
        type: u4
      - id: count_samples
        type: u4
      - id: foo
        size: 24

  t_fat_mods:
    seq:
      - id: offsets
        type: u4
        repeat: expr
        repeat-expr: 256

  t_fat_samples:
    seq:
      - id: offsets
        type: u4
        repeat: expr
        repeat-expr: 1024

  t_data:
    seq:
      - id: names
        size: 32
        repeat: expr
        repeat-expr: 128
    instances:
      mods:
        type: t_mod(_parent.fat_mods.offsets[_index])
        repeat: expr
        repeat-expr: 256
      samples:
        type: t_sample(_parent.fat_samples.offsets[_index])
        repeat: expr
        repeat-expr: 1024
      
  t_mod:
    params:
      - id: param_offset
        type: u4
    instances:
      content:
        pos: param_offset
        type: t_mod_content
        if: param_offset != 0

  t_mod_content:
    seq:
      - id: name
        size: 32
      - id: count_samples
        type: u4
      - id: size_patterns
        type: u4
      - id: foo_1
        type: u4
      - id: foo_2
        type: u4
      - id: data
        type: t_mod_data(size_patterns)

  t_mod_data:
    params:
      - id: param_size_patterns
        type: u4
    seq:
      - id: samples
        type: u2
        repeat: expr
        repeat-expr: 256
      - id: foo
        size: 80
      - id: patterns
        size: param_size_patterns

  t_sample:
    params:
      - id: param_offset
        type: u4
    instances:
      content:
        pos: param_offset
        type: t_sample_content
        if: param_offset != 0

  t_sample_content:
    seq:
      - id: data_size
        type: u4
      - id: foo
        size: 28
      - id: data
        type: t_sample_data(data_size)

  t_sample_data:
    params:
      - id: param_data_size
        type: u4
    seq:
      - id: content
        size: param_data_size
