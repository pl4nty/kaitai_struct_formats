meta:
  id: wix_burn
  title: WiX Burn bundle
  application:
    - WiX Toolset
    - Burn
  file-extension: exe
  license: GPL-3.0-or-later
  ks-version: '0.11'
  imports:
    - /archive/microsoft_cab
  endian: le
doc: |
  A bundle built with the Burn engine of the WiX Toolset: the engine
  executable, the bootstrapper application container right after it, and
  any attached containers (the payloads embedded in the bundle). All of
  the containers are cabinets. The bootstrapper application container
  holds the bundle manifest as file "0" (the XML that lists the bundle's
  packages, variables and related bundles), the bootstrapper application
  and its files.

  The engine finds the containers through the 512-byte `.wixburn` PE
  section, whose layout is parsed here. Pass the file offset of the
  section (its `PointerToRawData`) as `ofs_burn_section`; the section
  starts with the magic 0x00F14300.
doc-ref:
  - https://github.com/devicie/Komac-anthelion/tree/f9b303df556625ef39215e9c66e08ca037829866/src/analysis/installers/burn
  - https://github.com/wixtoolset/wix/blob/v7.0.0/src/burn/stub/StubSection.cpp
  - https://github.com/wixtoolset/wix/blob/v7.0.0/src/burn/engine/section.cpp
params:
  - id: ofs_burn_section
    type: u8
    doc: File offset of the `.wixburn` section.
instances:
  burn_section:
    pos: ofs_burn_section
    type: burn_section
  bootstrapper_application_container:
    pos: burn_section.len_stub
    size: burn_section.len_containers[0]
    type: microsoft_cab
    if: burn_section.num_containers > 0 and burn_section.container_format == burn_section::container_format::cabinet
    doc: |
      The UX container, with the bundle manifest, the bootstrapper
      application and its payloads.
  ofs_attached_containers:
    value: |
      burn_section.ofs_original_signature != 0
      ? burn_section.ofs_original_signature + burn_section.len_original_signature
      : burn_section.len_stub + burn_section.len_containers[0]
    doc: |
      Attached containers start after the whole engine: after the
      Authenticode signature the engine had when the bundle was built, if
      it had one, and otherwise right after the UX container. (A bundle
      whose engine was signed after the containers were attached has
      them after that signature instead, which this doesn't handle.)
  attached_containers:
    type: attached_container(1, ofs_attached_containers)
    if: burn_section.num_containers > 1
    doc: The first attached container, which links to the next one.
types:
  burn_section:
    -orig-id: BURN_SECTION_HEADER
    seq:
      - id: magic
        -orig-id: dwMagic
        contents: [0x00, 0x43, 0xf1, 0x00]
      - id: version
        -orig-id: dwVersion
        type: u4
        valid: 2
        doc: '`BURN_SECTION_VERSION`.'
      - id: bundle_code
        -orig-id: guidBundleCode
        size: 16
        doc: The bundle code (a GUID, in its Windows byte order).
      - id: len_stub
        -orig-id: dwStubSize
        type: u4
        doc: |
          Size of the engine executable, which is also the offset of the
          UX container.
      - id: original_checksum
        -orig-id: dwOriginalChecksum
        type: u4
        doc: PE checksum of the engine before the containers were attached.
      - id: ofs_original_signature
        -orig-id: dwOriginalSignatureOffset
        type: u4
        doc: Offset of the engine's Authenticode signature when it was built.
      - id: len_original_signature
        -orig-id: dwOriginalSignatureSize
        type: u4
      - id: container_format
        -orig-id: dwFormat
        type: u4
        enum: container_format
      - id: num_containers
        -orig-id: cContainers
        type: u4
        doc: Number of containers, including the UX container.
      - id: len_containers
        -orig-id: rgcbContainers
        type: u4
        repeat: expr
        repeat-expr: num_containers
        doc: |
          Sizes of the containers, the UX container first. The array fills
          the rest of the section (116 entries in the usual 512-byte
          section); only the first `num_containers` are used.
    enums:
      container_format:
        1: cabinet
  attached_container:
    params:
      - id: index
        type: u4
      - id: ofs
        type: u8
    instances:
      len_cabinet:
        value: _root.burn_section.len_containers[index]
      is_present:
        value: ofs + len_cabinet <= _root._io.size
        doc: Containers can also be detached, next to the bundle.
      cabinet:
        io: _root._io
        pos: ofs
        size: len_cabinet
        type: microsoft_cab
        if: is_present and _root.burn_section.container_format == burn_section::container_format::cabinet
      next:
        type: attached_container(index + 1, ofs + len_cabinet)
        if: index + 1 < _root.burn_section.num_containers
