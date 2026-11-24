meta:
  id: apkmirror_apkm
  title: APKMirror encrypted APK bundle (APKM)
  application: APKMirror Installer
  file-extension: apkm
  license: CC0-1.0
  ks-version: '0.9'
  endian: le
doc: |
  `.apkm` files distributed by APKMirror are ZIP archives of split APKs,
  encrypted with libsodium. The file starts with a small header carrying
  the parameters of the password-based key derivation
  (`crypto_pwhash`, Argon2i or Argon2id, with a fixed password built into
  the installer, and the salt) and the 24-byte
  `crypto_secretstream_xchacha20poly1305` header. It is followed by the
  encrypted stream, in chunks of `len_chunk` plaintext bytes plus 17
  bytes of authentication overhead each (the last chunk may be shorter).

  Decryption is out of scope; this spec only frames the header and the
  ciphertext chunks.
doc-ref: https://github.com/MuntashirAkon/unapkm-android/blob/0cc2ced9ae0c227aa86c18a85e984f879247922a/app/src/main/java/com/souramoo/unapkm/UnApkm.java
seq:
  - id: unknown1
    type: u1
    doc: Skipped by the reference reader.
  - id: pwhash_alg
    type: u1
    enum: pwhash_alg
    valid:
      any-of:
        - pwhash_alg::argon2i13
        - pwhash_alg::argon2id13
  - id: ops_limit
    type: u8
    doc: crypto_pwhash opslimit.
  - id: mem_limit
    type: u8
    doc: crypto_pwhash memlimit in bytes.
  - id: len_chunk
    type: u8
    doc: Plaintext size of each secretstream chunk.
  - id: salt
    size: 16
    doc: crypto_pwhash salt.
  - id: secretstream_header
    size: 24
    doc: crypto_secretstream_xchacha20poly1305 header.
  - id: chunks
    type: chunk
    repeat: eos
types:
  chunk:
    seq:
      - id: ciphertext
        size: >-
          _io.size - _io.pos < _root.len_chunk + 17
          ? _io.size - _io.pos
          : _root.len_chunk + 17
        doc: Encrypted chunk (plaintext + 1-byte tag + 16-byte MAC).
enums:
  pwhash_alg:
    1: argon2i13
    2: argon2id13
