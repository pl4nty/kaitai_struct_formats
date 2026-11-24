# Imported from https://gist.githubusercontent.com/rfuzzo/4a078fa095e4b7f793fbe1354e00867a/raw/17d08241dc50433fc739ce123b420dc17f026317/dxbc%20kaitai%20ksy
meta:
  id: dxbc_fx11_effect
  file-extension: fx11obj
  license: LicenseRef-All-Rights-Reserved
  endian: le

seq:
  - id: header
    type: dxbc_header
  - id: chunks
    type: dxbc_chunk
    repeat: expr
    repeat-expr: header.chunk_count
  
types:
  dxbc_header:
    seq:
      - id: magic
        contents: 'DXBC'
      - id: checksum
        size: 16
      - id: unk1
        type: u4
      - id: size
        type: u4
      - id: chunk_count
        type: u4
      - id: chunk_indeces
        type: u4
        repeat: expr
        repeat-expr: chunk_count
  dxbc_chunk:
    seq: 
      - id: fourcc
        type: u4
        enum: chunk_types
      - id: size
        type: u4
      - id: data
        size: size
        type:
          switch-on: fourcc
          cases:
            'chunk_types::isgn': chunk_isgn
            'chunk_types::osgn': chunk_isgn
            'chunk_types::shex': chunk_shex
            'chunk_types::rdef': chunk_rdef
            'chunk_types::stat': chunk_stat
        
    types:  
      chunk_isgn:
        seq:
          - id: element_count
            type: u4
          - id: unk1
            type: u4
          - id: elements
            type: chunk_isgn_element
            repeat: expr
            repeat-expr: element_count
          #- id: string_table
          #  type: strz
          #  encoding: UTF-8
          #  repeat: eos
        types:
          chunk_isgn_element:
            seq:
              - id: offset
                type: u4
              - id: semantic_index
                type: u4
              - id: system_value_type
                type: u4
              - id: component_type
                type: u4
              - id: register
                type: u4
              - id: mask
                type: u1
              - id: read_write_mask
                type: u1
              - id: unk1
                type: u2
            instances:
              element_name:
                pos: offset
                type: strz
                encoding: UTF-8
                
      chunk_rdef:
        seq:
          - id: header
            type: dxbc_chunk_resource_definition
            
        instances:
          const_buffers:
            pos: header.constant_buffer_offset
            type: dxbc_rdef_constant_buffer
            repeat: expr
            repeat-expr: header.const_buffer_count
          dxbc_rdef_bindings:
            pos: header.resource_binding_offset
            type: dxbc_rdef_binding
            repeat: expr
            repeat-expr: header.resource_binding_count
          creator_string:
            pos: header.creator_offset
            type: strz
            encoding: UTF-8
            
        types:
          dxbc_chunk_resource_definition:
            seq: 
              - id: const_buffer_count
                type: u4
              - id: constant_buffer_offset
                type: u4
              - id: resource_binding_count
                type: u4
              - id: resource_binding_offset
                type: u4
              - id: target_version_minor
                type: u1
              - id: target_version_major
                type: u1
              - id: target_program_type
                size: 2
              - id: flags
                type: u4
              - id: creator_offset
                type: u4
              - id: sm5_optional
                type: section_header_sm5
            types:
              section_header_sm5:
                seq:
                  - id: fourcc
                    contents: 'RD11'
                  - id: unk
                    type: u4
                    repeat: expr
                    repeat-expr: 6
          dxbc_rdef_constant_buffer:
            seq: 
              - id: name_offset
                type: u4
              - id: variable_count
                type: u4
              - id: variable_description_offset
                type: u4
              - id: buffer_size
                type: u4
              - id: flags
                type: u4
              - id: type
                type: u4
                
            instances:
              const_buffer_name:
                pos: name_offset
                type: strz
                encoding: UTF-8
              const_buffer_variables:
                pos: variable_description_offset
                type: dxbc_rdef_variable
                repeat: expr
                repeat-expr: variable_count
                
            types:
              dxbc_rdef_type:
                seq:
                  - id: type_class
                    type: u2
                  - id: type_type
                    type: u2
                  - id: rows
                    type: u2
                  - id: columns
                    type: u2
                  - id: element_count
                    type: u2
                  - id: member_count
                    type: u2
                  - id: member_offset
                    type: u4
                  - id: sm5_optional
                    type: dxbc_rdef_type_sm5
                types: 
                  dxbc_rdef_type_sm5:
                    seq: 
                      - id: unk
                        type: u4
                        repeat: expr
                        repeat-expr: 4
                      - id: parent_type_offset
                        type: u4
                        
                    instances: 
                      dxbc_rdef_type_sm5_type:
                        pos: parent_type_offset
                        type: strz
                        encoding: UTF-8
              dxbc_rdef_variable:
                seq:
                  - id: name_offset
                    type: u4le
                  - id: start_offset
                    type: u4le
                  - id: size
                    type: u4le
                  - id: flags
                    type: u4le
                  - id: type_offset
                    type: u4le
                  - id: default_value_offset
                    type: u4le
                  - id: sm5_optional
                    type: dxbc_rdef_variable_sm5
                
                instances:
                  dxbc_rdef_variable_name:
                    pos: name_offset
                    type: strz
                    encoding: UTF-8
                  dxbc_rdef_variable_type:
                    pos: type_offset
                    type: dxbc_rdef_type
                
                types:
                  dxbc_rdef_variable_sm5:
                    seq:
                      - id: start_texture
                        type: u4le
                      - id: texture_size
                        type: u4le
                      - id: start_sampler
                        type: u4le
                      - id: sampler_size
                        type: u4le
                    

          dxbc_rdef_binding:
            seq:
              - id: name_offset
                type: u4
              - id: input_type
                type: u4
              - id: return_type
                type: u4
              - id: dimension
                type: u4
              - id: sample_count
                type: u4
              - id: bind_point
                type: u4
              - id: bind_count
                type: u4
              - id: flags
                type: u4
                
            instances:
              dxbc_rdef_binding_name:
                pos: name_offset
                type: strz
                encoding: UTF-8
                
      chunk_stat:
        seq:
          - id: instruction_count
            type: u4
          - id: temp_register_count
            type: u4
          - id: define_count
            type: u4
          - id: declaration_count
            type: u4
          - id: float_instruction_count
            type: u4
          - id: int_instruction_count
            type: u4
          - id: uint_instruction_count
            type: u4
          - id: static_flow_control_count
            type: u4
          - id: dynamic_flow_control_count
            type: u4
          - id: macro_instruction_count
            type: u4
          - id: temp_array_count
            type: u4
          - id: array_instruction_count
            type: u4
          - id: cut_instruction_count
            type: u4
          - id: emit_instruction_count
            type: u4
          - id: texture_normal_instructions
            type: u4
          - id: texture_load_instructions
            type: u4
          - id: texture_comparison_instructions
            type: u4
          - id: texture_bias_instructions
            type: u4
          - id: texture_gradient_instructions
            type: u4
          - id: mov_instruction_count
            type: u4
          - id: movc_instruction_count
            type: u4
          - id: conversion_instruction_count
            type: u4
          - id: unk1
            type: u4
          - id: input_primitive_for_geometry_shaders
            type: u4
          - id: geometry_shader_primitive_topology
            type: u4
          - id: geometry_shader_max_output_vertex_count
            type: u4
          - id: unk2
            type: u4
          - id: unk3
            type: u4
          - id: is_sample_frequency_shader
            type: u4
          - id: sm5_stats
            type: stat_sm5
        types:
          stat_sm5:
            seq: 
              - id: unk
                type: u4
              - id: control_points
                type: u4
              - id: hull_shader_output_primitive
                type: u4
              - id: hull_shader_partitioning
                type: u4
              - id: tessellator_domain
                type: u4
              - id: barrier_instructions
                type: u4
              - id: interlocked_instructions
                type: u4
              - id: texture_store_instructions
                type: u4
                
      chunk_shex:
        seq:
          - id: header
            type: section_header
          - id: opcodes
            type: opcode
            repeat: eos
        types:
          section_header: 
            seq:
              - id: version_major
                type: b4
              - id: version_minor
                type: b4
              - id: unk
                type: u1
              - id: program_type
                type: u2
              - id: instructions_count
                type: u4
          opcode:
            seq: 
              - id: dword
                type: u4le
              - id: instructions
                type: u4le
                repeat: expr
                repeat-expr: opcode_length
                if: opcode_length > 0
            instances:
              opcode_type:
                value: dword & 0x7ff
              opcode_length:
                value: (dword & 0x7f000000) >> 24
              opcode_is_extended:
                value: (dword & 0x80000000) >> 31
enums:
  chunk_types:
    0x4e475349: isgn
    0x58454853: shex
    0x4e47534f: osgn
    0x46454452: rdef
    0x54415453: stat
