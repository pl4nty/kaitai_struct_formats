# Imported from https://github.com/OK-DMR/dmr-kaitai/blob/7489ff1a8b418e3d37e2a0268acbaf2710543d93/okdmr/kaitai/hytera/datetimestring.ksy
# Licence and copyright: see _community/README.md
meta:
  id: datetimestring
  title: Hytera date and time string
  license: AGPL-3.0-only
doc: time in format yyyyMMddhhmmss, timezone GMT
seq:
  - id: datetime
    size: 14
    type: str
    encoding: UTF-8
