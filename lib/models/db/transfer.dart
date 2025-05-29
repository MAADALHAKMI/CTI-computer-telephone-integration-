// file: transfer_table.dart
import 'package:sqflite/sqflite.dart';

import '../transfer.dart';

class TransferTable {
  static const String tableName = 'transfer';
  static Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tableName (
        transfer_id INTEGER PRIMARY KEY,
        call_id INTEGER UNIQUE,
        time TEXT,
        from_employ INTEGER,
        to_employ INTEGER,
        FOREIGN KEY (call_id) REFERENCES call(call_id),
        FOREIGN KEY (from_employ) REFERENCES employ(employ_id),
        FOREIGN KEY (to_employ) REFERENCES employ(employ_id)
      )
    ''');
  }
}

class TransferRepository {
  Future<int> insertTransfer(Database db, Transfer transfer) async {
    return await db.insert('transfer', transfer.toMap());
  }

  Future<int> updateTransfer(Database db, Transfer transfer) async {
    return await db.update(
      'transfer',
      transfer.toMap(),
      where: 'transfer_id = ?',
      whereArgs: [transfer.transferId],
    );
  }

  Future<int> deleteTransfer(Database db, int transferId) async {
    return await db.delete(
      'transfer',
      where: 'transfer_id = ?',
      whereArgs: [transferId],
    );
  }

  Future<List<Transfer>> getAllTransfers(Database db) async {
    final List<Map<String, dynamic>> result = await db.query('transfer');
    return result.map((map) => Transfer.fromMap(map)).toList();
  }
}
