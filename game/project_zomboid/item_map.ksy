# Imported from https://github.com/cff29546/pzdataspec/blob/3d39699f74bb13c9269d2f625e7883648a95da5e/data_spec/spec/251/item/map.ksy
meta:
  id: item_map
  title: 'Project Zomboid save: map inventory item'
  license: MIT
  imports:
    - common
  endian: be

params:
  - id: context
    type: any
  - id: world_version
    type: u4

# zombie.inventory.types.MapItem.save / load
# Extends: InventoryItem
seq:
  - id: map_id
    type: common::string_utf
  - id: symbols
    type: map_symbols

types:
  map_symbols:
    seq:
      - id: symbols_version
        type: s2
      - id: save_data
        type: symbol_save_data
        if: symbols_version >= 2
      - id: num_symbols
        type: s4
      - id: symbols
        type: map_symbol(symbols_version)
        repeat: expr
        repeat-expr: num_symbols

  symbol_save_data:
    doc: Global font metadata for text symbols
    seq:
      - id: num_fonts
        type: u1
      - id: fonts
        type: common::string_utf
        repeat: expr
        repeat-expr: num_fonts

  map_symbol:
    params:
      - id: symbols_version
        type: s2
    seq:
      - id: symbol_type
        type: u1
      - id: base_data
        type: symbol_base_data(symbols_version)
      - id: type_data
        type:
          switch-on: symbol_type
          cases:
            0: symbol_text_data(symbols_version)
            1: symbol_texture_data(symbols_version)

  symbol_base_data:
    doc: Common fields in WorldMapBaseSymbol
    params:
      - id: symbols_version
        type: s2
    seq:
      - id: x
        type: f4
      - id: y
        type: f4
      - id: anchor_x
        type: f4
      - id: anchor_y
        type: f4
      - id: scale
        type: f4
      - id: rotation
        type: f4
        if: symbols_version >= 2
      - id: color
        type: common::color_rgba
      - id: collide
        type: u1
      - id: flags
        type: u1
        if: symbols_version >= 2
      - id: min_zoom
        type: f4
        if: symbols_version >= 2 and (flags & 0x04) != 0
      - id: max_zoom
        type: f4
        if: symbols_version >= 2 and (flags & 0x08) != 0

  symbol_text_data:
    doc: WorldMapTextSymbol specific fields
    params:
      - id: symbols_version
        type: s2
    seq:
      - id: text
        type: common::string_utf
      - id: translated
        type: u1
      - id: font_index
        type: u1
        if: symbols_version >= 2

  symbol_texture_data:
    doc: WorldMapTextureSymbol specific fields
    params:
      - id: symbols_version
        type: s2
    seq:
      - id: symbol_id
        type: common::string_utf
