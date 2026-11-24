# Imported from https://github.com/foreverWIP/cosmic/blob/eeb0141db5eb5cafbaed46e0a61f22afc5f87617/Cosmic.Formats/defs/pascal_string.ksy
meta:
  id: cosmic_pascal_string
  title: Cosmic Engine length-prefixed string
  license: LicenseRef-RSDK-Decompilation-1-C
seq:
  - id: length
    type: u1
  - id: contents
    size: length
    type: str
    encoding: ASCII
