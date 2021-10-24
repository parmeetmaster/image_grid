
import 'dart:async';

import 'package:flutter/services.dart';

class ImageGrid {
  static const MethodChannel _channel = MethodChannel('image_grid');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
