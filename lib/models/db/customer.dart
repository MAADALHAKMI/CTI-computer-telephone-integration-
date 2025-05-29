// file: customer_table.dart
import 'package:sqflite/sqflite.dart';

import '../customer.dart';

class CustomerTable {
  static const String tableName = 'customer';
  static Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tableName (
        call_number TEXT PRIMARY KEY,
        name TEXT,
        status TEXT,
        complaints TEXT,
        services TEXT,
        last_update TEXT,
        organization TEXT,
        recammendion TEXT
      )
    ''');
  }
}

class CustomerRepository {
  Future<int> insertCustomer(Database db, Customer customer) async {
    return await db.insert('customer', customer.toMap());
  }

  Future<int> updateCustomer(Database db, Customer customer) async {
    return await db.update(
      'customer',
      customer.toMap(),
      where: 'call_number = ?',
      whereArgs: [customer.callNumber],
    );
  }

  Future<int> deleteCustomer(Database db, String callNumber) async {
    return await db.delete(
      'customer',
      where: 'call_number = ?',
      whereArgs: [callNumber],
    );
  }

  Future<List<Customer>> getAllCustomers(Database db) async {
    final List<Map<String, dynamic>> result = await db.query('customer');
    return result.map((map) => Customer.fromMap(map)).toList();
  }
}
