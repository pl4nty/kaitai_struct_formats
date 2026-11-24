# Imported from https://github.com/pkooiman/Xerox645S_disks/blob/ffda34984f11e8b73afbebbc05c427ff13686cc5/memorywriter_exec.ksy
meta:
  id: memorywriter_exec
  title: Xerox MemoryWriter 645S executable disk file
  license: LicenseRef-All-Rights-Reserved


seq:
  - id: chunks
    type: chunk_t 
    repeat: eos


types:
  chunk_header_t:
    seq:
      - id: chunktype
        type: u1
      - id: chunksize
        type: u2le
  chunk_t:
    seq:
      - id: header
        type: chunk_header_t
      - id: body
        size: header.chunksize - 1
        type:
          switch-on: header.chunktype
          cases:
            6: load_chunk
            _: unknown_chunk
      - id: checksum
        type: u1
      
            
  load_chunk:
    seq:
      - id: unknown
        type: u1
      - id: loadaddress
        type: u2le
      - id: data
        size-eos: true
  unknown_chunk:
    seq:
      - id: data
        size-eos: true
  
