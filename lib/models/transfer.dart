
class Transfer {
  final int? transferId;
  final int callId;
  final String time;
  final int fromEmploy;
  final int toEmploy;

  Transfer({
    this.transferId,
    required this.callId,
    required this.time,
    required this.fromEmploy,
    required this.toEmploy,
  });

  Map<String, dynamic> toMap() {
    return {
      'transfer_id': transferId,
      'call_id': callId,
      'time': time,
      'from_employ': fromEmploy,
      'to_employ': toEmploy,
    };
  }

  factory Transfer.fromMap(Map<String, dynamic> map) {
    return Transfer(
      transferId: map['transfer_id'],
      callId: map['call_id'],
      time: map['time'],
      fromEmploy: map['from_employ'],
      toEmploy: map['to_employ'],
    );
  }
}