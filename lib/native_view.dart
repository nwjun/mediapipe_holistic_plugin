import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:mediapipe_holistic/gen/landmark.pb.dart';

const NAMESPACE = 'mediapipe_holistic';

class NativeViewDart extends StatelessWidget {
  final CreatePlatformViewCallback createPlatformViewCallback;

  const NativeViewDart({Key? key, required this.createPlatformViewCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This is used in the platform side to register the view.
    const String viewType = '$NAMESPACE/view';
    // Pass parameters to the platform side.
    const Map<String, dynamic> creationParams = <String, dynamic>{};

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        // virtual display
        return const AndroidView(
          viewType: viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: creationParams,
          creationParamsCodec: StandardMessageCodec(),
        );
        // hybrid composition
        return PlatformViewLink(
          viewType: viewType,
          surfaceFactory:
              (BuildContext context, PlatformViewController controller) {
            return AndroidViewSurface(
                controller: controller as AndroidViewController,
                hitTestBehavior: PlatformViewHitTestBehavior.opaque,
                gestureRecognizers: const <
                    Factory<OneSequenceGestureRecognizer>>{});
          },
          onCreatePlatformView: createPlatformViewCallback,
        );
      default:
        throw UnsupportedError('Unsupported platform view');
    }
  }
}
