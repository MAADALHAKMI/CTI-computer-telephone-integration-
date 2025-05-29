class Customer {
  final String? callNumber;
  final String? name;
  final String? status;
  final String? complaints;
  final String? services;
  final DateTime? lastUpdate;
  final String? organization;
  final String? recammendion;

  Customer({
    required this.callNumber,
    required this.name,
    required this.status,
    required this.complaints,
    required this.services,
    required this.lastUpdate,
    required this.organization,
    required this.recammendion,
  });

  /// لتحزين البيانات في SQLite
  Map<String, dynamic> toMap() {
    return {
      'call_number': callNumber,
      'name': name,
      'status': status,
      'complaints': complaints,
      'services': services,
      'last_update': lastUpdate?.toIso8601String(),
      'organization': organization,
      'recammendion': recammendion,
    };
  }

  /// لاسترجاع البيانات من SQLite
  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      callNumber: map['call_number'],
      name: map['name'],
      status: map['status'],
      complaints: map['complaints'],
      services: map['services'],
      organization: map['organization'],
      lastUpdate: map['last_update'] != null
          ? DateTime.tryParse(map['last_update'])
          : null,
      recammendion: map['recammendion'],
    );
  }

  /// اختياري: لإنشاء كائن من بيانات الـ API (إذا كانت أسماء الحقول مختلفة)
  factory Customer.fromApi(Map<String, dynamic> map) {
    return Customer(
      callNumber: map['phoneNumber']?.toString(), // <-- هنا التحويل
      name: map['name'],
      status: map['status'],
      complaints: map['complaince'],
      services: map['services'],
      organization: map['organization'],
      lastUpdate: map['lastUpdate'] != null
          ? DateTime.tryParse(map['lastUpdate'])
          : null,
      recammendion: map['recammendion'],
    );
  }
}
