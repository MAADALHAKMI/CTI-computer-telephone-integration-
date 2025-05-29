// ui/incoming_call_screen.dart
import 'package:flutter/material.dart';
import '../../platform/native_controll.dart';
import '../../services/castomer_services.dart';
import '../../services/employ_services.dart';
import 'bottom_sheet.dart';
import 'infocard.dart';
import 'package:sqflite/sqflite.dart';

class IncomingCallScreen extends StatefulWidget {
  final String phoneNumber;

  const IncomingCallScreen({Key? key, required this.phoneNumber})
      : super(key: key);

  @override
  _IncomingCallScreenState createState() => _IncomingCallScreenState();
}

class _IncomingCallScreenState extends State<IncomingCallScreen> {
  late Future<Map<String, dynamic>> customerData;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    //customerData = CustomerService().fetchCustomerInfo(widget.phoneNumber);
    customerData = CustomerService().getCustomerInfo(widget.phoneNumber);
  }

// بدّل الدالة لتصبح بدون معطيات:
  void showEmployeeSheet() {
    showModalBottomSheet(
      context: context, // استخدم this.context
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => EmployeeBottomSheet(
        fetchEmployees: EmployService.fetchEmployees,
        searchQuery: searchQuery,
        onSearchChange: (val) => setState(() => searchQuery = val),
      ),
    );
  }

// ثمّ استدعيها مباشرة:

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: FutureBuilder<Map<String, dynamic>>(
            future: customerData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                final error = snapshot.error.toString();
                final isOffline = error.contains('SocketException');
                SizedBox(
                  height: 50,
                );
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '📞 رقم المتصل:',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    Text(
                      widget.phoneNumber.isNotEmpty
                          ? widget.phoneNumber
                          : "غير معروف",
                      style: const TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    Spacer(),
                    Text(
                      isOffline
                          ? "⚠️ لا يوجد اتصال بالإنترنت"
                          : "❌ لايوجد معلومات عن هذا الرقم    ",
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const Spacer(),
                    buildCallButtons(context),
                  ],
                );
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                final customer = snapshot.data!;
                return Center(
                  child: Column(
                    children: [
                      const Text(
                        '📞 رقم المتصل:',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      Text(
                        widget.phoneNumber.isNotEmpty
                            ? widget.phoneNumber
                            : "غير معروف",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 24),
                      ),
                      const SizedBox(height: 30),
                      Card(
                        color: Colors.grey[850],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              infoTile(
                                  Icons.person, "اسم العميل", customer['name']),
                              infoTile(Icons.info, "حالة العميل",
                                  customer['status']),
                              infoTile(Icons.business, "الجهة / الشركة",
                                  customer['organization']),
                              infoTile(Icons.miscellaneous_services,
                                  "الخدمات المقدمة", customer['services']),
                              infoTile(Icons.report_problem, "الشكوى",
                                  customer['complaince']),
                              infoTile(Icons.description, "الملخص",
                                  customer['recammendion']),
                              infoTile(Icons.update, "آخر تحديث",
                                  customer['lastUpdate']),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      buildCallButtons(context),
                    ],
                  ),
                );
              } else {
                // في حال snapshot.hasData لكن البيانات فارغة أو حالة غير متوقعة
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📞 رقم المتصل:',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    Text(
                      widget.phoneNumber.isNotEmpty
                          ? widget.phoneNumber
                          : "غير معروف",
                      style: const TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "🙁 لا توجد بيانات للعرض.",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const Spacer(),
                    buildCallButtons(context),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildCallButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AnimatedActionButton(
          color: Colors.green,
          icon: Icons.call,
          label: "رد",
          onTap: () async {
            await CallControl.answerCall();
            Navigator.pop(context);
          },
        ),
        AnimatedActionButton(
            color: Colors.orange,
            icon: Icons.sync_alt,
            label: "تحويل",
            onTap: showEmployeeSheet),
        AnimatedActionButton(
          color: Colors.red,
          icon: Icons.call_end,
          label: "إنهاء",
          onTap: () async => await CallControl.endCall(),
        ),
      ],
    );
  }
}

/// زرّ متحرك واحترافي: يكبُر عند الضغط، وله ظل متوهّج
class AnimatedActionButton extends StatefulWidget {
  final Color color;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const AnimatedActionButton({
    Key? key,
    required this.color,
    required this.icon,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  _AnimatedActionButtonState createState() => _AnimatedActionButtonState();
}

class _AnimatedActionButtonState extends State<AnimatedActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctr;
  late Animation<double> _scaleAnim;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _ctr = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.1,
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _ctr, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctr.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails d) {
    _ctr.forward();
    setState(() => _pressed = true);
  }

  void _onTapUp(TapUpDetails d) {
    _ctr.reverse();
    setState(() => _pressed = false);
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: () {
        _ctr.reverse();
        setState(() => _pressed = false);
      },
      child: AnimatedBuilder(
        animation: _ctr,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnim.value,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(30),
                boxShadow: _pressed
                    ? [
                        BoxShadow(
                          color: widget.color.withOpacity(0.6),
                          blurRadius: 20,
                          spreadRadius: 1,
                        )
                      ]
                    : [],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(widget.icon, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    widget.label,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
