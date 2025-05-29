import 'package:cti_training/models/employe.dart';
import 'package:flutter/material.dart';


class EmployeeBottomSheet extends StatefulWidget {
  final Future<List<Employ>> Function() fetchEmployees;
  final String searchQuery;
  final Function(String) onSearchChange;

  EmployeeBottomSheet({
    required this.fetchEmployees,
    required this.searchQuery,
    required this.onSearchChange,
  });

  @override
  _EmployeeBottomSheetState createState() => _EmployeeBottomSheetState();
}

class _EmployeeBottomSheetState extends State<EmployeeBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("اختر الموظف",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              hintText: "بحث باسم الموظف أو القسم",
              hintStyle: TextStyle(color: Colors.grey),
              prefixIcon: Icon(Icons.search, color: Colors.white),
              filled: true,
              fillColor: Colors.grey[800],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
            style: TextStyle(color: Colors.white),
            onChanged: (value) {
              widget.onSearchChange(value); // تحديث البحث في الشاشة الأصلية
            },
          ),
          SizedBox(height: 15),
          SizedBox(
            height: 300,
            child: FutureBuilder<List<Employ>>(
              future: widget.fetchEmployees(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator()); // مؤشر تحميل
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text("⚠ حدث خطأ أثناء جلب البيانات", style: TextStyle(color: Colors.red)));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("🚫 لا توجد بيانات متاحة", style: TextStyle(color: Colors.grey)));
                }

                final filteredEmployees = snapshot.data!.where((emp) =>
                    emp.name.toLowerCase().contains(widget.searchQuery.toLowerCase()) ||
                    emp.department.toLowerCase().contains(widget.searchQuery.toLowerCase())).toList();

                return ListView.builder(
                  itemCount: filteredEmployees.length,
                  itemBuilder: (context, index) {
                    final employ = filteredEmployees[index];
                    return Card(
                      color: Colors.grey[850],
                      child: ListTile(
                        title: Text(employ.name, style: TextStyle(color: Colors.white)),
                        subtitle: Text("القسم: ${employ.department}", style: TextStyle(color: Colors.grey)),
                        trailing: Icon(Icons.person, color: Colors.white),
                        onTap: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("تم تحويل المكالمة إلى ${employ.name}", style: TextStyle(color: Colors.white)),
                              backgroundColor: Colors.blue,
                            ),
                          );
                        },
                      ),
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
