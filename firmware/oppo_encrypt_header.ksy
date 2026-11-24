# Imported from https://github.com/armijnhemel/binaryanalysis-ng/blob/d72f0d9c5c4e5484878f357d07690e68334365db/src/bang/parsers/firmware/oppo_encrypt_header/oppo_encrypt_header.ksy
# Licence and copyright: see _community/README.md
meta:
  id: oppo_encrypt_header
  title: OPPO encrypt header
  license: CC0-1.0
  ks-version: 0.9
  encoding: UTF-8
  endian: le
doc-ref:
  - https://web.archive.org/web/20190304142705/https://gist.github.com/wfjsw/7c8763dfd543b49b2a3ebf089acc83b0
  - https://web.archive.org/web/20221208034118/https://bkerler.github.io/reversing/2019/04/24/the-game-begins/
seq:
  - id: signature
    size: 16
    contents: ["OPPOENCRYPT!", 0, 0, 0, 0]
  - id: size_str
    size: 16
    type: strz
  - id: sha1
    size: 48
    type: strz
  - id: reconstruct
    size: 0x1000
    #type: strz
    type: reconstruct
instances:
  decompressed_size:
    value: size_str.to_i
types:
  reconstruct:
    instances:
      reconstruct_string:
        pos: 0
        type: strz
      reconstruct_components:
        pos: 0
        type: str
        terminator: 0x0a
        eos-error: false
        repeat: eos
