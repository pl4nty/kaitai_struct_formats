# Imported from https://github.com/pkooiman/Xerox645S_disks/blob/ffda34984f11e8b73afbebbc05c427ff13686cc5/memorywriter_sectoraddress.ksy
meta:
  id: memorywriter_sectoraddress
  title: Xerox MemoryWriter 645S sector addressing
  license: LicenseRef-All-Rights-Reserved


  # Sectors are addressed by track and sector within a track 
  # Tracks are numbered from 0-39 
  # Sectors in a track are numbered from 1-16
seq:
  - id: track
    type: u1
  - id: sector
    type: u1
instances:
  offset:
    value: 'sector == 0 ? 0: 256 * (track * 16 + (sector - 1))'
    doc: Offset in image corresponding to the sector address
