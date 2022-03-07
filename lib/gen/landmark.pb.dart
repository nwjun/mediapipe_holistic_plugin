///
//  Generated code. Do not modify.
//  source: landmark.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class Landmark extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Landmark', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'mediapipe'), createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'x', $pb.PbFieldType.OF)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'y', $pb.PbFieldType.OF)
    ..a<$core.double>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'z', $pb.PbFieldType.OF)
    ..a<$core.double>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'visibility', $pb.PbFieldType.OF)
    ..a<$core.double>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'presence', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  Landmark._() : super();
  factory Landmark({
    $core.double? x,
    $core.double? y,
    $core.double? z,
    $core.double? visibility,
    $core.double? presence,
  }) {
    final _result = create();
    if (x != null) {
      _result.x = x;
    }
    if (y != null) {
      _result.y = y;
    }
    if (z != null) {
      _result.z = z;
    }
    if (visibility != null) {
      _result.visibility = visibility;
    }
    if (presence != null) {
      _result.presence = presence;
    }
    return _result;
  }
  factory Landmark.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Landmark.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Landmark clone() => Landmark()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Landmark copyWith(void Function(Landmark) updates) => super.copyWith((message) => updates(message as Landmark)) as Landmark; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Landmark create() => Landmark._();
  Landmark createEmptyInstance() => create();
  static $pb.PbList<Landmark> createRepeated() => $pb.PbList<Landmark>();
  @$core.pragma('dart2js:noInline')
  static Landmark getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Landmark>(create);
  static Landmark? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get x => $_getN(0);
  @$pb.TagNumber(1)
  set x($core.double v) { $_setFloat(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasX() => $_has(0);
  @$pb.TagNumber(1)
  void clearX() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get y => $_getN(1);
  @$pb.TagNumber(2)
  set y($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasY() => $_has(1);
  @$pb.TagNumber(2)
  void clearY() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get z => $_getN(2);
  @$pb.TagNumber(3)
  set z($core.double v) { $_setFloat(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasZ() => $_has(2);
  @$pb.TagNumber(3)
  void clearZ() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get visibility => $_getN(3);
  @$pb.TagNumber(4)
  set visibility($core.double v) { $_setFloat(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasVisibility() => $_has(3);
  @$pb.TagNumber(4)
  void clearVisibility() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get presence => $_getN(4);
  @$pb.TagNumber(5)
  set presence($core.double v) { $_setFloat(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasPresence() => $_has(4);
  @$pb.TagNumber(5)
  void clearPresence() => clearField(5);
}

class LandmarkList extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LandmarkList', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'mediapipe'), createEmptyInstance: create)
    ..pc<Landmark>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'landmark', $pb.PbFieldType.PM, subBuilder: Landmark.create)
    ..hasRequiredFields = false
  ;

  LandmarkList._() : super();
  factory LandmarkList({
    $core.Iterable<Landmark>? landmark,
  }) {
    final _result = create();
    if (landmark != null) {
      _result.landmark.addAll(landmark);
    }
    return _result;
  }
  factory LandmarkList.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LandmarkList.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LandmarkList clone() => LandmarkList()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LandmarkList copyWith(void Function(LandmarkList) updates) => super.copyWith((message) => updates(message as LandmarkList)) as LandmarkList; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LandmarkList create() => LandmarkList._();
  LandmarkList createEmptyInstance() => create();
  static $pb.PbList<LandmarkList> createRepeated() => $pb.PbList<LandmarkList>();
  @$core.pragma('dart2js:noInline')
  static LandmarkList getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LandmarkList>(create);
  static LandmarkList? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Landmark> get landmark => $_getList(0);
}

class LandmarkListCollection extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'LandmarkListCollection', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'mediapipe'), createEmptyInstance: create)
    ..pc<LandmarkList>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'landmarkList', $pb.PbFieldType.PM, subBuilder: LandmarkList.create)
    ..hasRequiredFields = false
  ;

  LandmarkListCollection._() : super();
  factory LandmarkListCollection({
    $core.Iterable<LandmarkList>? landmarkList,
  }) {
    final _result = create();
    if (landmarkList != null) {
      _result.landmarkList.addAll(landmarkList);
    }
    return _result;
  }
  factory LandmarkListCollection.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LandmarkListCollection.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LandmarkListCollection clone() => LandmarkListCollection()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LandmarkListCollection copyWith(void Function(LandmarkListCollection) updates) => super.copyWith((message) => updates(message as LandmarkListCollection)) as LandmarkListCollection; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static LandmarkListCollection create() => LandmarkListCollection._();
  LandmarkListCollection createEmptyInstance() => create();
  static $pb.PbList<LandmarkListCollection> createRepeated() => $pb.PbList<LandmarkListCollection>();
  @$core.pragma('dart2js:noInline')
  static LandmarkListCollection getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LandmarkListCollection>(create);
  static LandmarkListCollection? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<LandmarkList> get landmarkList => $_getList(0);
}

class NormalizedLandmark extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'NormalizedLandmark', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'mediapipe'), createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'x', $pb.PbFieldType.OF)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'y', $pb.PbFieldType.OF)
    ..a<$core.double>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'z', $pb.PbFieldType.OF)
    ..a<$core.double>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'visibility', $pb.PbFieldType.OF)
    ..a<$core.double>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'presence', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  NormalizedLandmark._() : super();
  factory NormalizedLandmark({
    $core.double? x,
    $core.double? y,
    $core.double? z,
    $core.double? visibility,
    $core.double? presence,
  }) {
    final _result = create();
    if (x != null) {
      _result.x = x;
    }
    if (y != null) {
      _result.y = y;
    }
    if (z != null) {
      _result.z = z;
    }
    if (visibility != null) {
      _result.visibility = visibility;
    }
    if (presence != null) {
      _result.presence = presence;
    }
    return _result;
  }
  factory NormalizedLandmark.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory NormalizedLandmark.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  NormalizedLandmark clone() => NormalizedLandmark()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  NormalizedLandmark copyWith(void Function(NormalizedLandmark) updates) => super.copyWith((message) => updates(message as NormalizedLandmark)) as NormalizedLandmark; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NormalizedLandmark create() => NormalizedLandmark._();
  NormalizedLandmark createEmptyInstance() => create();
  static $pb.PbList<NormalizedLandmark> createRepeated() => $pb.PbList<NormalizedLandmark>();
  @$core.pragma('dart2js:noInline')
  static NormalizedLandmark getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NormalizedLandmark>(create);
  static NormalizedLandmark? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get x => $_getN(0);
  @$pb.TagNumber(1)
  set x($core.double v) { $_setFloat(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasX() => $_has(0);
  @$pb.TagNumber(1)
  void clearX() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get y => $_getN(1);
  @$pb.TagNumber(2)
  set y($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasY() => $_has(1);
  @$pb.TagNumber(2)
  void clearY() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get z => $_getN(2);
  @$pb.TagNumber(3)
  set z($core.double v) { $_setFloat(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasZ() => $_has(2);
  @$pb.TagNumber(3)
  void clearZ() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get visibility => $_getN(3);
  @$pb.TagNumber(4)
  set visibility($core.double v) { $_setFloat(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasVisibility() => $_has(3);
  @$pb.TagNumber(4)
  void clearVisibility() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get presence => $_getN(4);
  @$pb.TagNumber(5)
  set presence($core.double v) { $_setFloat(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasPresence() => $_has(4);
  @$pb.TagNumber(5)
  void clearPresence() => clearField(5);
}

class NormalizedLandmarkList extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'NormalizedLandmarkList', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'mediapipe'), createEmptyInstance: create)
    ..pc<NormalizedLandmark>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'landmark', $pb.PbFieldType.PM, subBuilder: NormalizedLandmark.create)
    ..hasRequiredFields = false
  ;

  NormalizedLandmarkList._() : super();
  factory NormalizedLandmarkList({
    $core.Iterable<NormalizedLandmark>? landmark,
  }) {
    final _result = create();
    if (landmark != null) {
      _result.landmark.addAll(landmark);
    }
    return _result;
  }
  factory NormalizedLandmarkList.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory NormalizedLandmarkList.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  NormalizedLandmarkList clone() => NormalizedLandmarkList()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  NormalizedLandmarkList copyWith(void Function(NormalizedLandmarkList) updates) => super.copyWith((message) => updates(message as NormalizedLandmarkList)) as NormalizedLandmarkList; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NormalizedLandmarkList create() => NormalizedLandmarkList._();
  NormalizedLandmarkList createEmptyInstance() => create();
  static $pb.PbList<NormalizedLandmarkList> createRepeated() => $pb.PbList<NormalizedLandmarkList>();
  @$core.pragma('dart2js:noInline')
  static NormalizedLandmarkList getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NormalizedLandmarkList>(create);
  static NormalizedLandmarkList? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<NormalizedLandmark> get landmark => $_getList(0);
}

class NormalizedLandmarkListCollection extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'NormalizedLandmarkListCollection', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'mediapipe'), createEmptyInstance: create)
    ..pc<NormalizedLandmarkList>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'landmarkList', $pb.PbFieldType.PM, subBuilder: NormalizedLandmarkList.create)
    ..hasRequiredFields = false
  ;

  NormalizedLandmarkListCollection._() : super();
  factory NormalizedLandmarkListCollection({
    $core.Iterable<NormalizedLandmarkList>? landmarkList,
  }) {
    final _result = create();
    if (landmarkList != null) {
      _result.landmarkList.addAll(landmarkList);
    }
    return _result;
  }
  factory NormalizedLandmarkListCollection.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory NormalizedLandmarkListCollection.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  NormalizedLandmarkListCollection clone() => NormalizedLandmarkListCollection()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  NormalizedLandmarkListCollection copyWith(void Function(NormalizedLandmarkListCollection) updates) => super.copyWith((message) => updates(message as NormalizedLandmarkListCollection)) as NormalizedLandmarkListCollection; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NormalizedLandmarkListCollection create() => NormalizedLandmarkListCollection._();
  NormalizedLandmarkListCollection createEmptyInstance() => create();
  static $pb.PbList<NormalizedLandmarkListCollection> createRepeated() => $pb.PbList<NormalizedLandmarkListCollection>();
  @$core.pragma('dart2js:noInline')
  static NormalizedLandmarkListCollection getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NormalizedLandmarkListCollection>(create);
  static NormalizedLandmarkListCollection? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<NormalizedLandmarkList> get landmarkList => $_getList(0);
}

