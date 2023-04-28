import 'package:water_loss_project/constant/constant.dart';

class User {
  /// User info
  final String id;
  final String email;
  final String name;
  final String contactNumber;
  final String occupation;
  final String department;
  final String userType;

  // Constructor
  User({
    required this.id,
    required this.email,
    required this.name,
    required this.contactNumber,
    required this.occupation,
    required this.department,
    required this.userType,
  });

  /// factory user object
  factory User.fromDocument(Map<String, dynamic> doc) {
    return User(
        id: doc[USER_DOC_ID],
        email: doc[USER_EMAIL],
        name: doc[USER_NAME],
        contactNumber: doc[USER_CONTACT_NUMBER],
        occupation: doc[USER_OCCUPATION],
        department: doc[USER_DEPARTMENT],
        userType: doc[USER_TYPE]);
  }
}
