import 'package:water_loss_project/constant/constant.dart';

class Department {
  /// User info
  final String department;
  final double height;

  // Constructor
  Department({
    required this.department,
    required this.height,
  });

  /// factory user object
  factory Department.fromDocument(Map<String, dynamic> doc) {
    return Department(
      department: doc[DEPARTMENT],
      height: doc[HEIGHT],
    );
  }
}
