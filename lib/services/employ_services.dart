import 'package:cti_training/models/db/db_helper.dart';
import 'package:cti_training/models/db/employe.dart';

import '../models/employe.dart';

class EmployService {
  static Future<List<Employ>> fetchEmployees() async {
    final db = await DBHelper.database;
    final repository = EmployRepository(db);
    return await repository.getAllEmploys();
  }
}
