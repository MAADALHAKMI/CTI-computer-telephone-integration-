import 'package:cti_training/models/db/db_helper.dart';
import 'package:flutter/material.dart';

import '../models/db/employe.dart';
import '../models/employe.dart';

class EmployScreen extends StatefulWidget {
  @override
  _EmployScreenState createState() => _EmployScreenState();
}

class _EmployScreenState extends State<EmployScreen> {
  late Future<List<Employ>> employList;

  @override
  void initState() {
    super.initState();
    employList = fetchEmployees();
    initializeDatabase();
  }

  void initializeDatabase() async {
    final db = await DBHelper.database;
    final repository = EmployRepository(db);
    await repository.initializeEmployees();
  }

  Future<List<Employ>> fetchEmployees() async {
    final db = await DBHelper.database; // الحصول على قاعدة البيانات
    final repository = EmployRepository(db);
    return await repository.getAllEmploys(); // جلب بيانات الموظفين
  }
// void clearEmployList(Future<List<Employ>> employList) {
//   setState(() {
//     employList = Future.value([]); // تعيين القائمة كقائمة فارغة
//   });
// }

  void deleteAll() async {
    final db = await DBHelper.database;
    final repository = EmployRepository(db);
    await repository.deleteAllEmploys(); // حذف البيانات من SQLite
    // setState(() {
    //    clearEmployList(employList); // حذف البيانات من القائمة داخل التطبيق
    //  });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('قائمة الموظفين'),
      actions: [ElevatedButton(onPressed: deleteAll, child: Icon(Icons.delete))],),
      body: FutureBuilder<List<Employ>>(
        future: employList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // مؤشر تحميل
          } else if (snapshot.hasError) {
            return Center(child: Text('حدث خطأ أثناء تحميل البيانات'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('لا توجد بيانات متاحة'));
          }

          final employees = snapshot.data!;
          return ListView.builder(
            itemCount: employees.length,
            itemBuilder: (context, index) {
              final employ = employees[index];
              return ListTile(
                title: Text(employ.name),
                subtitle: Text('القسم: ${employ.department}'),
                trailing: Icon(Icons.person, color: Colors.blue),
              );
            },
          );
        },

        //   ),
        //   ElevatedButton(onPressed:deleteAll , child: Icon(Icons.delete_forever))
      ),
    );
  }
}
