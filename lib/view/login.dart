import 'package:cti_training/view/employ.dart';
import 'package:cti_training/view/home.dart';
import 'package:flutter/material.dart';
import 'package:cti_training/models/db/db_helper.dart';
import 'package:cti_training/models/db/employe.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController idController = TextEditingController();

  @override
  void initState() {
    super.initState();

    initializeDatabase();
  }

  void initializeDatabase() async {
    final db = await DBHelper.database;
    final repository = EmployRepository(db);
    await repository.initializeEmployees();
  }

  String? errorMessage;

  void login() async {
    final db = await DBHelper.database;
    final repository = EmployRepository(db);
    final employ = await repository.login(int.tryParse(idController.text) ?? 0);

    if (employ != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => IncomingCallScreenn()),
      );
    } else {
      setState(() {
        errorMessage = "⚠ الموظف غير موجود، تحقق من الرقم!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("تسجيل الدخول")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: idController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "أدخل رقم الموظف"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: login,
              child: Text("تسجيل الدخول"),
            ),
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
