import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:water_loss_project/api/report_api.dart';
import 'package:water_loss_project/api/user_api.dart';
import 'package:water_loss_project/constant/constant.dart';
import 'package:water_loss_project/data/department.dart';
import 'package:water_loss_project/screens/settings_screen.dart';
import 'package:water_loss_project/widgets/badge.dart';
import 'package:water_loss_project/widgets/button.dart';
import 'package:water_loss_project/widgets/image_source_sheet.dart';
import 'package:water_loss_project/constant/global.dart' as global;

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  TextEditingController pipeSizeController = TextEditingController();
  TextEditingController reasonController = TextEditingController();
  final ReportApi _reportApi = ReportApi();
  final UserApi _userApi = UserApi();
  late File imageFile;
  bool imageUpload = false;
  bool loading = false;
  Department? _selectedDepartment;
  var dateTimeReported = DateTime.now();
  var dateTimeText = "";
  List<Department> departmentList = [];

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system
        // navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  void _getImage(BuildContext context) async {
    await showModalBottomSheet(
        context: context,
        builder: (context) => ImageSourceSheet(
              onImageSelected: (image) {
                if (image != null) {
                  setState(() {
                    imageFile = image;
                    imageUpload = true;
                  });
                  // close modal
                  Navigator.of(context).pop();
                }
              },
            ));
  }

  getUserInfo() async {
    global.user = await _userApi.getUserInfo();
  }

  getDepartments() async {
    await FirebaseFirestore.instance
        .collection(C_DEPARTMENTS)
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> snapshot) async {
      if (snapshot.docs.isNotEmpty) {
        snapshot.docs.forEach((doc) async {
          setState(() {
            departmentList.add(Department(
                department: doc.data()["department"],
                height: doc.data()["height"]));
          });
        });
      }
    }).catchError((e) {
      debugPrint('No User Found -> error: $e');
    });
  }

  @override
  void initState() {
    getDepartments();
    getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Report",
          style: TextStyle(color: COLOR_GREEN, fontWeight: FontWeight.w700),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => const SettingsScreen())));
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                FontAwesomeIcons.cog,
                color: Colors.black26,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(10.0),
        physics: const BouncingScrollPhysics(),
        children: [
          !imageUpload
              ? Center(
                  child: GestureDetector(
                    onTap: () {
                      _getImage(context);
                    },
                    child: Container(
                      width: 150.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        color: const Color(0xfff9f9f9),
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(width: 0.1, color: Colors.black45),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Upload Image",
                            style: TextStyle(
                              color: COLOR_GREEN,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10.0),
                            height: 30.0,
                            width: 30.0,
                            decoration: BoxDecoration(
                              color: COLOR_LIGHT_GREEN.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: const Center(
                              child: FaIcon(
                                FontAwesomeIcons.plus,
                                color: COLOR_GREEN,
                                size: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    width: 200,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.file(imageFile),
                    ),
                  ),
                ),
          const SizedBox(height: 20.0),
          const Divider(
            color: Colors.black12,
          ),
          const SizedBox(height: 20.0),
          const Text(
            "Report Water Leakage",
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w800,
              color: COLOR_GREEN,
            ),
          ),
          const Text(
            "Every reported leakage will help us maintain our good service inside the University.",
            style: TextStyle(color: Colors.black45),
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            margin: const EdgeInsets.only(top: 25.0),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: COLOR_LIGHT_GREEN.withOpacity(0.2),
              border: Border.all(width: 0.1, color: Colors.black45),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  global.user.name,
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  global.user.email,
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.black45,
                  ),
                ),
                Text(
                  global.user.occupation,
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.black45,
                  ),
                ),
                const SizedBox(height: 10.0),
                CustomBadge(
                    title: global.user.department,
                    bgColor: Colors.blue,
                    textColor: Colors.white),
                const SizedBox(height: 20.0),
                DropdownButton(
                  hint: const Text(
                    "Select Department",
                    style: TextStyle(fontSize: 14.0),
                  ),
                  value: _selectedDepartment,
                  items: departmentList.map((Department items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items.department),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedDepartment = value;
                    });
                  },
                ),
                const SizedBox(height: 20.0),
                GestureDetector(
                  // Display a CupertinoDatePicker in dateTime picker mode.
                  onTap: () => _showDialog(
                    CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.dateAndTime,
                      initialDateTime: DateTime.now(),
                      onDateTimeChanged: (DateTime newDateTime) {
                        DateFormat dateFormat = DateFormat("yyyy-MM-dd h:mm a");
                        setState(() {
                          dateTimeReported = newDateTime;
                          dateTimeText = dateFormat.format(newDateTime);
                        });
                      },
                    ),
                  ),

                  child: const Text(
                    'Select Date and Time',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.amber,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(dateTimeText),
                const SizedBox(height: 20.0),
                TextField(
                  controller: reasonController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: "Write a Description",
                    hintStyle: TextStyle(fontSize: 14.0),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 0.1, color: COLOR_GREEN),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 0.1, color: COLOR_GREEN),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 0.1, color: COLOR_GREEN),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 50.0),
          GestureDetector(
            onTap: () async {
              if (_selectedDepartment == null ||
                  dateTimeText == "" ||
                  !imageUpload) {
                showTopSnackBar(
                  context,
                  const CustomSnackBar.error(
                    message: "All fields are required",
                  ),
                );
              } else {
                setState(() {
                  loading = true;
                });
                await _reportApi.addReport(
                  email: global.user.email,
                  name: global.user.name,
                  contactNumber: global.user.contactNumber,
                  status: STATUS_SUBMITTED,
                  waterLoss: 0,
                  damageType: "Hole",
                  department: _selectedDepartment!.department,
                  reason: reasonController.text,
                  dateAndTime: dateTimeReported,
                  file: imageFile,
                );
                // ignore: use_build_context_synchronously
                showTopSnackBar(
                  context,
                  const CustomSnackBar.success(
                      message: "Report has been sent."),
                );
                setState(() {
                  loading = false;
                  imageUpload = false;
                  reasonController.text = "";
                });
              }
            },
            child: DefaultButton(title: "Send", loading: loading),
          ),
        ],
      ),
    );
  }
}
