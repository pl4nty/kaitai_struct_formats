# Imported from https://github.com/jumpjack/mars-pathfinder-meshes/blob/402f97d20ba3081551131a044c73464401ec2118/PPM.ksy
# Licence and copyright: see _community/README.md
meta:
  id: mars_pathfinder_ppm
  file-extension: ppm
  license: Apache-2.0
  endian: be

seq:
  - id: hdr
    type: header
  - id : image
    type: image_data
instances:
  width:
    value: hdr.width
    
  height:
    value: hdr.height

types:
  header:
    seq:
      - id: magic
        type: u2
      - id: separator1
        size : 1
      - id : comment
        type: str
        terminator: 0x0A
        encoding : ASCII
      - id : width
        type: str
        terminator: 0x20
        encoding : ASCII
      - id : height
        type: str
        terminator: 0x0a
        encoding : ASCII
      - id : depth
        type: str
        terminator: 0x0a
        encoding : ASCII
  image_data:
    seq:
      - id : data
        size : _parent.width.to_i(10) * _parent.height.to_i(10) * 3
  strnum        :
    seq:
      - id : figure1
        type : u1
      - id : figure2
        type : u1
      - id : figure3
        type : u1
      - id : sep
        size : 1
      - id : figure1a
        type : u1
      - id : figure2a
        type : u1
      - id : figure3a
        type : u1
      - id : term
        size : 1
