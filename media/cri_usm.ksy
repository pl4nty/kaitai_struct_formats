# Imported from https://github.com/remixer-dec/GameTranslationPipelines/blob/b145e6972ee8ae8ed121c0ea64ffa49fbf71a189/3DS/Sonic%20Lost%20World/TranslatorUI/USM.ksy
meta:
  id: cri_usm
  title: Sonic Lost World (3DS) USM stream with video, audio and text chunks
  file-extension: usm
  license: LicenseRef-All-Rights-Reserved
  endian: le
seq:
  - id: magic
    contents: "CRID"
  - id: data_start
    type: u4be
    doc: does not include first 8 bytes
  - id: meta_start
    type: u2be
  - id: unk
    type: u1
    repeat: expr
    repeat-expr: 6
  - id: unk2
    type: u8be
  - id: zero
    type: u8be
  - id: meta_chunk
    type: chunk

instances:
  stream:
    pos: 8 + data_start
    type: chunkstream
    
types:
  chunkdata:
    seq:
      - id: offset
        type: u2be
      - id: backoffset
        type: u2be
        if: offset > 0
      - id: unknown
        size: offset - 4
        if: offset > 0
      - id: data
        size: _parent.chunk_size - offset
        type:
          switch-on: _parent.chunk_type
          cases:
            '"SBT"': sbt_chunk
        if: offset > 0
      - id: metachunk_data
        size: _parent.chunk_size - offset - 2
        if: offset == 0
        
  chunk:
    seq: 
      - id: head
        contents: '@'
      - id: chunk_type
        size: 3
        type: str
        encoding: UTF-8
      - id: chunk_size
        type: u4be
      - id: chunk_content
        size: chunk_size
        type: chunkdata
        
  chunkstream:
    seq:
      - id: stream_chunks
        type: chunk
        repeat: until
        repeat-until: _io.eof
  sbt_chunk:
    seq:
      - id: lang_id
        type: u4
      - id: unknown
        type: u4
        repeat: expr
        repeat-expr: 3
        doc: 0 - ??, 1st is probably timestamp and 2nd is probably duration
      - id: text_length
        type: u4
      - id: text
        size: text_length - 4
        type: str
        encoding: UTF-16LE
        if: text_length < 65535
    instances:
      system_text:
        pos: 0
        size-eos: true
        type: str
        encoding: UTF-8
        if: text_length > 65535
