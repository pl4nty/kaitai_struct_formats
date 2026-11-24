# Imported from https://github.com/izzyreal/mpc2000xl_kaitai/blob/d08b543e1abe96b7ecca74e09173ab8d6055bef7/mpc2000xl.mid.ksy
meta:
  id: akai_mpc2000xl_mid
  title: Akai MPC2000XL MIDI sequence (.mid)
  file-extension: mid
  license: LicenseRef-All-Rights-Reserved
  imports:
    - standard_midi_file
  bit-endian: le

# Known producers currently evidenced:
# - MPC2000XL OS 1.20
    
seq:
  - id: hdr
    type: standard_midi_file::header
  - id: tracks
    type: standard_midi_file::track
    repeat: expr
    repeat-expr: hdr.num_tracks
        
instances:
  meta_events:
    value: tracks[0].events.event
  
  first_meta:
    value: meta_events[0].meta_event_body
  
  is_mpc2000xl_mid:
    value: tracks.size > 0 and meta_events.size > 0 and
           meta_events[0].event_type == 0xF0 and
           first_meta.len.value == 32 and
           first_meta.body.to_s("ASCII").substring(0, 16)
            == "MPC2000XL 1.00  "
            
  sequence_name:
    value: first_meta.body.to_s("ASCII").substring(16, 32)

  sequencer:
    io: tracks[0].events._io
    pos: 40
    type: sequencer
  
  tempo_bpm:
    value: 60000000.0 /
           ((meta_events[2].meta_event_body.body[0] << 16) +
           (meta_events[2].meta_event_body.body[1] << 8) +
           meta_events[2].meta_event_body.body[2])
  
  smpte_offset:
    value: meta_events[3].meta_event_body.body
  
  numerator:
    value: meta_events[4].meta_event_body.body[0]
    
  denominator:
    value: 1 << meta_events[4].meta_event_body.body[1]
  
types:
  sequencer:
    seq:
      - contents: 'LOOP='
      - id: loop_enabled
        size: 4
        type: str
        encoding: ASCII
      - contents: 'START='
      - id: loop_start
        size: 4
        type: str
        encoding: ASCII
      - contents: 'END='
      - id: loop_end
        size: 4
        type: str
        encoding: ASCII
      - contents: 'TEMPO='
      - id: tempo_source
        size: 3
        type: str
        encoding: ASCII
    
