meta:
  id: cntk
  title: Microsoft CogNitive ToolKit Computation NeTworK
  file-extension: model
  xref:
    wikidata: Q23680120
  license: MIT
  encoding: UTF-16LE
  endian: le

doc: |
  A native CNTK format for serialization of a computation graph. These graphs are
  usually used to store machine-learning models, like neural networks and gradient
  boosted decision trees ensembles.
  The list of pretrained models is here:
  https://github.com/Microsoft/CNTK/blob/master/PretrainedModels/download_model.py
  Only some of them have this format.

doc-ref:
  - https://github.com/Microsoft/CNTK
  - https://github.com/microsoft/CNTK/blob/10a8ffcf50d7b9225f3236ffcfdc422b2014fb92/Source/ComputationNetworkLib/ComputationNetwork.cpp#L125-L230

seq:
  - id: network
    type: section_hardcode("CN")
types:
  vector_bool:
    doc: File::operator<<(std::vector<T>) with T = bool
    doc-ref: https://github.com/microsoft/CNTK/blob/10a8ffcf50d7b9225f3236ffcfdc422b2014fb92/Source/Common/Include/File.h#L175-L185
    seq:
      - id: count
        type: u8
      - id: values
        type: u1
        repeat: expr
        repeat-expr: count
  tensor_shape:
    doc: |
      TensorShape::Save() writes u4 rank then rank u4 dims. With accept_legacy
      (InputValue, legacy LearnableParameter), Load() also accepts the old
      size_t W, H, C layout, detected by a zero second u4; it then yields
      dims[1] = first value, dims[2], dims[0].
    doc-ref: https://github.com/microsoft/CNTK/blob/10a8ffcf50d7b9225f3236ffcfdc422b2014fb92/Source/Common/Include/TensorShape.h#L401-L440
    params:
      - id: accept_legacy
        type: bool
    seq:
      - id: rank
        type: u4
      - id: dims
        type: u4
        repeat: expr
        repeat-expr: rank
        if: not is_legacy
      - id: legacy_high
        type: u4
        if: is_legacy
        doc: high half of the first size_t (zero)
      - id: legacy_dim2
        type: u8
        if: is_legacy
      - id: legacy_dim0
        type: u8
        if: is_legacy
    instances:
      ofs_dims:
        value: _io.pos
      peek_dim0:
        pos: ofs_dims
        type: u4
        if: accept_legacy and rank > 0
      is_legacy:
        value: accept_legacy and rank > 0 and peek_dim0 == 0
  elem_value:
    doc: One ElemType value
    params:
      - id: precision
        type: str
    seq:
      - id: value
        type:
          switch-on: precision
          cases:
            '"float"': f4
            '"double"': f8
            '"half"': u2
  rng_state:
    doc: |
      RngUser::Load: nothing before model version 16; version 16 stored the
      seed as `unsigned long` (4 bytes as written by the Windows build, which
      is assumed here), later versions as u8.
    doc-ref: https://github.com/microsoft/CNTK/blob/10a8ffcf50d7b9225f3236ffcfdc422b2014fb92/Source/ComputationNetworkLib/TrainingNodes.h#L1207-L1235
    params:
      - id: model_version
        type: u8
    seq:
      - id: seed_v16
        type: u4
        if: model_version == 16
      - id: seed
        type: u8
        if: model_version >= 17
      - id: offset
        type: u8
        if: model_version >= 16
  begin_marker:
    seq:
      - id: begin
        contents: ["B", 0]
      - id: name
        type: strz
        #terminator: [0, 0]
        #consume: true
  begin_marker_hardcode:
    params:
      - id: name
        type: str
    seq:
      - id: begin
        contents: ["B", 0]
      - id: marker
        size: name.length * 2
        type: str
        valid: name
      - id: terminator
        contents: [0,0]
  end_marker:
    params:
      - id: name
        type: str
    seq:
      - id: end
        contents: ["E", 0]
      - id: marker
        size: name.length * 2
        type: str
        valid: name
      - id: terminator
        contents: [0,0]
  section_contents:
    params:
      - id: section_name
        type: str
    seq:
      - id: contents
        parent: _parent._parent
        type:
          switch-on: section_name
          cases:
            "'CN'": computation_network
            "'Version'": version
            "'NodeList'": node_list
            "'Relation'": relation
            "'MAT'": matrix
            "'RootNodes'": root_nodes
            "'FeatureNodes'": nodes_names
            "'LabelNodes'": nodes_names
            "'CriterionNodes'": nodes_names
            "'EvalNodes'": nodes_names
            "'OutputNodes'": nodes_names
    types:
      matrix:
        doc: |
          Dense CPU matrix, the body of a "BMAT" ... "EMAT" section.
        doc-ref: https://github.com/microsoft/CNTK/blob/10a8ffcf50d7b9225f3236ffcfdc422b2014fb92/Source/Math/CPUMatrix.h#L545-L559
        seq:
          - id: element_size
            -orig-id: sizeof(ElemType)
            type: u8
          - id: name
            type: strz
            doc: always "unnamed"
          - id: format
            -orig-id: format
            type: u4
            doc: MatrixFormat flags; 0 is dense column-major
          - id: rows
            -orig-id: m_numRows
            type: u8
          - id: cols
            -orig-id: m_numCols
            type: u8
          - id: data
            size: cols * rows * element_size
            doc: elements in column-major order
        instances:
          row_major:
            -orig-id: bitPosRowMajor
            value: (format & 1) != 0
          sparse:
            -orig-id: bitPosSparse
            value: (format & 2) != 0
          compressed:
            -orig-id: bitPosCompressed
            value: (format & 4) != 0
      version:
        seq:
          - id: model_version
            -orig-id: CURRENT_CNTK_MODEL_VERSION
            type: u8
      computation_network:
        seq:
          - id: version_
            -orig-id: Version
            type: section_hardcode("Version")
            doc: ""
          - id: node_count
            -orig-id: numNodes
            type: u8
            doc: ""
          - id: node_list
            -orig-id: NodeList
            type: section_hardcode("NodeList")
            doc: ""
          - id: relation
            -orig-id: Relation
            type: section_hardcode("Relation")
            doc: ""
          - id: root_nodes
            -orig-id: RootNodes
            type: section_hardcode("RootNodes")
            doc: ""
        instances:
          model_version:
            value: version_.contents.contents.as<version>.model_version

      relation:
        seq:
          - id: relations
            type: relation
            repeat: expr
            repeat-expr: "_parent.as<computation_network>.node_count" #section_contents->section->parent
        types:
          relation:
            seq:
              - id: name
                -orig-id: nodePtr->NodeName()
                type: strz
                
              - id: inputs_count
                -orig-id: nodePtr->GetNumInputs()
                type: u8

              - id: inputs
                type: strz
                repeat: expr
                repeat-expr: inputs_count
                doc: name of input node
      root_nodes:
        seq:
          - id: feature
            -orig-id: m_featureNodes
            type: section_hardcode("FeatureNodes")
            doc: ""
          - id: label
            -orig-id: 
            type: section_hardcode("LabelNodes")
            doc: ""
          - id: criterion
            -orig-id: 
            type: section_hardcode("CriterionNodes")
            doc: ""
          - id: eval
            -orig-id: 
            type: section_hardcode("EvalNodes")
            doc: ""
          - id: output
            -orig-id: 
            type: section_hardcode("OutputNodes")
            doc: ""
      nodes_names:
        seq:
          - id: count
            type: u8
          - id: names
            type: strz
            repeat: expr
            repeat-expr: count
      node_list:
        seq:
          - id: nodes
            -orig-id: m_nameToNodeMap
            type: node
            repeat: expr
            repeat-expr: "_parent.as<computation_network>.node_count"
        types:
          node:
            seq:
              - id: precision
                type: strz
                doc: |
                  "float", "double", "half"; written since model version 7
                  (all supported files have it)
              - id: operation_name
                -orig-id: OperationName
                type: strz
              - id: node_name
                -orig-id: NodeName
                type: strz
              - id: node_specific
                doc: |
                  Payload written by the node's own `Save()` and read back by its
                  `Load(fstream, modelVersion)`, whose version gates are
                  followed here. Operations that inherit the empty
                  `ComputationNodeBase::Save()` (e.g. Plus, Minus, ElementTimes,
                  Sigmoid, Tanh, Softmax, ClassificationError/ErrorPrediction,
                  CrossEntropyWithSoftmax, SquareError, Logistic) write nothing.
                  Operations known to write a payload that has no case here, and
                  so would desynchronise the node list: QuantizedTimes,
                  LegacyReshape, Shift, Trace, LatticeSequenceWithSoftmax,
                  ForwardBackward, NCEBasedCrossEntropyWithSoftmax.
                type:
                  switch-on: operation_name
                  cases:
                    '"InputValue"': input_value
                    '"SparseInputValue"': input_value
                    '"LearnableParameter"': learnable_parameter
                    '"Times"': times
                    '"TransposeTimes"': times
                    '"Convolution"': convolution_extended
                    '"ConvolutionSequenceShape"': convolution_extended
                    '"Pooling"': convolution(model_version)
                    '"MaxUnpooling"': convolution(model_version)
                    '"MaxPooling"': pooling
                    '"AveragePooling"': pooling
                    '"ROIPooling"': roi_pooling
                    '"PastValue"': delayed_value
                    '"FutureValue"': delayed_value
                    '"BatchNormalization"': batch_normalization
                    '"Reshape"': reshape
                    '"Slice"': slice
                    '"RowStack"': row_stack
                    '"RowRepeat"': row_repeat
                    '"ReduceElements"': reduce_elements
                    '"TransposeDimensions"': transpose_dimensions
                    '"Crop"': crop
                    '"Where"': dynamic_axis_name
                    '"ToSequence"': dynamic_axis_name
                    '"UnpackSequence"': unpack_sequence
                    '"Dropout"': dropout
                    '"RandomSample"': random_sample
                    '"RandomSampleInclusionFrequency"': random_sample
                    '"Mean"': pre_computed
                    '"InvStdDev"': pre_computed
                    '"EditDistanceError"': edit_distance_error
                    '"EnvironmentInput"': environment_input
                    '"EyeLikeOp"': eye_like
                    '"OptimizedRNNStack"': optimized_rnn_stack
            instances:
              model_version:
                value: _parent._parent.as<computation_network>.model_version
            types:
              input_value:
                doc-ref: https://github.com/microsoft/CNTK/blob/10a8ffcf50d7b9225f3236ffcfdc422b2014fb92/Source/ComputationNetworkLib/InputAndParamNodes.h#L303-L350
                seq:
                  - id: rows
                    -orig-id: rowsDummy
                    type: u8
                  - id: cols
                    -orig-id: colsDummy
                    type: u8
                  - id: sample_layout
                    -orig-id: m_sampleLayout
                    type: tensor_shape(true)
                  - id: nr_axes
                    -orig-id: nrAxes
                    type: u4
                    if: _parent.model_version >= 8
                  - id: dynamic_axis_node_name
                    -orig-id: m_dynamicAxisNodeName
                    type: strz
                    if: _parent.model_version >= 8 and nr_axes == 1
                  - id: learning_rate_multiplier
                    -orig-id: m_learningRateMultiplier
                    type: f4
                    if: _parent.model_version >= 10

              learnable_parameter:
                doc-ref: https://github.com/microsoft/CNTK/blob/10a8ffcf50d7b9225f3236ffcfdc422b2014fb92/Source/ComputationNetworkLib/InputAndParamNodes.cpp#L468-L510
                seq:
                  - id: learning_rate_multiplier
                    -orig-id: m_learningRateMultiplier
                    type: f4
                    if: _parent.model_version >= 3
                  - id: sample_layout
                    -orig-id: m_sampleLayout
                    type: tensor_shape(false)
                    if: _parent.model_version >= 3
                  - id: legacy_parameter_update_required
                    -orig-id: parameterUpdateRequired
                    type: u1
                    if: _parent.model_version < 3
                  - id: legacy_rows
                    type: u8
                    if: _parent.model_version < 3
                  - id: legacy_cols
                    type: u8
                    if: _parent.model_version < 3
                  - id: legacy_sample_layout
                    type: tensor_shape(true)
                    if: _parent.model_version < 3 and legacy_rows == 0
                  - id: value
                    -orig-id: Value()
                    type: matrix_value

              times:
                doc-ref: https://github.com/microsoft/CNTK/blob/10a8ffcf50d7b9225f3236ffcfdc422b2014fb92/Source/ComputationNetworkLib/LinearAlgebraNodes.h#L411-L430
                seq:
                  - id: output_rank
                    -orig-id: m_outputRank
                    type: u8
                    if: _parent.model_version >= 3
                  - id: infer_input_rank_to_map
                    -orig-id: m_inferInputRankToMap
                    type: s4
                    if: _parent.model_version >= 12

              convolution:
                doc: ConvolutionNodeBase (Pooling, MaxUnpooling; base of Convolution)
                doc-ref: https://github.com/microsoft/CNTK/blob/10a8ffcf50d7b9225f3236ffcfdc422b2014fb92/Source/ComputationNetworkLib/ConvolutionalNodes.h#L69-L124
                params:
                  - id: model_version
                    type: u8
                seq:
                  - id: kernel_shape
                    -orig-id: m_kernelShape
                    type: tensor_shape(false)
                    if: model_version >= 5
                  - id: map_count
                    -orig-id: m_mapCount
                    type: tensor_shape(false)
                    if: model_version >= 5
                  - id: stride
                    -orig-id: m_stride
                    type: tensor_shape(false)
                    if: model_version >= 5
                  - id: sharing
                    -orig-id: m_sharing
                    type: vector_bool
                    if: model_version >= 5
                  - id: auto_pad
                    -orig-id: m_autoPad
                    type: vector_bool
                    if: model_version >= 5
                  - id: lower_pad
                    -orig-id: m_lowerPad
                    type: tensor_shape(false)
                    if: model_version >= 5
                  - id: upper_pad
                    -orig-id: m_upperPad
                    type: tensor_shape(false)
                    if: model_version >= 5
                  - id: pool_kind
                    -orig-id: m_poolKind
                    type: s4
                    enum: pool_kind
                    if: model_version >= 5
                  - id: image_layout
                    -orig-id: m_imageLayout
                    type: s4
                    enum: image_layout_kind
                    if: model_version >= 5
                  - id: max_temp_mem_size_in_samples
                    -orig-id: m_maxTempMemSizeInSamples
                    type: u8
                    if: model_version >= 5
                  - id: transpose
                    -orig-id: m_transpose
                    type: u1
                    if: model_version >= 9
                  - id: output_shape
                    -orig-id: m_outputShape
                    type: tensor_shape(false)
                    if: model_version >= 20
                  - id: ceil_out_dim
                    -orig-id: m_ceilOutDim
                    type: u1
                    if: model_version >= 21
                  - id: pool_include_pad
                    -orig-id: m_poolIncludePad
                    type: u1
                    if: model_version >= 23

              convolution_extended:
                doc: |
                  ConvolutionNodeBaseExtended (Convolution, ConvolutionSequenceShape):
                  the base payload, then either the pre-version-5 legacy 2D
                  fields or m_convolution2D and (version 18+) m_dilation.
                doc-ref: https://github.com/microsoft/CNTK/blob/10a8ffcf50d7b9225f3236ffcfdc422b2014fb92/Source/ComputationNetworkLib/ConvolutionalNodes.h#L360-L409
                seq:
                  - id: base
                    type: convolution(_parent.model_version)
                  - id: legacy_kernel_width
                    -orig-id: kW
                    type: u8
                    if: _parent.model_version < 5
                  - id: legacy_kernel_height
                    -orig-id: kH
                    type: u8
                    if: _parent.model_version < 5
                  - id: legacy_stride_width
                    -orig-id: sW
                    type: u8
                    if: _parent.model_version < 5
                  - id: legacy_stride_height
                    -orig-id: sH
                    type: u8
                    if: _parent.model_version < 5
                  - id: legacy_map_count
                    -orig-id: mapCount
                    type: u4
                    if: _parent.model_version < 5
                  - id: legacy_image_layout
                    -orig-id: imageLayout
                    type: u4
                    enum: image_layout_kind
                    if: _parent.model_version < 5
                  - id: legacy_pad
                    -orig-id: pad
                    type: u1
                    if: _parent.model_version < 5
                  - id: legacy_max_temp_mem_size_in_samples
                    -orig-id: m_maxTempMemSizeInSamples
                    type: u8
                    if: _parent.model_version < 5
                  - id: convolution_2d
                    -orig-id: m_convolution2D
                    type: u1
                    if: _parent.model_version >= 5
                  - id: dilation
                    -orig-id: m_dilation
                    type: tensor_shape(false)
                    if: _parent.model_version >= 18

              roi_pooling:
                doc-ref: https://github.com/microsoft/CNTK/blob/10a8ffcf50d7b9225f3236ffcfdc422b2014fb92/Source/ComputationNetworkLib/ConvolutionalNodes.h#L1075-L1104
                seq:
                  - id: roi_output_shape
                    -orig-id: m_roiOutputShape
                    type: tensor_shape(false)
                  - id: pool_kind
                    -orig-id: m_poolKind
                    type: s4
                    enum: pool_kind
                    if: _parent.model_version >= 26
                    doc: before version 26 implied max
                  - id: spatial_scale
                    -orig-id: m_spatialScale
                    type: f8
                    if: _parent.model_version >= 26
                    doc: before version 26 implied 1/16

              pooling:
                doc: Legacy PoolingNodeBase (MaxPooling, AveragePooling)
                doc-ref: https://github.com/microsoft/CNTK/blob/10a8ffcf50d7b9225f3236ffcfdc422b2014fb92/Source/ComputationNetworkLib/ConvolutionalNodes.h#L1449-L1466
                seq:
                  - id: window_width
                    -orig-id: m_windowWidth
                    type: u4
                  - id: image_layout_kind
                    -orig-id: m_imageLayoutKind
                    type: u4
                    enum: image_layout_kind
                  - id: window_height
                    -orig-id: m_windowHeight
                    type: u8
                  - id: horizontal_subsample
                    -orig-id: m_horizontalSubsample
                    type: u8
                  - id: vertical_subsample
                    -orig-id: m_verticalSubsample
                    type: u8

              delayed_value:
                doc: DelayedValueNodeBase (PastValue, FutureValue)
                doc-ref: https://github.com/microsoft/CNTK/blob/10a8ffcf50d7b9225f3236ffcfdc422b2014fb92/Source/ComputationNetworkLib/RecurrentNodes.cpp#L66-L111
                seq:
                  - id: time_step
                    -orig-id: m_timeStep
                    type: s4
                  - id: sample_layout
                    -orig-id: m_sampleLayout
                    type: tensor_shape(false)
                    if: _parent.model_version > 3
                  - id: legacy_rows
                    type: u8
                    if: _parent.model_version <= 3
                  - id: legacy_cols
                    type: u8
                    if: _parent.model_version <= 3
                  - id: initial_state_value
                    -orig-id: m_initialStateValue
                    type: elem_value(_parent.precision)
                    if: _parent.model_version >= 2

              batch_normalization:
                doc-ref: https://github.com/microsoft/CNTK/blob/10a8ffcf50d7b9225f3236ffcfdc422b2014fb92/Source/ComputationNetworkLib/TrainingNodes.h#L2430-L2515
                seq:
                  # version >= 6
                  - id: spatial
                    -orig-id: m_spatial
                    type: u1
                    if: _parent.model_version >= 6
                  - id: norm_time_const
                    -orig-id: m_normTimeConst
                    type: f8
                    if: _parent.model_version >= 6
                  - id: blend_time_const
                    -orig-id: m_blendTimeConst
                    type: f8
                    if: _parent.model_version >= 6
                  - id: image_layout_kind
                    -orig-id: m_imageLayoutKind
                    type: s4
                    enum: image_layout_kind
                    if: _parent.model_version >= 6
                  - id: run_count
                    -orig-id: m_runCountUntied
                    type: u8
                    if: _parent.model_version >= 13 and _parent.model_version != 19
                  - id: run_count_is_zero
                    -orig-id: runCountIsZero
                    type: u1
                    if: _parent.model_version == 19
                  - id: mb_count
                    -orig-id: mbCount
                    type: u8
                    if: _parent.model_version >= 6 and _parent.model_version < 13
                  - id: epsilon
                    -orig-id: m_epsilon
                    type: f8
                    if: _parent.model_version >= 6
                  - id: use_cntk_engine
                    -orig-id: m_useCntkEngine
                    type: u1
                    if: _parent.model_version >= 6
                  # version < 6: node-private versioning
                  - id: legacy
                    type: batch_normalization_legacy
                    if: _parent.model_version < 6
              batch_normalization_legacy:
                seq:
                  - id: ver_written
                    -orig-id: verWritten
                    type: s4
                  - id: ver_readable
                    -orig-id: verReadable
                    type: s4
                  - id: eval
                    type: u1
                  - id: spatial
                    -orig-id: m_spatial
                    type: u1
                  - id: norm_time_const
                    -orig-id: m_normTimeConst
                    type: f8
                    doc: expAvgFactor before node version 0x00010004
                  - id: image_layout_kind
                    -orig-id: m_imageLayoutKind
                    type: s4
                    enum: image_layout_kind
                    if: ver_written >= 0x00010002
                  - id: mb_count
                    -orig-id: mbCount
                    type: u8
                    if: ver_written >= 0x00010002
                  - id: epsilon
                    -orig-id: m_epsilon
                    type: f8
                    if: ver_written >= 0x00010003
                  - id: use_cntk_engine
                    -orig-id: m_useCntkEngine
                    type: u1
                    if: ver_written >= 0x00010003

              reshape:
                doc-ref: https://github.com/microsoft/CNTK/blob/10a8ffcf50d7b9225f3236ffcfdc422b2014fb92/Source/ComputationNetworkLib/ReshapingNodes.h#L78-L90
                seq:
                  - id: begin_dim
                    -orig-id: m_beginDimParameter
                    type: s4
                  - id: end_dim
                    -orig-id: m_endDimParameter
                    type: s4
                  - id: replacement_sample_layout
                    -orig-id: m_replacementSampleLayout
                    type: tensor_shape(false)

              slice:
                doc-ref: https://github.com/microsoft/CNTK/blob/10a8ffcf50d7b9225f3236ffcfdc422b2014fb92/Source/ComputationNetworkLib/ReshapingNodes.h#L743-L783
                seq:
                  - id: num_axes
                    -orig-id: num
                    type: s4
                    if: _parent.model_version >= 22
                  - id: axes
                    type: slice_axis
                    repeat: expr
                    repeat-expr: '_parent.model_version >= 22 ? num_axes : 1'
                types:
                  slice_axis:
                    seq:
                      - id: begin_index
                        -orig-id: beginIndex
                        type: s8
                      - id: height
                        type: s8
                        doc: end index minus begin index
                      - id: axis
                        -orig-id: m_axis
                        type: s4
                        if: _parent._parent.model_version >= 3
                      - id: stride_multiplier
                        -orig-id: m_stride_multiplier
                        type: s4
                        if: _parent._parent.model_version >= 27

              row_stack:
                doc-ref: https://github.com/microsoft/CNTK/blob/10a8ffcf50d7b9225f3236ffcfdc422b2014fb92/Source/ComputationNetworkLib/ReshapingNodes.h#L1201-L1214
                seq:
                  - id: splice_dim
                    -orig-id: m_spliceDim
                    type: s4
                    if: _parent.model_version >= 3

              row_repeat:
                doc-ref: https://github.com/microsoft/CNTK/blob/10a8ffcf50d7b9225f3236ffcfdc422b2014fb92/Source/ComputationNetworkLib/ReshapingNodes.h#L1348-L1358
                seq:
                  - id: num_repeat
                    -orig-id: m_numRepeat
                    type: u8

              reduce_elements:
                doc-ref: https://github.com/microsoft/CNTK/blob/10a8ffcf50d7b9225f3236ffcfdc422b2014fb92/Source/ComputationNetworkLib/ReshapingNodes.cpp#L50-L71
                seq:
                  - id: num_axes
                    type: s4
                    if: _parent.model_version >= 27
                  - id: axes
                    -orig-id: m_axes
                    type: s4
                    repeat: expr
                    repeat-expr: '_parent.model_version >= 27 ? num_axes : 1'
                  - id: operation
                    -orig-id: m_operation
                    type: strz
                  - id: keep_dimensions
                    -orig-id: m_keepDimensions
                    type: u1
                    if: _parent.model_version >= 24

              transpose_dimensions:
                doc-ref: https://github.com/microsoft/CNTK/blob/10a8ffcf50d7b9225f3236ffcfdc422b2014fb92/Source/ComputationNetworkLib/LinearAlgebraNodes.h#L1335-L1362
                seq:
                  - id: axis1
                    -orig-id: m_axis1
                    type: s4
                    if: _parent.model_version >= 3
                  - id: axis2
                    -orig-id: m_axis2
                    type: s4
                    if: _parent.model_version >= 3
                  - id: perm_count
                    type: u8
                    if: _parent.model_version >= 25 and axis1 == 0 and axis2 == 0
                  - id: perm
                    -orig-id: m_perm
                    type: u8
                    repeat: expr
                    repeat-expr: perm_count
                    if: _parent.model_version >= 25 and axis1 == 0 and axis2 == 0

              crop:
                doc-ref: https://github.com/microsoft/CNTK/blob/10a8ffcf50d7b9225f3236ffcfdc422b2014fb92/Source/ComputationNetworkLib/ReshapingNodes.cpp#L819-L835
                seq:
                  - id: x_offset
                    -orig-id: m_xOffset
                    type: f8
                  - id: y_offset
                    -orig-id: m_yOffset
                    type: f8

              dynamic_axis_name:
                doc: |
                  Where (version 11+) and ToSequence: m_dynamicAxisName
                doc-ref:
                  - https://github.com/microsoft/CNTK/blob/10a8ffcf50d7b9225f3236ffcfdc422b2014fb92/Source/ComputationNetworkLib/ReshapingNodes.h#L1451-L1464
                  - https://github.com/microsoft/CNTK/blob/10a8ffcf50d7b9225f3236ffcfdc422b2014fb92/Source/ComputationNetworkLib/SequenceReshapeNodes.h#L212-L222
                seq:
                  - id: dynamic_axis_name
                    -orig-id: m_dynamicAxisName
                    type: strz
                    if: _parent.operation_name != "Where" or _parent.model_version >= 11

              unpack_sequence:
                doc-ref: https://github.com/microsoft/CNTK/blob/10a8ffcf50d7b9225f3236ffcfdc422b2014fb92/Source/ComputationNetworkLib/SequenceReshapeNodes.h#L479-L491
                seq:
                  - id: padding_value
                    -orig-id: m_paddingValue
                    type: elem_value(_parent.precision)
                  - id: suppress_mask_output
                    -orig-id: m_suppressMaskOutput
                    type: u1

              dropout:
                doc-ref: https://github.com/microsoft/CNTK/blob/10a8ffcf50d7b9225f3236ffcfdc422b2014fb92/Source/ComputationNetworkLib/TrainingNodes.cpp#L310-L322
                seq:
                  - id: rng
                    type: rng_state(_parent.model_version)

              random_sample:
                doc-ref: https://github.com/microsoft/CNTK/blob/10a8ffcf50d7b9225f3236ffcfdc422b2014fb92/Source/ComputationNetworkLib/TrainingNodes.cpp#L84-L100
                seq:
                  - id: allow_duplicates
                    -orig-id: m_allowDuplicates
                    type: u1
                  - id: size_of_sampled_set
                    -orig-id: m_sizeOfSampledSet
                    type: u8
                  - id: rng
                    type: rng_state(_parent.model_version)

              pre_computed:
                doc: PreComputedNodeBase (Mean, InvStdDev)
                doc-ref: https://github.com/microsoft/CNTK/blob/10a8ffcf50d7b9225f3236ffcfdc422b2014fb92/Source/ComputationNetworkLib/PreComputeNodes.h#L57-L70
                seq:
                  - id: has_computed
                    -orig-id: m_hasComputed
                    type: u1
                  - id: value
                    -orig-id: Value()
                    type: matrix_value

              edit_distance_error:
                doc-ref: https://github.com/microsoft/CNTK/blob/10a8ffcf50d7b9225f3236ffcfdc422b2014fb92/Source/ComputationNetworkLib/EvaluationNodes.h#L694-L712
                seq:
                  - id: sub_pen
                    -orig-id: m_subPen
                    type: f4
                  - id: del_pen
                    -orig-id: m_delPen
                    type: f4
                  - id: ins_pen
                    -orig-id: m_insPen
                    type: f4
                  - id: squash_inputs
                    -orig-id: m_squashInputs
                    type: u1
                  - id: num_tokens_to_ignore
                    type: u8
                  - id: tokens_to_ignore
                    -orig-id: m_tokensToIgnore
                    type: u8
                    repeat: expr
                    repeat-expr: num_tokens_to_ignore

              environment_input:
                doc-ref: https://github.com/microsoft/CNTK/blob/10a8ffcf50d7b9225f3236ffcfdc422b2014fb92/Source/ComputationNetworkLib/InputAndParamNodes.h#L495-L505
                seq:
                  - id: property_name
                    -orig-id: m_propertyName
                    type: strz

              eye_like:
                doc-ref: https://github.com/microsoft/CNTK/blob/10a8ffcf50d7b9225f3236ffcfdc422b2014fb92/Source/ComputationNetworkLib/InputAndParamNodes.h#L842-L852
                seq:
                  - id: is_output_sparse
                    -orig-id: m_isOutputSparse
                    type: u1

              optimized_rnn_stack:
                doc: RnnAttributes::Write
                doc-ref:
                  - https://github.com/microsoft/CNTK/blob/10a8ffcf50d7b9225f3236ffcfdc422b2014fb92/Source/ComputationNetworkLib/RNNNodes.cpp#L66-L80
                  - https://github.com/microsoft/CNTK/blob/10a8ffcf50d7b9225f3236ffcfdc422b2014fb92/Source/Math/RNNCommon.h#L68-L95
                seq:
                  - id: bidirectional
                    -orig-id: m_bidirectional
                    type: u8
                  - id: num_layers
                    -orig-id: m_numLayers
                    type: u8
                  - id: hidden_size
                    -orig-id: m_hiddenSize
                    type: u8
                  - id: recurrent_op
                    -orig-id: m_recurrentOp
                    type: strz
                  - id: axis
                    -orig-id: m_axis
                    type: s4
                    if: _parent.model_version >= 14
  matrix_value:
    doc: Matrix<ElemType>::Write()
    doc-ref: https://github.com/microsoft/CNTK/blob/10a8ffcf50d7b9225f3236ffcfdc422b2014fb92/Source/Math/Matrix.cpp#L643-L663
    seq:
      - id: matrix_type
        type: u1
        enum: matrix_type
        valid: matrix_type::dense
        doc: |
          Only dense ('d') matrices are supported. Sparse ('s') matrices are
          written by GPUSparseMatrix's own serialiser and are rejected here
          rather than silently misparsed.
      - id: dense
        type: section_hardcode("MAT")
  section:
    seq:
      - id: begin_marker
        type: begin_marker
      - id: contents
        type: section_contents(begin_marker.name)
      - id: end_marker
        type: end_marker(begin_marker.name)
  section_hardcode:
    params:
      - id: name
        type: str
    seq:
      - id: begin_marker
        type: begin_marker_hardcode(name)
      - id: contents
        type: section_contents(begin_marker.name)
      - id: end_marker
        type: end_marker(begin_marker.name)

enums:
  matrix_type:
    0x64: dense # 'd'
    0x73: sparse # 's'
  pool_kind:
    0: none
    1: max
    2: average
  image_layout_kind:
    0: hwc # legacy; default for NDL
    1: chw # cudnn; default for BrainScript
