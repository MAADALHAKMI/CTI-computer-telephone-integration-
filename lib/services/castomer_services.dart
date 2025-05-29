// import 'dart:convert';
// import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

// import '../models/customer.dart';

// Future<Customer?> fetchCustomerInfo(String phoneNumber) async {
//   final url = Uri.parse(
//     "https://ormfxkzwqljcwuyyikrl.supabase.co/rest/v1/CRM?call_number=eq.$phoneNumber",
//   );

//   final response = await http.get(
//     url,
//     headers: {
//       'Content-Type': 'application/json',
//       'apikey':
//           'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9ybWZ4a3d1eXlpa3JsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcyNDczODAsImV4cCI6MjA2MjgyMzM4MH0._q653hCYTeSzmy1Q9RUz3-vUueqM2nl_HSn6tE3Fx1A',
//       'Authorization':
//           'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9ybWZ4a3d1eXlpa3JsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcyNDczODAsImV4cCI6MjA2MjgyMzM4MH0._q653hCYTeSzmy1Q9RUz3-vUueqM2nl_HSn6tE3Fx1A'
//     },
//   );

//   if (response.statusCode == 200) {
//     final List<dynamic> data = jsonDecode(response.body);
//     if (data.isNotEmpty) {
//       // هنا نفترض أن البيانات عبارة عن قائمة فيها عنصر واحد
//        final customerMap = data[0];
//       return Customer.fromMap(customerMap); // ✅ هذا يرجع Customer

//       print("✅ بيانات العميل: $Customer");
//     } else {
//       print("⚠️ لا توجد بيانات للعميل بهذا الرقم");
//       return null;
//     }
//   } else {
//     print("❌ فشل في جلب البيانات: ${response.body}");
//     return null;
//   }
// }

// Future<Customer?> ffetchCustomerInfo(String phoneNumber) async {
//   final url = Uri.parse(
//     "https://ormfxkzwqljcwuyyikrl.supabase.co/rest/v1/CRM?call_number=eq.$phoneNumber",
//   );

//   final response = await http.get(
//     url,
//     headers: {
//       'Content-Type': 'application/json',
//       'apikey':
//           'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9ybWZ4a3d1eXlpa3JsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcyNDczODAsImV4cCI6MjA2MjgyMzM4MH0._q653hCYTeSzmy1Q9RUz3-vUueqM2nl_HSn6tE3Fx1A',
//       'Authorization':
//           'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9ybWZ4a3d1eXlpa3JsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcyNDczODAsImV4cCI6MjA2MjgyMzM4MH0._q653hCYTeSzmy1Q9RUz3-vUueqM2nl_HSn6tE3Fx1A'
//     },
//   );

//   if (response.statusCode == 200) {
//     final List<dynamic> data = jsonDecode(response.body);
//     if (data.isNotEmpty) {
//       // نفترض أن الاستجابة عبارة عن قائمة تحتوي على عنصر واحد
//       final customerMap = data[0];
//       Customer customer = Customer.fromMap(customerMap);
//       print("✅ بيانات العميل (في الترمنال): ${customer.toMap()}");
//       return customer;
//     } else {
//       print("⚠️ لا توجد بيانات للعميل بهذا الرقم");
//       return null;
//     }
//   } else {
//     print("❌ فشل في جلب البيانات: ${response.body}");
//     return null;
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/customer.dart';
import '../models/db/db_helper.dart';

