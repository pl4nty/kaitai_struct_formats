# Imported from https://github.com/armijnhemel/binaryanalysis-ng/blob/d72f0d9c5c4e5484878f357d07690e68334365db/src/bang/parsers/database/gvariant/gvariant.ksy
# Licence and copyright: see _community/README.md
meta:
  id: gvariant
  title: GVariant
  license: LGPL-2.1-or-later
  endian: le
doc-ref: https://github.com/GNOME/gvdb/blob/main/gvdb/gvdb-format.h
seq:
  - id: signature
    contents: 'GVariant'
  - id: version
    type: u4
  - id: options
    type: u4
  - id: root
    type: pointer
types:
  pointer:
    seq:
      - id: start
        type: u4
      - id: end
        type: u4
    instances:
      data:
        pos: start
        size: end - start
        type: hash_header
  hash_header:
    seq:
      - id: n_bloom_words
        type: u4
      - id: n_buckets
        type: u4
    instances:
      num_bloom_words:
        value: 'n_bloom_words & ((1 << 27) - 1)'
