# Imported from https://github.com/mitchellwaite/Xbox-360-Notes/blob/1a50a058822d0a56d78d78c42d6ea7e7d32aa561/kaitai_struct_defs/xb360_2bl.ksy
# Based on the following resources:
#
# https://github.com/InvoxiPlayGames/xenon-bltool/blob/master/include/xenon-bootloader.h#L58
# https://github.com/GoobyCorp/Xbox-360-Crypto/blob/master/build_lib.py

meta:
  id: xbox360_2bl
  file-extension: xb360_2bl
  license: LicenseRef-All-Rights-Reserved
  endian: be
  
seq:
  - id: header
    type: generic_bl_header
  - id: cb_sb_header
    type: cb_sb_header
  - id: code
    size: header.size - 0x3C0

types:
  generic_bl_header:
    seq:
      - id: magic
        size: 2
        type: str
        encoding: ASCII
      - id: version
        type: u2
      - id: qfe
        type: u2
      - id: flags
        type: u2
      - id: entrypoint
        type: u4
      - id: size
        type: u4
  
  cb_sb_header:
    seq:
      - id: nonce
        size: 0x10
        
      - id: pairing
        size: 0x3
      - id: ldv
        type: u1
        doc: Retail BL chains will ignore the patch slots if this is set to the CF LDV
      - id: padding
        size: 0xC
      - id: cb_auth_hash_per_box_digest
        size: 0x10
        doc: This must be recalculated if the LDV is changed
      - id: signature
        type: xe_crypt_sig
      - id: globals
        size: 0x128
      - id: devkit_rsa_pub_key
        type: xe_crypt_rsa_2048
      - id: sc_key
        size: 0x10
      - id: sc_salt
        size: 10
        type: str
        encoding: ASCII
      - id: sd_salt
        size: 10
        type: str
        encoding: ASCII
      - id: next_bl_hash
        size: 0x14
      - id: more_globals
        size: 0x10
        
  xe_crypt_sig:
    seq:
      - id: padding
        type: u8
        repeat: expr
        repeat-expr: 28
      - id: one
        type: u1
      - id: salt
        size: 10
      - id: hash
        size: 20
      - id: end
        type: u1
  
  xe_crypt_rsa_common:
    seq:
      - id: num_digits
        type: u4
      - id: pub_exponent
        type: u4
      - id: reserved
        type: u8
  
  xe_crypt_rsa_2048:
    seq:
      - id: header
        type: xe_crypt_rsa_common
      - id: modulus
        type: u8
        repeat: expr
        repeat-expr: 32
        
