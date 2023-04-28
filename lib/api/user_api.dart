import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:water_loss_project/constant/constant.dart';
import 'package:water_loss_project/data/user.dart';
import 'package:water_loss_project/constant/global.dart' as global;

class UserApi {
  // Create a CollectionReference called users that references the firestore collection
  final _firestore = FirebaseFirestore.instance;

  Future<User> getUserInfo() async {
    User userInfo = await _firestore
        .collection(C_ACCOUNTS)
        .where('email', isEqualTo: global.user_email)
        .get()
        .then((snapshot) {
      User user = User.fromDocument(snapshot.docs.first.data());
      return user;
    });
    return userInfo;
  }
}
