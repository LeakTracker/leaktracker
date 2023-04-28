import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:water_loss_project/constant/constant.dart';
import 'package:water_loss_project/data/report.dart';

class ReportApi {
  // Create a CollectionReference called users that references the firestore collection
  final _firestore = FirebaseFirestore.instance;
  CollectionReference reports =
      FirebaseFirestore.instance.collection(C_REPORTS);
  final _storageRef = FirebaseStorage.instance;

  addReport({
    required email,
    required name,
    required contactNumber,
    required status,
    required waterLoss,
    required damageType,
    required department,
    required reason,
    required dateAndTime,
    required file,
  }) async {
    // upload image
    String imageProfileUrl = "";

    imageProfileUrl = await uploadFile(
      file: file,
      path: 'uploads/reports/images',
    );

    // Call the user's CollectionReference to add a new user
    await reports.add({
      REPORT_EMAIL: email,
      REPORT_NAME: name,
      REPORT_CONTACT_NUMBER: contactNumber,
      REPORT_DAY: DateTime.now().day,
      REPORT_MONTH: DateTime.now().month,
      REPORT_YEAR: DateTime.now().year,
      REPORT_TIMESTAMP: DateTime.now(),
      REPORT_STATUS: status,
      REPORT_TIME_REPORTED: dateAndTime,
      REPORT_TIME_REPAIRED: DateTime.now(),
      REPORT_WATER_LOSS: waterLoss,
      REPORT_DAMAGE_TYPE: damageType,
      REPORT_IMAGE_LINK: imageProfileUrl,
      REPORT_REPAIRD: false,
      REPORT_DEPARTMENT: department,
      REPORT_REASON: reason,
    }).then((value) {
      debugPrint("Report Added");
      reports
          .doc(value.id)
          .update({
            REPORT_DOC_ID: value.id,
          })
          .then((value) => debugPrint("Report Updated"))
          .catchError((error) => debugPrint("Failed to update report: $error"));
    }).catchError((error) => debugPrint("Failed to add report: $error"));
  }

  /// Upload file to firesrore
  Future<String> uploadFile({
    required File file,
    required String path,
  }) async {
    // Image name
    String imageName = DateTime.now().millisecondsSinceEpoch.toString();
    // Upload file
    var ref = _storageRef.ref().child(path + '/' + imageName);
    await ref.putFile(file);
    // final TaskSnapshot snapshot = await uploadTask.onComplete;
    String url = await ref.getDownloadURL();
    // return file link
    return url;
  }

  updateReport(
      id,
      pipesize,
      double pipesizeMM,
      damageType,
      double waterLoss,
      double mildLength,
      double holeLength,
      double holeWidth,
      int timeInterval,
      timeRepaired) async {
    await reports
        .doc(id)
        .update({
          REPORT_PIPE_SIZE: pipesize,
          REPORT_PIPE_SIZE_MM: pipesizeMM,
          REPORT_DAMAGE_TYPE: damageType,
          REPORT_WATER_LOSS: waterLoss,
          REPORT_MILD_LENGTH: mildLength,
          REPORT_HOLE_LENGTH: holeLength,
          REPORT_HOLE_WIDTH: holeWidth,
          REPORT_TIME_REPAIRED: timeRepaired,
          REPORT_TIME_INTERVAL: timeInterval,
        })
        .then((value) => print("Report Updated"))
        .catchError((error) => print("Failed to update report: $error"));
  }

  updateReportStatus(id, String status) async {
    await reports
        .doc(id)
        .update({
          REPORT_STATUS: status,
        })
        .then((value) => print("Report Updated"))
        .catchError((error) => print("Failed to update report: $error"));
  }

  Future<Report> getReportInfo(id) async {
    Report reportInfo = await _firestore
        .collection(C_REPORTS)
        .where(REPORT_DOC_ID, isEqualTo: id)
        .get()
        .then((snapshot) {
      Report report = Report.fromDocument(snapshot.docs.first.data());
      return report;
    });
    return reportInfo;
  }
}
