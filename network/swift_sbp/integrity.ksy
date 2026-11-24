# Imported from https://github.com/swift-nav/libsbp/blob/6a70551df56974bb58b4d1a65da30cca973075e4/kaitai/ksy/integrity.ksy
# Copyright (C) 2015-2023 Swift Navigation Inc.
# Contact: https://support.swiftnav.com
#
# This source is subject to the license found in the file 'LICENSE' which must
# be distributed together with this source. All other rights reserved.
#
# THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND,
# EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.
#
# Integrity flag messages
#
# Automatically generated from spec/yaml/swiftnav/sbp/integrity.yaml with generate.py.
# Do not modify by hand!

meta:
  id: integrity
  title: SBP integrity messages
  license: MIT
  imports: [ gnss ]
  endian: le

types:

  integrity_ssr_header:
    seq:
      - id: obs_time
        type: gnss::gps_time_sec
        doc: GNSS reference time of the observation used to generate the flag.
      - id: num_msgs
        type: u1
        doc: Number of messages in the dataset
      - id: seq_num
        type: u1
        doc: Position of this message in the dataset
      - id: ssr_sol_id
        type: u1
        doc: SSR Solution ID.
      - id: tile_set_id
        type: u2
        doc: Unique identifier of the set this tile belongs to.
      - id: tile_id
        type: u2
        doc: Unique identifier of this tile in the tile set.
      - id: chain_id
        type: u1
        doc: Chain and type of flag.
  
  msg_ssr_flag_high_level_dep_a:
    doc: Deprecated.
    seq:
      - id: obs_time
        type: gnss::gps_time_sec
        doc: GNSS reference time of the observation used to generate the flag.
      - id: corr_time
        type: gnss::gps_time_sec
        doc: GNSS reference time of the correction associated to the flag.
      - id: ssr_sol_id
        type: u1
        doc: SSR Solution ID.
      - id: tile_set_id
        type: u2
        doc: Unique identifier of the set this tile belongs to.
      - id: tile_id
        type: u2
        doc: Unique identifier of this tile in the tile set.
      - id: chain_id
        type: u1
        doc: Chain and type of flag.
      - id: use_gps_sat
        type: u1
        doc: Use GPS satellites.
      - id: use_gal_sat
        type: u1
        doc: Use GAL satellites.
      - id: use_bds_sat
        type: u1
        doc: Use BDS satellites.
      - id: use_qzss_sat
        type: u1
        doc: Use QZSS satellites.
      - id: reserved
        type: u1
        repeat: expr
        repeat-expr: 5
        doc: Reserved
      - id: use_tropo_grid_points
        type: u1
        doc: Use tropo grid points.
      - id: use_iono_grid_points
        type: u1
        doc: Use iono grid points.
      - id: use_iono_tile_sat_los
        type: u1
        doc: Use iono tile satellite LoS.
      - id: use_iono_grid_point_sat_los
        type: u1
        doc: Use iono grid point satellite LoS.
  
  msg_ssr_flag_high_level:
    doc: |
      Integrity monitoring flags for multiple aggregated elements. An element
      could be a satellite, SSR grid point, or SSR tile. A group of aggregated
      elements being monitored for integrity could refer to:

      - Satellites in a particular {GPS, GAL, BDS, QZSS} constellation.

      - Satellites in the line-of-sight of a particular SSR tile.

      - Satellites in the line-of-sight of a particular SSR grid point.

      The integrity usage for a group of aggregated elements varies according
      to the integrity flag of the satellites comprising that group.

      SSR_INTEGRITY_USAGE_NOMINAL: All satellites received passed the
      integrity check and have flag INTEGRITY_FLAG_OK.

      SSR_INTEGRITY_USAGE_WARNING: A limited number of elements in the group
      failed the integrity check. Refer to more granular integrity messages
      for details on the specific failing elements.

      SSR_INTEGRITY_USAGE_ALERT: Most elements in the group failed the
      integrity check, do not use for positioning.

      SSR_INTEGRITY_USAGE_NOT_MONITORED: Unable to verify the integrity flag
      of elements in the group.
    seq:
      - id: obs_time
        type: gnss::gps_time_sec
        doc: GNSS reference time of the observation used to generate the flag.
      - id: iono_corr_time
        type: gnss::gps_time_sec
        doc: |
          GNSS reference time of the ionospheric correction associated to the
          flag.
      - id: sat_corr_time
        type: gnss::gps_time_sec
        doc: |
          GNSS reference time of the satellite correction associated to the
          flag.
      - id: ssr_sol_id
        type: u1
        doc: SSR Solution ID.
      - id: tile_set_id
        type: u2
        doc: Unique identifier of the set this tile belongs to.
      - id: tile_id
        type: u2
        doc: Unique identifier of this tile in the tile set.
      - id: chain_id
        type: u1
        doc: Chain and type of flag.
      - id: use_gps_sat
        type: u1
        doc: Use GPS satellites.
      - id: use_gal_sat
        type: u1
        doc: Use GAL satellites.
      - id: use_bds_sat
        type: u1
        doc: Use BDS satellites.
      - id: use_qzss_sat
        type: u1
        doc: Use QZSS satellites.
      - id: reserved
        type: u1
        repeat: expr
        repeat-expr: 5
        doc: Reserved
      - id: use_tropo_grid_points
        type: u1
        doc: Use tropo grid points.
      - id: use_iono_grid_points
        type: u1
        doc: Use iono grid points.
      - id: use_iono_tile_sat_los
        type: u1
        doc: Use iono tile satellite LoS.
      - id: use_iono_grid_point_sat_los
        type: u1
        doc: Use iono grid point satellite LoS.
  
  msg_ssr_flag_satellites:
    seq:
      - id: obs_time
        type: gnss::gps_time_sec
        doc: GNSS reference time of the observation used to generate the flag.
      - id: num_msgs
        type: u1
        doc: Number of messages in the dataset
      - id: seq_num
        type: u1
        doc: Position of this message in the dataset
      - id: ssr_sol_id
        type: u1
        doc: SSR Solution ID.
      - id: chain_id
        type: u1
        doc: Chain and type of flag.
      - id: const_id
        type: u1
        doc: Constellation ID.
      - id: n_faulty_sats
        type: u1
        doc: Number of faulty satellites.
      - id: faulty_sats
        type: u1
        repeat: eos
        doc: List of faulty satellites.
  
  msg_ssr_flag_tropo_grid_points:
    seq:
      - id: header
        type: integrity_ssr_header
        doc: Header of an integrity message.
      - id: n_faulty_points
        type: u1
        doc: Number of faulty grid points.
      - id: faulty_points
        type: u2
        repeat: eos
        doc: List of faulty grid points.
  
  msg_ssr_flag_iono_grid_points:
    seq:
      - id: header
        type: integrity_ssr_header
        doc: Header of an integrity message.
      - id: n_faulty_points
        type: u1
        doc: Number of faulty grid points.
      - id: faulty_points
        type: u2
        repeat: eos
        doc: List of faulty grid points.
  
  msg_ssr_flag_iono_tile_sat_los:
    seq:
      - id: header
        type: integrity_ssr_header
        doc: Header of an integrity message.
      - id: n_faulty_los
        type: u1
        doc: Number of faulty LOS.
      - id: faulty_los
        type: gnss::sv_id
        repeat: eos
        doc: List of faulty LOS
  
  msg_ssr_flag_iono_grid_point_sat_los:
    seq:
      - id: header
        type: integrity_ssr_header
        doc: Header of an integrity message.
      - id: grid_point_id
        type: u2
        doc: Index of the grid point.
      - id: n_faulty_los
        type: u1
        doc: Number of faulty LOS.
      - id: faulty_los
        type: gnss::sv_id
        repeat: eos
        doc: List of faulty LOS
  
  msg_acknowledge:
    seq:
      - id: request_id
        type: u1
        doc: |
          Echo of the request ID field from the corresponding CRA message, or
          255 if no request ID was provided.
      - id: area_id
        type: u4
        doc: Echo of the Area ID field from the corresponding CRA message.
      - id: response_code
        type: u1
        doc: Reported status of the request.
      - id: correction_mask_on_demand
        type: u2
        doc: |
          Contains the message group(s) that will be sent in response from the
          corresponding CRA correction mask. An echo of the correction mask
          field from the corresponding CRA message.
      - id: correction_mask_stream
        type: u2
        doc: For future expansion. Always set to 0.
      - id: solution_id
        type: u1
        doc: The solution ID of the instance providing the corrections.
  
