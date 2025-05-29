import 'package:flutter/material.dart';
import 'package:cti_training/models/db/employe.dart';

import '../../models/employe.dart';

class EmployeeBottomSheet extends StatefulWidget {
  final Future<List<Employ>> Function() fetchEmployees;
  final String searchQuery;
  final Function(String) onSearchChange;

  const EmployeeBottomSheet({
    Key? key,
    required this.fetchEmployees,
    required this.searchQuery,
    required this.onSearchChange,
  }) : super(key: key);

  @override
  _EmployeeBottomSheetState createState() => _EmployeeBottomSheetState();
}

class _EmployeeBottomSheetState extends State<EmployeeBottomSheet> {
  late Future<List<Employ>> employees;

  @override
  void initState() {
    super.initState();
    employees = widget.fetchEmployees();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: '🔍 ابحث عن موظف',
              labelStyle: TextStyle(color: Colors.white),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            onChanged: (value) {
              widget.onSearchChange(value);
              setState(() {});
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<List<Employ>>(
              future: employees,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('❌ ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('لا يوجد موظفين'));
                }

                final filteredEmployees = snapshot.data!
                    .where((e) => e.name
                        .toLowerCase()
                        .contains(widget.searchQuery.toLowerCase()))
                    .toList();

                return ListView.builder(
                  itemCount: filteredEmployees.length,
                  itemBuilder: (context, index) {
                    final employee = filteredEmployees[index];
                    return ListTile(
                      trailing: const Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      title: Text(
                        employee.name,
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        employee.department,
                        style: const TextStyle(color: Colors.white70),
                      ),
                      onTap: () {
                        // تنفيذ عند اختيار الموظف
                        Navigator.pop(context, employee);
                        // ✅ عرض SnackBar بعد التحويل مباشرة
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("تم التحويل بنجاح!", style: TextStyle(fontSize: 16)),
      backgroundColor: Colors.orange,
      duration: Duration(seconds: 2),
    ),
  );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
