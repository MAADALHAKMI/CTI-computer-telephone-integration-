// file: call_table.dart
import 'package:sqflite/sqflite.dart';
import 'package:cti_training/models/call.dart';

class CallTable {
  static const tableName = 'call';
  static Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tableName (
        call_id INTEGER PRIMARY KEY,
        call_number TEXT,
        employ_id INTEGER,
        start_time TEXT,
        end_time TEXT,
        duration TEXT,
        FOREIGN KEY (call_number) REFERENCES customer(call_number),
        FOREIGN KEY (employ_id) REFERENCES employ(employ_id)
      )
    ''');
  }
}
  class CallRepository{

   Future<int> insertCall(Database db, Call call) async {
    return await db.insert('call', call.toMap());
  }

   Future<int> updateCall(Database db, Call call) async {
    return await db.update(
      'call',
      call.toMap(),
      where: 'call_id = ?',
      whereArgs: [call.callId],
    );
  }

   Future<int> deleteCall(Database db, int callId) async {
    return await db.delete(
      'call',
      where: 'call_id = ?',
      whereArgs: [callId],
    );
  }

   Future<List<Call>> getAllCalls(Database db) async {
    final List<Map<String, dynamic>> result = await db.query('call');
    return result.map((map) => Call.fromMap(map)).toList();
  }
}
