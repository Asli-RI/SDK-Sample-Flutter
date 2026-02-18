import 'package:flutter/services.dart';

class FlutterBridge {
  static const platform = MethodChannel('com.asliri.demo/liveness');

  // Fungsi untuk memulai liveness
static Future<void> startLiveness() async {
  try {
    print("FlutterBridge first");
    await platform.invokeMethod('startLiveness');
  } catch (e) {
    print("Failed to start liveness: $e");
  }
}

  // Fungsi untuk menangani hasil liveness
  static Future<String> getResult() async {
    try {
      final String result = await platform.invokeMethod('getResult');
      return result;
    } on PlatformException catch (e) {
      return "Failed to get liveness result: ${e.message}";
    }
  }
}