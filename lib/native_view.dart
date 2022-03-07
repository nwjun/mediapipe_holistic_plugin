import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

const NAMESPACE = 'mediapipe_holistic';

class NativeViewDart extends StatelessWidget {
  const NativeViewDart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This is used in the platform side to register the view.
    const String viewType = '$NAMESPACE/view';
    // Pass parameters to the platform side.
    const Map<String, dynamic> creationParams = <String, dynamic>{};

    switch(defaultTargetPlatform){
      case TargetPlatform.android:
      // hybrid composition
        return PlatformViewLink(
          viewType: viewType,
          surfaceFactory: (BuildContext context, PlatformViewController controller) {
            return AndroidViewSurface(
                controller: controller as AndroidViewController,
                hitTestBehavior: PlatformViewHitTestBehavior.opaque,
                gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{});
          },
          onCreatePlatformView: (PlatformViewCreationParams params) {
            return PlatformViewsService.initSurfaceAndroidView(
              id: params.id,
              viewType: viewType,
              layoutDirection: TextDirection.ltr,
              creationParams: creationParams,
              creationParamsCodec: const StandardMessageCodec(),
              onFocus: () {
                params.onFocusChanged(true);
              },
            )
              ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
              ..create();
          },
        );
      default:
        throw UnsupportedError('Unsupported platform view');
    }
  }
}
