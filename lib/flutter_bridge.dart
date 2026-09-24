import 'package:flutter/services.dart';

class FlutterBridge {
  static const platform = MethodChannel('com.asliri.demo/ocr');

  // Fungsi untuk memulai ocr
  static Future<void> startOcr() async {
    try {
      print("FlutterBridge first");
      await platform.invokeMethod('startOcr');
    } catch (e) {
      print("Failed to start ocr: $e");
    }
  }

  // Fungsi untuk menangani hasil ocr
  static Future<String> getResult() async {
    try {
      final String result = await platform.invokeMethod('getResult');
      return result;
    } on PlatformException catch (e) {
      return "Failed to get result: ${e.message}";
    }
  }
}