class CustomerService {
//   static Future<Map<String, dynamic>> ffetchCustomerInfo(
//       String phoneNumber) async {
//     final url = Uri.parse(
//       "https://ormfxkzwqljcwuyyikrl.supabase.co/rest/v1/CRM?phoneNumber=eq.$phoneNumber",
//     );

//     final response = await http.get(
//       url,
//       headers: {
//         'Content-Type': 'application/json',
//         'apikey':
//             'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9ybWZ4a3d1eXlpa3JsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcyNDczODAsImV4cCI6MjA2MjgyMzM4MH0._q653hCYTeSzmy1Q9RUz3-vUueqM2nl_HSn6tE3Fx1A',
//         'Authorization':
//             'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9ybWZ4a3d1eXlpa3JsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcyNDczODAsImV4cCI6MjA2MjgyMzM4MH0._q653hCYTeSzmy1Q9RUz3-vUueqM2nl_HSn6tE3Fx1A'
//       },
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       if (data is List && data.isNotEmpty) {
//         return data[0] as Map<String, dynamic>;
//       } else {
//         throw Exception("لا توجد بيانات للعميل");
//       }
//     } else {
//       throw Exception("فشل في جلب البيانات: ${response.body}");
//     }
//   }
// }

//   Future<Map<String, dynamic>> fetchCustomerInfo(String phoneNumber) async {
//     final url = Uri.parse(
//       "https://ormfxkzwqljcwuyyikrl.supabase.co/rest/v1/CRM?phoneNumber=eq.$phoneNumber",
//     );
//     final response = await http.get(
//       url,
//       headers: {
//         'Content-Type': 'application/json',
//         'apikey':
//             'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9ybWZ4a3p3cWxqY3d1eXlpa3JsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcyNDczODAsImV4cCI6MjA2MjgyMzM4MH0._q653hCYTeSzmy1Q9RUz3-vUueqM2nl_HSn6tE3Fx1A',
//         'Authorization':
//             'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9ybWZ4a3p3cWxqY3d1eXlpa3JsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDcyNDczODAsImV4cCI6MjA2MjgyMzM4MH0._q653hCYTeSzmy1Q9RUz3-vUueqM2nl_HSn6tE3Fx1A'
//       },
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       // في حال كانت الاستجابة قائمة نأخذ العنصر الأول
//       if (data is List && data.isNotEmpty) {
//         print(data[0]);
//         return data[0] as Map<String, dynamic>;

//       } else {
//         throw Exception("لا توجد بيانات للعميل");
//       }
//     } else {
//       throw Exception("فشل في جلب البيانات: ${response.body}");
//     }
//   }
// }

  Future<Map<String, dynamic>> fetchCustomerInfo(String phoneNumber) async {
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
      if (data is List && data.isNotEmpty) {
        final customerMap = data[0] as Map<String, dynamic>;

        // إعادة البيانات فورًا للعرض
        // وبدون انتظار التخزين
        _storeInDatabaseAsync(customerMap);

        return customerMap;
      } else {
        throw Exception("لا توجد بيانات للعميل");
      }
    } else {
      throw Exception("فشل في جلب البيانات: ${response.body}");
    }
  }

  void _storeInDatabaseAsync(Map<String, dynamic> customerMap) async {
    final db = await DBHelper.database;
  final customer = Customer.fromApi(customerMap);


    final rowsUpdated = await db.update(
      'customer',
      customer.toMap(),
      where: 'call_number = ?',
      whereArgs: [customer.callNumber],
    );

    if (rowsUpdated == 0) {
      final id = await db.insert('customer', customer.toMap());
      print(
          "تم إدخال بيانات العميل في SQLite برقم: ${customer.callNumber}, id: $id");
    } else {
      print("تم تحديث بيانات العميل في SQLite برقم: ${customer.callNumber}");
    }
  }


  Future<Map<String, dynamic>> getCustomerInfo(String phoneNumber) async {
  final db = await DBHelper.database;
  
  // البحث عن البيانات في جدول العملاء اعتماداً على رقم الاتصال (call_number)
  final result = await db.query(
    'customer',
    where: 'call_number = ?',
    whereArgs: [phoneNumber],
  );

  if (result.isNotEmpty) {
    print("✅ تم العثور على بيانات العميل في SQLite.");
    return result.first; // إعادة البيانات المتوفرة في SQLite
  } else {
    print("🚀 لا توجد بيانات في SQLite، سيتم جلبها من API.");
    return fetchCustomerInfo(phoneNumber);
  }
}

}
