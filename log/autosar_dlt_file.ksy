# Imported from https://github.com/Equidamoid/dltpy/blob/0da7abc629e4fd6eb80f7161108472d656a4711c/dltpy/gen/dltmessage.ksy
# Licence and copyright: see _community/README.md
# This file is part of pydlt
# Copyright 2019  Vladimir Shapranov
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

meta:
  id: autosar_dlt_file
  title: AUTOSAR DLT log file
  license: GPL-3.0-only
  imports:
    - stored_message
  endian: be
seq:
  - id: msg
    type: stored_message
    repeat: eos
