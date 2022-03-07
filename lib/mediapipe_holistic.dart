
import 'dart:async';

import 'package:flutter/services.dart';

class MediapipeHolistic {
  static const MethodChannel _channel = MethodChannel('mediapipe_holistic');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
