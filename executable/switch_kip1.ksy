# Imported from https://github.com/joaquimbc/BinjaNX/blob/1d9a182100aa63f4ab9e97e973093dcae7944710/formats/kip1.ksy
meta:
  id: switch_kip1
  title: Nintendo Switch KIP1 kernel initial process
  license: LicenseRef-All-Rights-Reserved
  endian: le

seq:
  - id: header
    size: 0x100
    type: kip1_header

  - id: body
    type: blz_body
        
  
types:
  kip1_segment:
    seq:
      - id: offset
        type: u4
        
      - id: size
        type: u4
      
      - id: compressed_size
        type: u4
  
  kip1_header:
    seq:
      - id: magic
        contents: "KIP1"
        
      - id: name
        size: 0xC
        type: strz
        encoding: ASCII
      
      - id: program_id
        type: u8
        
      - id: version
        type: u4
      
      - id: mthread_priority
        type: u1
        
      - id: mthread_core_num
        type: u1
      
      - id: reserved0
        type: u1
        
      - id: flags
        type: u1
        
      - id: text_segment
        type: kip1_segment
      
      - id: mthread_affinity_mask
        type: u4
      
      - id: ro_segment
        type: kip1_segment
      
      - id: mthread_stack_size
        type: u4
        
      - id: data_segment
        type: kip1_segment
      
      - id: reserved1
        type: u4
    
      - id: bss_segment
        type: kip1_segment
      
      - id: reserved2
        size: 0x24
        
      - id: kernel_capabilities
        size: 0x80
        
        
  blz_body:
    seq:
      - id: text
        size: _root.header.text_segment.compressed_size
        type: blz_section
      - id: ro
        size: _root.header.ro_segment.compressed_size
        type: blz_section
      - id: data
        size: _root.header.data_segment.compressed_size
        type: blz_section
  
  blz_section:
    seq:
      - id: body
        size: _io.size - 0xC
      - id: footer
        size: 0xC
        type: blz_footer
    
  blz_footer:
    seq:
      - id: compressed_size
        type: u4
      - id: footer_size
        type: u4
      - id: additional_size
        type: u4
