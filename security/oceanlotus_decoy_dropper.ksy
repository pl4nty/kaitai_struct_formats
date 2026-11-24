# Imported from https://github.com/eset/malware-research/blob/f879e217b726ff883e2c23fb5d8c5f5d69a9cacf/oceanlotus/ol_decoy_dropped_files.ksy
meta:
  id: oceanlotus_decoy_dropper
  title: OceanLotus decoy dropper files
  license: BSD-2-Clause
  endian: le
seq:
  - id: total_length
    type: u4
  - id: install_paths_length
    type: u4
  - id: install_paths
    size: install_paths_length
    type: install_paths_struct
  - id: binaries_length
    type: u4
  - id: binaries
    size: binaries_length
    type: binaries_struct
  - id: persistence_length
    type: u4
  - id: persistence_strings
    size: persistence_length
    type: persistence_struct

types:
  utf16_str:
    seq:
      - id: str_len
        type: u4
      - id: str_buf
        size: str_len
        type: str
        encoding: UTF-16LE
  paths_struct:
    seq:
      - id: paths
        type: utf16_str
        repeat: eos
  install_paths_struct:
    seq:
      - id: appdata_path_length
        type: u4
      - id: appdata_paths
        size: appdata_path_length
        type: paths_struct
      - id: progfile_path_length
        type: u4
      - id: progfile_paths
        size: progfile_path_length
        type: paths_struct
  binary_struct:
    seq:
      - id: binary_length
        type: u4
      - id: data
        size: binary_length
  binaries_struct:
    seq:
      - id: binary
        type: binary_struct
        repeat: eos
  persistence_struct:
    seq:
      - id: registry_persistence_length
        type: u4
      - id: regkey_str
        type: utf16_str
      - id: regvalue_str
        type: utf16_str
      - id: service_persistence_length
        type: u4
      - id: servicename_str
        type: utf16_str
      - id: displayname_str
        type: utf16_str
