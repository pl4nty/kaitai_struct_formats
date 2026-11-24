# Imported from https://github.com/OK-DMR/dmr-kaitai/blob/7489ff1a8b418e3d37e2a0268acbaf2710543d93/okdmr/kaitai/hytera/intervalstring.ksy
# Licence and copyright: see _community/README.md
meta:
  id: intervalstring
  title: Hytera interval string
  license: AGPL-3.0-only
doc: interval in format ddhhmmss, eg. “00010000” means every 1 hour
seq:
  - id: interval
    size: 8
    type: str
    encoding: UTF-8
