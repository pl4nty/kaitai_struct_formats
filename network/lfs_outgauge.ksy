# Imported from https://github.com/Worty/outgaugelistener/blob/b6fa4b6a843a19ef4c031ae246f6f4fbb08bda97/protocol.ksy
meta:
  id: lfs_outgauge
  title: Live for Speed OutGauge packet
  license: MIT
  endian: le
seq:
  - id: time
    type: u4
  - id: car
    size: 4
    type: str
    encoding: ASCII
  - id: flags
    type: u2
  - id: gear
    type: u1
  - id: plid
    type: u1
  - id: speed
    type: f4
  - id: rpm
    type: f4
  - id: turbo
    type: f4
  - id: engtemp
    type: f4
  - id: fuel
    type: f4
  - id: oilpressure
    type: f4
  - id: oiltemp
    type: f4
  - id: dashlights
    type: u4
  - id: showlights
    type: u4
  - id: throttle
    type: f4
  - id: brake
    type: f4
  - id: clutch
    type: f4
  - id: display1
    size: 16
  - id: display2
    size: 16
  - id: id
    type: u4
    
instances:
  og_turbo:
    value: (flags & 1<<13) >> 13
  og_km:
    value: (flags & 1<<14) >> 14
  og_bar:
    value: (flags & 1<<15) >> 15
    
  dl_shift:
    value: (dashlights & 1<<0) >> 0
  dl_fullbeam:
    value: (dashlights & 1<<1) >> 1
  dl_handbrake:
    value: (dashlights & 1<<2) >> 2
  dl_tc:
    value: (dashlights & 1<<4) >> 4
  dl_signal_l:
    value: (dashlights & 1<<5) >> 5
  dl_signal_r:
    value: (dashlights & 1<<6) >> 6
  dl_oilwarn:
    value: (dashlights & 1<<8) >> 8
  dl_battery:
    value: (dashlights & 1<<9) >> 9
  dl_abs:
    value: (dashlights & 1<<10) >> 10
  sl_shift:
    value: (dashlights & 1<<0) >> 0
  sl_fullbeam:
    value: (dashlights & 1<<1) >> 1
  sl_handbrake:
    value: (dashlights & 1<<2) >> 2
  sl_tc:
    value: (dashlights & 1<<4) >> 4
  sl_signal_l:
    value: (dashlights & 1<<5) >> 5
  sl_signal_r:
    value: (dashlights & 1<<6) >> 6
  sl_oilwarn:
    value: (dashlights & 1<<8) >> 8
  sl_battery:
    value: (dashlights & 1<<9) >> 9
  sl_abs:
    value: (dashlights & 1<<10) >> 10
  
