meta:
  id: qt_main_window_state
  title: Qt QMainWindow saved state (dock widgets and toolbars)
  application:
    - Qt Widgets
  license: CC0-1.0
  ks-version: '0.9'
  endian: be
doc: |
  Blob returned by `QMainWindow::saveState()` in Qt Widgets and accepted
  by `QMainWindow::restoreState()`: the arrangement of a main window's
  dock widgets and toolbars. Applications usually keep it in QSettings,
  e.g. as a `@ByteArray(...)` value in an .ini file or a binary value in
  the Windows registry or a macOS plist; this spec describes the raw
  bytes.

  The blob is written with QDataStream (big endian, stream version
  Qt_5_0): a 32-bit version marker 0xFF, the application-chosen 32-bit
  version number, then a sequence of sections, each introduced by a
  1-byte marker:

  * 0xFD: the dock areas (left, right, top, bottom), each a tree of
    splitters ("sequences") and tab groups whose leaves are dock
    widgets, identified by their objectName; then the size of the
    central widget and the dock area owning each corner.
  * 0xF9: a floating group of tabbed dock widgets with its geometry.
  * 0xFC (or 0xFE in Qt 4.3.0): the toolbar lines of each toolbar area,
    with toolbars identified by objectName.

  Strings are QStrings: a 32-bit byte length (0xFFFFFFFF for a null
  string) followed by UTF-16BE text.
doc-ref:
  - https://github.com/qt/qtbase/blob/ffd56e63338a76963c11d2bab003aeb532b1fd29/src/widgets/widgets/qmainwindow.cpp
  - https://github.com/qt/qtbase/blob/ffd56e63338a76963c11d2bab003aeb532b1fd29/src/widgets/widgets/qmainwindowlayout.cpp
  - https://github.com/qt/qtbase/blob/ffd56e63338a76963c11d2bab003aeb532b1fd29/src/widgets/widgets/qdockarealayout.cpp
  - https://github.com/qt/qtbase/blob/ffd56e63338a76963c11d2bab003aeb532b1fd29/src/widgets/widgets/qtoolbararealayout.cpp
seq:
  - id: version_marker
    contents: [0x00, 0x00, 0x00, 0xff]
  - id: version
    type: s4
    doc: Version number passed to saveState() by the application.
  - id: sections
    type: section
    repeat: eos
