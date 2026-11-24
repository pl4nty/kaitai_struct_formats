# Imported from https://github.com/Kokoroou/rpgmaker-assets-viewer/blob/fde26ab45e1440711f26bb9f8b5754e98a8645e4/docs/formats/rpgmvp.ksy
meta:
  id: rpgmaker_mv_encrypted_asset
  title: RPG Maker MV/MZ encrypted asset (.rpgmvp, .png_, .rpgmvo, .ogg_, .rpgmvm, .m4a_)
  file-extension:
    - rpgmvp
    - png_
    - rpgmvo
    - ogg_
    - rpgmvm
    - m4a_
  license: MIT
  endian: be
doc: |
  Implemented in js/decrypt-mvmz.js; reference: uuksu/RPGMakerDecrypter (MIT).
  Only the first 16 bytes of the real file are encrypted: they are XORed with the
  16-byte key stored as hex in data/System.json ("encryptionKey"). The rest is
  plain.
  Kaitai cannot express the XOR step, so `encrypted_head` is raw ciphertext:
  real_file = (encrypted_head XOR key) + rest.
  Key recovery for images: every PNG starts with the same 16 bytes, so
  key = encrypted_head XOR PNG prefix (see deriveKeyFromPNG()).
seq:
  - id: magic
    contents: [0x52, 0x50, 0x47, 0x4d, 0x56, 0, 0, 0, 0, 3, 1, 0, 0, 0, 0, 0]
    doc: '"RPGMV" + version bytes; same for MV and MZ'
  - id: encrypted_head
    size: 16
    doc: first 16 bytes of the original file, XORed with the key
  - id: rest
    size-eos: true
    doc: remainder of the original file, unmodified
