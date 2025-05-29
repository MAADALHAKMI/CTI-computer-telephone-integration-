import 'package:sqflite/sqflite.dart';
import '../employe.dart';

class EmployTable {
  static const String tableName = 'employ';

  static Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tableName (
        employ_id INTEGER PRIMARY KEY,
        password TEXT,
        name TEXT,
        phone_number TEXT,
        email TEXT,
        department TEXT
      )
    ''');
  }
}

class EmployRepository {
  final Database db;
  EmployRepository(this.db);

  Future<int> insertEmploy(Employ employ) async {
    return await db.insert('employ', employ.toMap());
  }

  Future<int> updateEmploy(Employ employ) async {
    return await db.update(
      'employ',
      employ.toMap(),
      where: 'employ_id = ?',
      whereArgs: [employ.employId],
    );
  }

  Future<int> deleteEmploy(int id) async {
    return await db.delete(
      'employ',
      where: 'employ_id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Employ>> getAllEmploys() async {
    final List<Map<String, dynamic>> result = await db.query('employ');
    return result.map((map) => Employ.fromMap(map)).toList();
  }

  Future<void> initializeEmployees() async {
    final employees = await getAllEmploys();
    if (employees.isEmpty) {
      for (Employ employ in mockEmployees) {
        if (await checkIfEmployExists(employ.employId!))
          continue; // تجنب التكرار
        await insertEmploy(employ);
      }
    }
  }

  /// دالة للتحقق من وجود الموظف قبل إدراجه
  Future<bool> checkIfEmployExists(int id) async {
    final result = await db.query(
      'employ',
      where: 'employ_id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty;
  }

  Future<Employ?> login(int employId) async {
    final List<Map<String, dynamic>> result = await db.query(
      'employ',
      where: 'employ_id = ?',
      whereArgs: [employId],
    );

    return result.isNotEmpty ? Employ.fromMap(result.first) : null;
  }

  Future<int> deleteAllEmploys() async {
  return await db.delete('employ'); // يحذف كل الصفوف من الجدول
}

void clearEmployList(List<Employ> employees) {
  employees.clear(); // يفرغ القائمة
}

}

List<Employ> mockEmployees = [
  Employ(
      employId: 111,
      name: "أحمد محمد",
      phoneNumber: "77747447",
      email: "ahmed@example.com",
      department: "المبيعات",
      password: '123'),
  Employ(
      employId: 222,
      name: "خالد عبد الله",
      phoneNumber: "77896513",
      email: "khaled@example.com",
      department: "الدعم الفني",
      password: '123'),
  Employ(
      employId: 333,
      name: "سالم يوسف",
      phoneNumber: "77584653",
      email: "sara@example.com",
      department: "التسويق",
      password: '132'),
  Employ(
      employId: 444,
      name: "عبدالله يوسف",
      phoneNumber: "77584653",
      email: "sara@example.com",
      department: "الموارد البشرية",
      password: '132'),
  Employ(
      employId:555,
      name: "عدي عمر",
      phoneNumber: "77584653",
      email: "sara@example.com",
      department: "المحاسبة",
      password: '132'),
];