types:
  section:
    seq:
      - id: marker
        type: u1
        enum: section_marker
      - id: body
        type:
          switch-on: marker
          cases:
            'section_marker::dock_widgets': dock_area_layout
            'section_marker::floating_dock_widget_tab': floating_tab_group
            'section_marker::toolbars': toolbar_area_layout(true)
            'section_marker::toolbars_qt_4_3_0': toolbar_area_layout(false)
  dock_area_layout:
    seq:
      - id: num_areas
        type: s4
        doc: Number of non-empty dock areas that follow (at most 4).
      - id: areas
        type: dock_area
        repeat: expr
        repeat-expr: num_areas
      - id: central_widget_size
        type: size
      - id: corners
        type: s4
        enum: dock_widget_area
        repeat: expr
        repeat-expr: 4
        doc: |
          Dock area that owns each corner, indexed by Qt::Corner: top
          left, top right, bottom left, bottom right.
  dock_area:
    seq:
      - id: position
        type: s4
        enum: dock_position
      - id: size
        type: size
      - id: layout
        type: dock_area_layout_info
  floating_tab_group:
    seq:
      - id: geometry
        type: rect
      - id: layout
        type: dock_area_layout_info
  dock_area_layout_info:
    doc: A splitter or tab group of dock items (QDockAreaLayoutInfo).
    seq:
      - id: kind
        type: u1
        enum: item_marker
        valid:
          any-of:
            - item_marker::tab
            - item_marker::sequence
      - id: current_tab_index
        type: s4
        if: kind == item_marker::tab
        doc: Index of the tab on top, or -1.
      - id: orientation
        type: u1
        enum: orientation
      - id: num_items
        type: s4
      - id: items
        type: dock_item
        repeat: expr
        repeat-expr: num_items
  dock_item:
    seq:
      - id: kind
        type: u1
        enum: item_marker
        valid:
          any-of:
            - item_marker::widget
            - item_marker::sequence
      - id: object_name
        type: qstring
        if: kind == item_marker::widget
        doc: objectName of the dock widget (or of its placeholder).
      - id: flags
        type: dock_widget_flags
        if: kind == item_marker::widget
      - id: pos
        type: s4
        doc: |
          Offset along the parent's orientation; x of the window geometry
          for a floating dock widget.
      - id: size
        type: s4
        doc: |
          Size along the parent's orientation, or -1; y of the window
          geometry for a floating dock widget.
      - id: min_size
        type: s4
        doc: |
          Minimum size along the parent's orientation (0 for placeholders);
          width of the window geometry for a floating dock widget.
      - id: max_size
        type: s4
        doc: |
          Maximum size along the parent's orientation (0 for placeholders);
          height of the window geometry for a floating dock widget.
      - id: layout
        type: dock_area_layout_info
        if: kind == item_marker::sequence
        doc: Nested splitter or tab group.
  dock_widget_flags:
    seq:
      - id: reserved
        type: b4
      - id: closed
        type: b1
      - id: floating_tabs
        type: b1
        doc: Part of a floating group of tabbed dock widgets.
      - id: floating
        type: b1
        doc: When set, the four integers that follow are x, y, width, height.
      - id: visible
        type: b1
  toolbar_area_layout:
    params:
      - id: has_geometry
        type: bool
        doc: Toolbars carry two packed geometry words instead of one.
    seq:
      - id: num_lines
        type: s4
      - id: lines
        type: toolbar_line
        repeat: expr
        repeat-expr: num_lines
  toolbar_line:
    seq:
      - id: position
        type: s4
        enum: dock_position
        doc: Toolbar area of this line.
      - id: num_toolbars
        type: s4
      - id: toolbars
        type: toolbar
        repeat: expr
        repeat-expr: num_toolbars
  toolbar:
    seq:
      - id: object_name
        type: qstring
      - id: reserved
        type: b6
      - id: is_vertical
        type: b1
      - id: is_shown
        type: b1
      - id: pos
        type: s4
      - id: preferred_size
        type: s4
        doc: -1 unless the user resized the toolbar.
      - id: geom0
        type: u4
      - id: geom1
        type: u4
        if: _parent._parent.has_geometry
    instances:
      is_floating:
        value: geom0 & 1 != 0
      floating_x:
        value: ((geom0 >> 1) & 0xffff) - 0x7fff
        if: is_floating and _parent._parent.has_geometry
      floating_y:
        value: (geom1 & 0xffff) - 0x7fff
        if: is_floating and _parent._parent.has_geometry
      floating_width:
        value: (geom0 >> 17) & 0xffff
        if: is_floating and _parent._parent.has_geometry
      floating_height:
        value: (geom1 >> 16) & 0xffff
        if: is_floating and _parent._parent.has_geometry
  qstring:
    seq:
      - id: len_bytes
        type: u4
        doc: Byte length of the text; 0xFFFFFFFF for a null string.
      - id: value
        size: len_bytes
        type: str
        encoding: UTF-16BE
        if: len_bytes != 0xffffffff
  size:
    seq:
      - id: width
        type: s4
      - id: height
        type: s4
  rect:
    seq:
      - id: left
        type: s4
      - id: top
        type: s4
      - id: right
        type: s4
        doc: left + width - 1
      - id: bottom
        type: s4
        doc: top + height - 1
enums:
  section_marker:
    0xf9: floating_dock_widget_tab
    0xfc: toolbars
    0xfd: dock_widgets
    0xfe: toolbars_qt_4_3_0
  item_marker:
    0xfa: tab
    0xfb: widget
    0xfc: sequence
  orientation:
    1: horizontal
    2: vertical
  dock_position:
    0: left
    1: right
    2: top
    3: bottom
  dock_widget_area:
    0: none
    1: left
    2: right
    4: top
    8: bottom
