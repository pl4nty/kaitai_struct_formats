# Imported from https://github.com/sorche942/koa-formats-kaitai/blob/efc04be2db704e88200d287aa5c583c05ec09282/koa_batch_lua.ksy
meta:
  id: koa_batch_lua
  title: Kingdoms of Amalur .batch (Lua variant)
  file-extension: batch
  license: LicenseRef-All-Rights-Reserved
  ks-version: 0.9
  endian: le

doc: |
  Format used by Kingdoms of Amalur: Re-Reckoning to bundle Lua scripts.
  Commonly seen as klua.batch, ksmt.batch, and loot.batch.
  
  The file consists of a count, an index of (ID, Size) pairs, and a 
  packed data section where entries are stored sequentially.

seq:
  - id: num_entries
    type: u4
    doc: Total number of entries in this batch file.
  - id: index
    type: index_entry
    repeat: expr
    repeat-expr: num_entries
    doc: Index table for random access to entries.
  - id: entries
    type: entry
    repeat: expr
    repeat-expr: num_entries
    doc: Sequential list of data entries.

types:
  index_entry:
    seq:
      - id: id
        type: u4
        doc: Resource ID or Hash.
      - id: size
        type: u4
        doc: Total size of the corresponding data entry in bytes.

  entry:
    seq:
      - id: body
        size: _parent.index[_index].size
        type: klua_payload
        doc: The actual data for this entry, scoped by the size from the index.

  klua_payload:
    seq:
      - id: script_name
        type: len_string
        doc: The internal name of the Lua script or class (e.g., 'ConditionMgr').
      - id: num_hooks
        type: u4
        doc: Number of string hooks or keys associated with this script.
      - id: hooks
        type: len_string
        repeat: expr
        repeat-expr: num_hooks
        doc: List of hook names (e.g., 'ACTOR.run_loot_table').
      - id: lua_bytecode_len
        type: u4
        doc: Size of the compiled Lua bytecode block.
      - id: lua_bytecode
        size: lua_bytecode_len
        doc: The raw compiled Lua bytecode (starts with \x1bLua).

  len_string:
    seq:
      - id: len
        type: u4
      - id: value
        size: len
        type: str
        encoding: UTF-8
