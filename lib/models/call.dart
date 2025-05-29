
class Call {
  final int? callId;
  final String callNumber;
  final int employId;
  final String startTime;
  final String endTime;
  final String duration;

  Call({
    this.callId,
    required this.callNumber,
    required this.employId,
    required this.startTime,
    required this.endTime,
    required this.duration,
  });

  Map<String, dynamic> toMap() {
    return {
      'call_id': callId,
      'call_number': callNumber,
      'employ_id': employId,
      'start_time': startTime,
      'end_time': endTime,
      'duration': duration,
    };
  }

  factory Call.fromMap(Map<String, dynamic> map) {
    return Call(
      callId: map['call_id'],
      callNumber: map['call_number'],
      employId: map['employ_id'],
      startTime: map['start_time'],
      endTime: map['end_time'],
      duration: map['duration'],
    );
  }
}
