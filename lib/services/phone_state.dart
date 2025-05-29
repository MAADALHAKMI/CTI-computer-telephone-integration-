import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phone_state/phone_state.dart';
import 'package:cti_training/view/widget/coming_call.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CallListenerScreen extends StatefulWidget {
  @override
  _CallListenerScreenState createState() => _CallListenerScreenState();
}

class _CallListenerScreenState extends State<CallListenerScreen> {
  @override
  void initState() {
    super.initState();
    requestPermissions();
    initPlatformChannel();
  }

  void requestPermissions() async {
    var status = await Permission.phone.request();
    if (status.isGranted) {
      startListeningForCalls();
    } else {
      print("❌ لم يتم منح صلاحية المكالمات");
    }
  }

  void startListeningForCalls() {
    PhoneState.stream.listen((event) {
      if (event.status == PhoneStateStatus.CALL_INCOMING) {
        String phoneNumber = event.number ?? "غير معروف";
        print("📞 مكالمة واردة من: $phoneNumber");
        openCallScreen(phoneNumber);
      }
    });
  }

  void openCallScreen(String phoneNumber) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IncomingCallScreen(phoneNumber: phoneNumber),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("في انتظار المكالمات..."),
      ),
    );
  }

  Future<void> fetchCustomerInfo(String phoneNumber) async {
    final url = Uri.parse(
      "https://ormfxkzwqljcwuyyikrl.supabase.co/rest/v1/CRM?phoneNumber=eq.$phoneNumber",
    );

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9ybWZ4a3p3cWxqY3d1eXlpa3JsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcyNDczODAsImV4cCI6MjA2MjgyMzM4MH0._q653hCYTeSzmy1Q9RUz3-vUueqM2nl_HSn6tE3Fx1A',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9ybWZ4a3p3cWxqY3d1eXlpa3JsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcyNDczODAsImV4cCI6MjA2MjgyMzM4MH0._q653hCYTeSzmy1Q9RUz3-vUueqM2nl_HSn6tE3Fx1A'
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("✅ بيانات العميل: $data");
    } else {
      print("❌ فشل في جلب البيانات: ${response.body}");
    }
  }

  static const platform = MethodChannel("com.cti/call");

  void initPlatformChannel() {
    platform.setMethodCallHandler((call) async {
      if (call.method == "onIncomingCall") {
        String number = call.arguments;
        print("📞 تم استقبال رقم من Kotlin: $number");

        // تأكد أن الرقم ليس فارغ أو خطأ
        if (number.isNotEmpty && int.tryParse(number) != null) {
          await fetchCustomerInfo(number);
        } else {
          print("⚠️ الرقم غير صالح أو فارغ: $number");
        }
      }
      return;
    });

    // نطلب من Android أن يبدأ الاستماع
    platform.invokeMethod("listenIncomingNumber");
  }
}
