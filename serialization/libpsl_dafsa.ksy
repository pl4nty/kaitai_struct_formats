meta:
  id: libpsl_dafsa
  title: libpsl binary DAFSA (Public Suffix List)
  application:
    - libpsl
    - psl-make-dafsa
  file-extension: dafsa
  license: CC0-1.0
  ks-version: '0.9'
doc: |
  Binary form of a deterministic acyclic finite state automaton (DAFSA), as
  written by `psl-make-dafsa --output-format=binary` from libpsl and loaded
  by `psl_load_file()`. Linux distributions ship the Public Suffix List in
  this form (e.g. `/usr/share/publicsuffix/public_suffix_list.dafsa`). The
  encoding of the graph comes from Chromium's `make_dafsa.py`.

  The file is a 16-byte header (`.DAFSA@PSL_0`, padded with spaces and
  ending with a newline), the encoded graph, and an optional trailing byte
  0x01 that marks a DAFSA generated in UTF-8 mode.

  The graph starts with the list of links from the source node. A node is a
  label of characters, where the last one has its high bit set, followed by
  a list of links to its children, or, for a node that ends a word, a label
  whose last byte is a return value (0x80-0x8F). A node may also be a
  "prefix" without a terminated label, which is directly followed by its
  only child; this spec reads such a prefix together with the child's label.
  A link is a 1-, 2- or 3-byte distance, the high bit marking the last link
  of a list. The first distance is counted from the start of the list, the
  next ones from the previous child. The graph is a DAG, so the same node can
  be reached through several paths.

  In UTF-8 mode, a byte 0x1F in a label starts a multibyte sequence whose
  bytes are stored shifted into the range 0x40-0x7F.

  For the Public Suffix List, the return value is a combination of flags:
  0x01 exception rule, 0x02 wildcard rule, 0x04 ICANN section, 0x08 private
  section.
doc-ref:
  - https://github.com/rockdaboot/libpsl/blob/88331dae18f1824ab033f7e77880cf65814fc21a/src/psl-make-dafsa
  - https://github.com/rockdaboot/libpsl/blob/88331dae18f1824ab033f7e77880cf65814fc21a/src/lookup_string_in_fixed_set.c
seq:
  - id: magic
    contents: .DAFSA@PSL_
  - id: version
    size: 1
    type: str
    encoding: ASCII
    doc: Format version digit, `0`.
  - id: header_padding
    contents: "   \n"
  - id: graph
    size: '_io.size - _io.pos - (is_utf8_mode ? 1 : 0)'
    type: graph
instances:
  last_byte:
    pos: _io.size - 1
    type: u1
    doc: |
      Last byte of the file: 0x01 in UTF-8 mode, otherwise the last byte of the graph,
      which is always a return value byte (0x80-0x8F).
  is_utf8_mode:
    value: last_byte == 1
types:
  graph:
    instances:
      source:
        pos: 0
        type: link_list(0)
        doc: Links from the source node to the first nodes.
  link_list:
    params:
      - id: ofs_start
        type: u4
        doc: Offset of the list in the graph.
    seq:
      - id: links
        type: 'link(_index == 0 ? ofs_start : links[_index - 1].ofs_child)'
        repeat: until
        repeat-until: _.is_last
  link:
    params:
      - id: ofs_base
        type: u4
        doc: Offset the distance is counted from.
    seq:
      - id: first_byte
        type: u1
      - id: second_byte
        type: u1
        if: num_bytes >= 2
      - id: third_byte
        type: u1
        if: num_bytes == 3
    instances:
      num_bytes:
        value: |
          (first_byte & 0x60) == 0x60 ? 3
            : (first_byte & 0x60) == 0x40 ? 2
            : 1
      is_last:
        value: first_byte & 0x80 != 0
        doc: True for the last link of the list.
      distance:
        value: |
          num_bytes == 3 ? ((first_byte & 0x1f) << 16) | (second_byte << 8) | third_byte
            : num_bytes == 2 ? ((first_byte & 0x1f) << 8) | second_byte
            : first_byte & 0x3f
      ofs_child:
        value: ofs_base + distance
        doc: Offset of the child node in the graph.
      child:
        pos: ofs_child
        type: node
  node:
    seq:
      - id: label
        type: u1
        repeat: until
        repeat-until: _ >= 0x80
        doc: |
          Characters of the node (including any prefixes directly followed by this
          node). All bytes but the last are characters; the last one is a character
          with its high bit set or, in a node that ends a word, a return value.
      - id: children
        type: link_list(_io.pos)
        if: not is_word_end
    instances:
      last_byte:
        value: label[label.size - 1]
      is_word_end:
        value: (last_byte & 0xf0) == 0x80
        doc: True if the node ends a word and has no children.
      return_value:
        value: last_byte & 0x0f
        if: is_word_end
        doc: Value associated with the word.
      last_char:
        value: last_byte & 0x7f
        if: not is_word_end
        doc: The last character of the label.
