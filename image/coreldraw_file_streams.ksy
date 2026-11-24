# Imported from https://github.com/kaitai-io/coreldraw_cdr.ksy/blob/9d8e2704b946961f5114115f1a488750a3c86ed0/file_streams.ksy
# Licence and copyright: see _community/README.md
meta:
  id: coreldraw_file_streams
  title: Type for cdr_unpk.ksy file streams
  license: MIT
  encoding: ASCII
  endian: be
doc: |
  Avoids circular dependency cdr_unpk.ksy <-> coreldraw_cdr.ksy

  With this type, the dependency tree looks like this, which is fine:

             cdr_unpk
            /        \
           v          v
  coreldraw_cdr -> coreldraw_file_streams

seq:
  - id: files
    type: file
    repeat: eos
types:
  slot: {}
  file:
    seq:
      - id: len_name
        type: u1
      - id: name
        size: len_name
        type: str
      - id: len_body
        type: u4
      - id: body
        size: len_body
        type: slot
