// ✅ Step 1: db_helper.dart - responsible for initializing the database only
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'employe.dart';
import 'customer.dart';
import 'call.dart';
import 'transfer.dart';

class DBHelper {
  static Database? _db;
  static const String dbName = 'maad.db';

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await EmployTable.createTable(db);
        await CustomerTable.createTable(db);
        await CallTable.createTable(db);
        await TransferTable.createTable(db);
      },
    );
  }
}

