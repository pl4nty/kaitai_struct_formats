# Imported from https://github.com/MIT-REALM/ground_control/blob/886211dc1cc7e66d7f10f32fe7d69a2ab9c9d37f/submodules/f1tenth_system/vesc/vesc_driver/src/vesc6.ksy
meta:
  id: vesc_6
  file-extension: vesc_6
  license: BSD-3-Clause
  endian: le
seq:
  - id: packet_id
    type: u1
  - id: temp_fet_filtered
    type: s2be
  - id: temp_motor_filtered
    type: s2be
  - id: reset_avg_motor_current
    type: s4be
  - id: reset_avg_input_current
    type: s4be
  - id: reset_avg_id
    type: s4be
  - id: reset_avg_iq
    type: s4be
  - id: duty_cycle_now
    type: s2be
  - id: rpm
    type: s4be
  - id: input_voltage_filtered
    type: s2be
  - id: amp_hours
    type: s4be
  - id: amp_hours_charged
    type: s4be
  - id: watt_hours
    type: s4be
  - id: watt_hours_charged
    type: s4be
  - id: tachometer_value
    type: s4be
  - id: tachometer_abs_value
    type: s4be
  - id: fault
    type: u1
  - id: pid_pos_now
    type: s2be
  - id: controller_id
    type: u1
  - id: temp_mos1
    type: s2be
  - id: temp_mos2
    type: s2be
  - id: temp_mos3
    type: s2be
  - id: reset_avg_vd
    type: s4be
  - id: reset_avg_vq
    type: s4be
