meta:
  id: android_opengl_shaders_cache
  title: com.android.opengl.shaders_cache file
  application: Android
  tags:
    - android
    - media
  license: Apache-2.0
  endian: le

doc: |
  Android apps using directly or indirectly OpenGL cache compiled shaders
  into com.android.opengl.shaders_cache file.
doc-ref: https://android.googlesource.com/platform/frameworks/native/+/master/opengl/libs/EGL/FileBlobCache.cpp

seq:
  - id: magic
    contents: "EGL$"
  - id: crc32
    type: u4
    doc: crc32 of `contents`
  - id: contents
    size-eos: true
    type: cache

types:
  alignment:
    seq:
      - id: alignment
        size: "(_io.pos + 3) & ~3 - _io.pos"
        doc: garbage from memory
  prefixed_string:
    seq:
      - id: len_str
        -orig-id: mBuildIdLength
        type: u4
      - id: str
        -orig-id: mBuildId, buildId
        size: len_str
        type: strz
        encoding: ASCII
      - id: alignment
        type: alignment
  cache:
    doc-ref: https://android.googlesource.com/platform/frameworks/native/+/master/opengl/libs/EGL/BlobCache.cpp
    seq:
      - id: magic
        -orig-id: mMagicNumber, blobCacheMagic
        contents: ["$bB_"]
      - id: version
        -orig-id: mBlobCacheVersion, blobCacheVersion
        type: u4
      - id: device_version
        -orig-id: mDeviceVersion, blobCacheDeviceVersion
        type: u4
      - id: num_entries
        -orig-id: mNumEntries
        type: u4
      - id: build_id
        -orig-id: mBuildIdLength, mBuildId, buildId
        type: prefixed_string
        if: version >= 3 # hypothesis, needs deeper investigation
      - id: entries
        type: entry
        repeat: expr
        repeat-expr: num_entries
    types:
      entry:
        seq:
          - id: len_key
            -orig-id: mKeySize, keySize
            type: u4
          - id: len_value
            -orig-id: mValueSize, valueSize
            type: u4
          - id: key
            size: len_key
          - id: value
            size: len_value
          - id: alignment
            type: alignment
