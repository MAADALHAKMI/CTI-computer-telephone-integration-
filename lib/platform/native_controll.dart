import 'package:flutter/services.dart';

class CallControl {
  static const platform = MethodChannel('com.cti/call');

  static Future<void> endCall() async {
    try {
      await platform.invokeMethod('endCall');
    } on PlatformException catch (e) {
      print("❌ فشل إنهاء المكالمة: ${e.message}");
    }
  }

  static Future<void> answerCall() async {
    try {
      await platform.invokeMethod('answerCall');
    } on PlatformException catch (e) {
      print("❌ فشل الرد على المكالمة: ${e.message}");
    }
  }
}
