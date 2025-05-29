class Employ {
  final int? employId;
  final String password;
  final String name;
  final String phoneNumber;
  final String email;
  final String department;

  Employ({
    this.employId,
    required this.password,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.department,
  });

  Map<String, dynamic> toMap() {
    return {
      'employ_id': employId,
      'password': password,
      'name': name,
      'phone_number': phoneNumber,
      'email': email,
      'department': department,
    };
  }

  factory Employ.fromMap(Map<String, dynamic> map) {
    return Employ(
      employId: map['employ_id'],
      password: map['password'],
      name: map['name'],
      phoneNumber: map['phone_number'],
      email: map['email'],
      department: map['department'],
    );
  }
}
