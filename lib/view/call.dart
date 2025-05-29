import 'package:flutter/material.dart';

class Call {
  final String number;
  final String name;
  final DateTime startTime;
  final DateTime endTime;
  final bool isAnswered;
  final bool isTransferred;
  final String? transferredFrom;
  final String? transferredTo;

  Call({
    required this.number,
    required this.name,
    required this.startTime,
    required this.endTime,
    this.isAnswered = true,
    this.isTransferred = false,
    this.transferredFrom,
    this.transferredTo,
  });

  Duration get duration => endTime.difference(startTime);
}

class CallHistoryScreen extends StatelessWidget {
  final List<Call> calls = [
    Call(
      number: '+966500000001',
      name: 'أحمد العمري',
      startTime: DateTime.now().subtract(Duration(minutes: 12)),
      endTime: DateTime.now().subtract(Duration(minutes: 5)),
      isAnswered: true,
      isTransferred: true,
      transferredFrom: 'سارة العتيبي',
      transferredTo: 'خالد المطيري',
    ),
    Call(
      number: '+966500000002',
      name: 'سارة العتيبي',
      startTime: DateTime.now().subtract(Duration(hours: 1, minutes: 10)),
      endTime: DateTime.now().subtract(Duration(hours: 1)),
      isAnswered: false,
    ),
    // ... المزيد من المكالمات
  ];

  String _formatTime(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        title: Text('سجل المكالمات'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: calls.length,
        itemBuilder: (ctx, i) {
          final call = calls[i];
          return Card(
              color: Colors.grey[850],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: Icon(
                  call.isAnswered ? Icons.call : Icons.call_missed,
                  color: call.isAnswered ? Colors.green : Colors.red,
                ),
                title: Text(call.name,
                    style: TextStyle(color: Colors.white, fontSize: 18)),
                subtitle: Text(call.number,
                    style: TextStyle(color: Colors.grey[400])),
                trailing: call.isTransferred
                    ? Icon(Icons.sync_alt, color: Colors.orange)
                    : null,
                onTap: () => _showCallDetails(context, call),
              ));
        },
      ),
    );
  }

  void _showCallDetails(BuildContext context, Call call) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('تفاصيل المكالمة',
                  style: TextStyle(
                      color: Colors.tealAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              _detailRow('تم الرد:', call.isAnswered ? 'نعم' : 'لا'),
              _detailRow('رقم المتصل:', call.number),
              _detailRow('الاسم:', call.name),
              _detailRow('بداية المكالمة:', _formatTime(call.startTime)),
              _detailRow('نهاية المكالمة:', _formatTime(call.endTime)),
              _detailRow('المدة:', _formatDuration(call.duration)),
              _detailRow('تم التحويل:', call.isTransferred ? 'نعم' : 'لا'),
              if (call.isTransferred) ...[
                _detailRow('من:', call.transferredFrom!),
                _detailRow('إلى:', call.transferredTo!),
              ],
              SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.tealAccent[700]),
                  child: Text('إغلاق', style: TextStyle(color: Colors.black)),
                  onPressed: () => Navigator.pop(ctx),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(label,
              style: TextStyle(
                  color: Colors.white70, fontWeight: FontWeight.w600)),
          SizedBox(width: 8),
          Expanded(
            child: Text(value,
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w400)),
          ),
        ],
      ),
    );
  }
}
