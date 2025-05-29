import 'package:cti_training/models/db/employe.dart';
import 'package:cti_training/models/employe.dart';
import 'package:cti_training/view/widget/transfer.dart';
import 'package:flutter/material.dart';
import 'package:phone_state/phone_state.dart';

import '../models/db/db_helper.dart';

class IncomingCallScreenn extends StatefulWidget {
  @override
  _IncomingCallScreennState createState() => _IncomingCallScreennState();
}

class _IncomingCallScreennState extends State<IncomingCallScreenn> {
  String searchQuery = "";

  void initializeDatabase() async {
    final db = await DBHelper.database;
    final repository = EmployRepository(db);
    await repository.initializeEmployees();
   // startListeningForCalls();
  }

  // void startListeningForCalls() {
  //   PhoneState.stream.listen((event) {
  //     if (event.status == PhoneStateStatus.CALL_INCOMING) {
  //       String phoneNumber =
  //           event.number ?? "غير معروف"; // التعامل مع القيم الفارغة
  //       print("📞 مكالمة واردة من: $phoneNumber");
  //       openCallScreen(phoneNumber);
  //     }
  //   });
  // }

  void showEmployeeSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return EmployeeBottomSheet(
          fetchEmployees: fetchEmployees, // جلب البيانات من SQLite
          searchQuery: searchQuery, // تمرير قيمة البحث
          onSearchChange: (value) {
            searchQuery = value;
          },
        );
      },
    );
  }

  Future<List<Employ>> fetchEmployees() async {
    final db = await DBHelper.database; // الحصول على قاعدة البيانات
    final repository = EmployRepository(db);
    return await repository.getAllEmploys(); // جلب بيانات الموظفين
  }

  late Future<List<Employ>> employList;
  @override
  void initState() {
    super.initState();
    employList = fetchEmployees();
    initializeDatabase();
  }

  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                '📞 رقم المتصل:',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              SizedBox(height: 30),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // فقط بعد الرد: زرّ كتم الصوت
                  ElevatedButton.icon(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    icon: Icon(Icons.call),
                    label: Text("رد"),
                    onPressed: () {},
                  ),

                  // فقط بعد الرد: زرّ مكبر الصوت

                  // زرّ التحويل (يبقى متاحًا بعد الرد أو قبل)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange),
                    icon: Icon(Icons.sync_alt),
                    label: Text("تحويل"),
                    onPressed: () {
                      showEmployeeSheet(context);
                    },
                  ),
                  // زرّ إنهاء المكالمة
                  ElevatedButton.icon(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    icon: Icon(Icons.call_end),
                    label: Text("إنهاء"),
                    onPressed: () {},
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
