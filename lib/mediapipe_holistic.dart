
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mediapipe_holistic/gen/landmark.pb.dart';

final NAMESPACE = "mediapipe_holistic";

typedef void HolisticViewCreatedCallback(
    HolisticViewController controller);

class HolisticView extends StatelessWidget {
  const HolisticView({required this.onViewCreated})
      : assert(onViewCreated != null);

  final HolisticViewCreatedCallback onViewCreated;

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return AndroidView(
          viewType: "$NAMESPACE/view",
          onPlatformViewCreated: (int id) => onViewCreated == null
              ? null
              : onViewCreated(HolisticViewController._(id)),

        );
      case TargetPlatform.fuchsia:
      case TargetPlatform.iOS:
      default:
        throw UnsupportedError(
            "Trying to use the default webview implementation for"
                " $defaultTargetPlatform but there isn't a default one");
    }
  }
}

class HolisticViewController {
  final MethodChannel _methodChannel;
  final EventChannel _eventChannel;

  HolisticViewController._(int id)
      : _methodChannel = MethodChannel("$NAMESPACE/$id"),
        _eventChannel = EventChannel("$NAMESPACE/$id/landmarks");

  Future<String> get platformVersion async =>
      await _methodChannel.invokeMethod("getPlatformVersion");

  Stream<NormalizedLandmarkList> get landMarksStream async* {
    yield* _eventChannel
        .receiveBroadcastStream()
        .map((buffer) => NormalizedLandmarkList.fromBuffer(buffer));
  }
}
