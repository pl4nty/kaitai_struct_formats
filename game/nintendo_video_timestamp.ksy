# Imported from https://github.com/Nintendo-Video-research-project/Kaitais/blob/d5e1ee1f171a6361fd23b08ad0c1f66a53e764e2/kaitais/timestamp.ksy
meta:
  id: nintendo_video_timestamp
  title: Nintendo Video timestamp
  license: LicenseRef-All-Rights-Reserved
  endian: le

seq:
  - id: release_date
    type: nintendo_video_timestamp
    
  - id: expiry_date
    type: nintendo_video_timestamp

types:
  timestamp:
    seq:
      - id: year
        type: u4
      - id: day
        type: u4
      - id: hour
        type: u4
      - id: minutes
        type: u4
      - id: seconds
        type: u4
      - id: padding
        size: 4
