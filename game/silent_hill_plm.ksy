# Imported from https://github.com/shdecompilations/silent-hill-decomp/blob/eb96675c5cb51fe87a66db1df20490c30e5ded6d/docs/file_formats/plm.ksy
meta:
  id: silent_hill_plm
  title: Silent Hill (PSX) Global Map Prop Model Format
  file-extension: plm
  license: GPL-3.0-only
  imports:
    - silent_hill_lm
  encoding: ASCII
  endian: le
  bit-endian: le

doc: |
  PLM is the 3D model format used for global map props in Silent Hill.
  The base format is LM.

seq:
  - id: lm
    type: silent_hill_lm(0)
