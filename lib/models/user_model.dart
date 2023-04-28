// import 'dart:io';
// import 'dart:math';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:http/http.dart' as http;

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart' as fireAuth;

// import '../data/user.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:water_loss_project/data/user.dart' as u;

final user = FirebaseAuth.instance.currentUser;

// Future<String?> getUserInfo() {
//   // if (user != null) {
//   //   // Name, email address, and profile photo URL
//   //   final name = user!.displayName;
//   //   final email = user!.email;
//   //   // final photoUrl = user!.photoURL;

//   //   // Check if user's email is verified
//   //   // final emailVerified = user!.emailVerified;

//   //   // The user's ID, unique to the Firebase project. Do NOT use this value to
//   //   // authenticate with your backend server, if you have one. Use
//   //   // User.getIdToken() instead.
//   //   final uid = user!.uid;

//   //   return email;
//   // }
//   // String? text = "dasd";
//   // return text;
// }

  /// Final Variables
  ///
  // final _firebaseAuth = fireAuth.FirebaseAuth.instance;
  // final _firestore = FirebaseFirestore.instance;
  // final _storageRef = FirebaseStorage.instance;

  // /// Other variables
  // ///
  // late User user;
  // bool userIsVip = false;
  // bool isLoading = false;
  // int currentIndex = 0;
  // bool hideButtons = false;
  // int videoRandom = 0;
  // Random random = new Random();

  ///*** FirebaseAuth and Firestore Methods ***///

  /// Get Firebase User
  /// Attempt to get previous logged in user
  // fireAuth.User get getFirebaseUser => _firebaseAuth.currentUser;

  /// Get user from database => [DocumentSnapshot]
  // Future<DocumentSnapshot> getUser(String userId) async {
  //   return await _firestore.collection("Accounts").doc(userId).get();
  // }

  /// Get user object => [User]
  // Future<User> getUserObject(String userId) async {
  //   /// Get Updated user info
  //   final DocumentSnapshot userDoc = await UserModel().getUser(userId);

  //   /// return user object
  //   return User.fromDocument(userDoc.data());
  // }

  // /// Get user from database to listen changes => stream of [DocumentSnapshot]
  // Stream<DocumentSnapshot> getUserStream() {
  //   return _firestore.collection(C_USERS).doc(getFirebaseUser.uid).snapshots();
  // }
