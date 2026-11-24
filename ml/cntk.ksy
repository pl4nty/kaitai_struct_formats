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
    seq:
      - id: count
        type: u8
      - id: values
        type: u1
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
      tensor_shape:
        seq:
          - id: rank
            type: u4
          - id: dims
            type: u4
            repeat: expr
            repeat-expr: rank
        doc: |
          Current layout as written by TensorShape::Save(); the pre-version-3
          legacy layout (three size_t W, H, C) is not handled.
        doc-ref: https://github.com/microsoft/CNTK/blob/10a8ffcf50d7b9225f3236ffcfdc422b2014fb92/Source/Common/Include/TensorShape.h#L401-L412
      version:
        seq:
          - id: major
            type: u4
          - id: reserved
            type: u4
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
          version:
            value: version_.contents.contents.as<version>

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
                  "float", "double", "half", ""
              - id: operation_name
                -orig-id: OperationName
                type: strz
              - id: node_name
                -orig-id: NodeName
                type: strz
              - id: node_specific
                doc: |
                  Payload written by the node's own `Save()`. Operations without
                  a case here (Plus, Sigmoid, ElementTimes, ErrorPrediction,
                  CrossEntropyWithSoftmax, ...) inherit the empty
                  `ComputationNodeBase::Save()` and write nothing.
                type:
                  switch-on: operation_name
                  cases:
                    '"InputValue"': input_value
                    '"SparseInputValue"': input_value
                    '"LearnableParameter"': learnable_parameter
                    '"Times"': times
                    '"TransposeTimes"': times
                    '"Convolution"': convolution
                    '"Pooling"': convolution
                    '"MaxPooling"': pooling
                    '"AveragePooling"': pooling
                    '"ROIPooling"': roi_pooling
            instances:
              model_version:
                value: _parent._parent.as<computation_network>.version.major
            types:
              input_value:
                doc-ref: https://github.com/microsoft/CNTK/blob/10a8ffcf50d7b9225f3236ffcfdc422b2014fb92/Source/ComputationNetworkLib/InputAndParamNodes.h#L303-L316
                seq:
                  - id: rows
                    -orig-id: rowsDummy
                    type: u8
                  - id: cols
                    -orig-id: colsDummy
                    type: u8
                  - id: sample_layout
                    -orig-id: m_sampleLayout
                    type: tensor_shape
                  - id: nr_axes
                    -orig-id: nrAxes
                    type: u4
                  - id: dynamic_axis_node_name
                    -orig-id: m_dynamicAxisNodeName
                    type: strz
                  - id: learning_rate_multiplier
                    -orig-id: m_learningRateMultiplier
                    type: f4

              learnable_parameter:
                doc: Layout for model version 3 and later.
                doc-ref: https://github.com/microsoft/CNTK/blob/10a8ffcf50d7b9225f3236ffcfdc422b2014fb92/Source/ComputationNetworkLib/InputAndParamNodes.cpp#L468-L476
                seq:
                  - id: learning_rate_multiplier
                    -orig-id: m_learningRateMultiplier
                    type: f4
                  - id: sample_layout
                    -orig-id: m_sampleLayout
                    type: tensor_shape
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
                seq:
                  - id: kernel_shape
                    -orig-id: m_kernelShape
                    type: tensor_shape
                    if: _parent.model_version > 5
                  - id: map_count
                    -orig-id: m_mapCount
                    type: tensor_shape
                    if: _parent.model_version > 5
                  - id: stride
                    -orig-id: m_stride
                    type: tensor_shape
                    if: _parent.model_version > 5
                  - id: sharing
                    -orig-id: m_sharing
                    type: vector_bool
                    if: _parent.model_version > 5
                  - id: auto_pad
                    -orig-id: m_autoPad
                    type: vector_bool
                    if: _parent.model_version > 5
                  - id: lower_pad
                    -orig-id: m_lowerPad.Load(fstream);
                    type: tensor_shape
                    if: _parent.model_version > 5
                  - id: upper_pad
                    -orig-id: m_upperPad.Load(fstream);
                    type: tensor_shape
                    if: _parent.model_version > 5
                  - id: pool_kind
                    -orig-id: m_poolKind
                    type: s4
                    enum: pool_kind
                    if: _parent.model_version > 5
                  - id: image_layout
                    -orig-id: m_imageLayout
                    type: s4
                    enum: image_layout_kind
                    if: _parent.model_version > 5
                  - id: max_temp_mem_size_in_samples
                    -orig-id: m_maxTempMemSizeInSamples
                    type: s8
                    if: _parent.model_version > 5
                  - id: transpose
                    -orig-id: m_transpose
                    type: u1
                    if: _parent.model_version > 9
                  - id: output_shape
                    -orig-id: m_outputShape
                    type: tensor_shape
                    if: _parent.model_version > 20
                  - id: ceil_out_dim
                    -orig-id: m_ceilOutDim
                    type: u1
                    if: _parent.model_version > 21
                  - id: pool_include_pad
                    -orig-id: m_poolIncludePad
                    type: u1
                    if: _parent.model_version > 23
              roi_pooling:
                seq:
                  - id: roi_output_shape
                    -orig-id: m_roiOutputShape
                    type: tensor_shape
                  - id: pool_kind
                    -orig-id: m_poolKind
                    type: s4
                    -default: max
                    enum: pool_kind
                    if: _parent.model_version > 26
                  - id: spatial_scale
                    -orig-id: m_spatialScale
                    type: s4
                    enum: pool_kind
                    -default: 1.0/16.0
                    if: _parent.model_version > 26
              pooling:
                seq:
                  - id: window_width
                    -orig-id: m_windowWidth
                    type: u8
                  - id: image_layout_kind
                    -orig-id: m_imageLayoutKind
                    type: s4
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
  matrix_value:
    doc: Matrix<ElemType>::Write()
    doc-ref: https://github.com/microsoft/CNTK/blob/10a8ffcf50d7b9225f3236ffcfdc422b2014fb92/Source/Math/Matrix.cpp#L643-L663
    seq:
      - id: matrix_type
        type: u1
        enum: matrix_type
      - id: dense
        type: section_hardcode("MAT")
        if: matrix_type == matrix_type::dense
        doc: |
          Sparse matrices ('s') are written by GPUSparseMatrix and are not
          handled here.
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
