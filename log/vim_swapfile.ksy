# Imported from https://github.com/armijnhemel/binaryanalysis-ng/blob/d72f0d9c5c4e5484878f357d07690e68334365db/src/bang/parsers/editor/vim_swapfile/vimswapfile.ksy
# Licence and copyright: see _community/README.md
meta:
  id: vim_swapfile
  title: Vim swap file
  license: CC0-1.0
  encoding: ASCII
  endian: le
doc: |
  Vim swap file, see `runtime/doc/recover.txt` in the Vim source code and
  `block0` in `memline.c`
seq:
  - id: header
    type: header
  - id: header_padding
    size: header.len_page - header._sizeof
  - id: blocks
    size: header.len_page
    type: block
    repeat: eos
types:
  header:
    seq:
      - id: magic
        contents: "b0"
      - id: version
        size: 10
        type: version
      - id: len_page
        -orig-id: b0_page_size
        type: u4
      - id: mtime
        size: 4
      - id: inode
        type: u4
      - id: pid
        type: u4
      - id: user_name
        size: 40
        type: strz
      - id: host_name
        size: 40
        type: strz
      - id: file_name
        size: 900
        type: strz
      - id: magic_long
        type: u8
      - id: magic_int
        type: u4
      - id: magic_short
        type: u2
      - id: magic_char
        contents: [0x55]
  version:
    seq:
      - id: vim
        contents: "VIM "
      - id: major
        type: u1
      - id: dot
        contents: "."
      - id: minor
        type: u1
  block:
    seq:
      - id: magic
        size: 2
        type: str
        valid:
          any-of: ['"ad"', '"tp"']
      - id: block_contents
        type:
          switch-on: magic
          cases:
            '"ad"': data_block
            '"tp"': pointer_block
  data_block:
    seq:
      - id: free_space
        type: u4
      - id: text_start
        type: u4
      - id: text_end
        type: u4
  pointer_block:
    seq:
      - id: num_pointer
        type: u2
      - id: pointer_count_max
        type: u2
      #- id: pointer_entries
        #type: pointer_entry
        #repeat: expr
        #repeat-expr: num_pointer
  pointer_entry:
    seq:
      - id: block_number
        type: u8
      - id: line_number
        type: u8
      - id: old_line_number
        type: u8
      - id: page_count
        type: u4
