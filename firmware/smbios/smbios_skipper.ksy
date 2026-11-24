meta:
  id: smbios_skipper
  license: LicenseRef-All-Rights-Reserved
  endian: le
  imports:
    - smbios_strings
seq:
  - id: length
    type: u1
  - id: rest
    size: length - 2
  - id: strings_array
    type: smbios_strings
    # Repeat until [00, 00] is matched, this mean, double terminator byte (0)
    # the trick here is _.string.length is the last string we have parsed and
    # strings_array has to contain at least 2 elements.
    repeat: until
    repeat-until: _.string.length == 1 and strings_array.size > 1
