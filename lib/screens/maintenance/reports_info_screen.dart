import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:water_loss_project/api/report_api.dart';
import 'package:water_loss_project/constant/constant.dart';
import 'package:water_loss_project/data/department.dart';
import 'package:water_loss_project/data/report.dart';
import 'package:water_loss_project/screens/settings_screen.dart';
import 'package:water_loss_project/widgets/badge.dart';
import 'package:water_loss_project/widgets/button.dart';
import 'package:water_loss_project/constant/global.dart' as global;

class ReportsInfoScreen extends StatefulWidget {
  final Report report;

  const ReportsInfoScreen({super.key, required this.report});

  @override
  State<ReportsInfoScreen> createState() => _ReportsInfoScreenState();
}

class _ReportsInfoScreenState extends State<ReportsInfoScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final ReportApi _reportApi = ReportApi();
  TextEditingController pipeSizeController = TextEditingController();
  TextEditingController damageTypeController = TextEditingController();
  TextEditingController mildLengthController = TextEditingController(text: "0");
  TextEditingController holeLengthController = TextEditingController(text: "0");
  TextEditingController holeWidthController = TextEditingController(text: "0");
  bool loading = false;
  double pipeSizeMM = 0;
  String? _selectedPipeSize;
  String? _selectedDamageType;
  Report? report;
  bool pageDoneLoading = false;
  var dateTimeRepaired = DateTime.now();
  var dateTimeText = "";
  var waterLossDisplay = "";
  double totalConsumers = 0;
  DateFormat dateFormat = DateFormat("yyyy-MM-dd h:mm a");
  List<Department> departmentList = [];
  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(0, 0),
    zoom: 14.4746,
  );
  Set<Marker> markers = Set();

  var damageType = [
    'Crack',
    'Hole',
  ];

  var pipeSizesInch = [
    "1/2 inch",
    "1 inch",
    "1 1/4 inch",
    "1 1/2 inch",
    "2 inch",
    "3 inch",
  ];

  var pipeSizesMM = [12.70, 25.40, 31.75, 38.1, 50.8, 76.2];

  computeWaterLoss() async {
    setState(() {
      loading = true;
    });
    double damagePercentage = 0;
    double mildLength = double.parse(mildLengthController.text);
    double holeLength = double.parse(holeLengthController.text);
    double holeWidth = double.parse(holeWidthController.text);

    // ************* Get Damage Percentage *************
    if (_selectedDamageType == "Crack") {
      damagePercentage = (mildLength / pipeSizeMM) * 100;
      debugPrint(
          "damagePercentage - Crack: ${damagePercentage.toStringAsFixed(2)}");
    }
    if (_selectedDamageType == "Hole") {
      double area = double.parse((holeWidth * holeLength).toStringAsFixed(2));
      double radius = double.parse(sqrt(area / 3.14).toStringAsFixed(2));
      damagePercentage = (radius / pipeSizeMM) * 100;
      debugPrint(
          "damagePercentage - Hole: Radius: $radius. PipeSize: $pipeSizeMM. ${damagePercentage.toStringAsFixed(2)} - $damagePercentage");
    }

    // ************* GET VELOCITY *************
    double velocity = 0;
    double gravity = 9.8; //fixed
    double height = 10; // FIXED - TANK HEIGHT DEFAULT IS 20 METERS

    debugPrint(report!.department);

    // Department data = departmentList
    //     .firstWhere((element) => element.department == report!.department);
    // height = 20; // TANK HEIGHT DEFAULT IS 20 METERS
    debugPrint("height: $height");

    velocity = double.parse(sqrt((gravity * height) * 2).toStringAsFixed(2));
    debugPrint("velocity $velocity");

    // ************* GET RADIUS *************
    double radius = 0;
    radius = pipeSizeMM / 2;
    debugPrint("RADIUS: $radius");

    // ************* GET AREA *************

    double area = 0;
    area = double.parse((3.14 * (radius * radius)).toStringAsFixed(2));
    debugPrint("AREA: $area");

    // ************* GET FLOWRATE *************
    double flowrate = 0;
    flowrate = (velocity * area) / 1000;
    debugPrint("flowrate: $flowrate");

    // ************* GET WATER DISTRIBUTION *************

    double distribution = flowrate / totalConsumers;
    debugPrint("distribution: $distribution");
    // ************* Get time difference from the report date to repair date *************
    // final dateNow = DateTime.now();
    var currDate = DateTime.parse(report!.timeReported.toString());
    int timeInterval = dateTimeRepaired.difference(currDate).inSeconds;
    debugPrint("date reported: ${report!.timeReported.toString()}");

    debugPrint("difference: $timeInterval");

    // Get Water Loss
    double waterLoss = 0;
    waterLoss = timeInterval * (distribution / (100 / damagePercentage));
    double roundedWaterLoss = double.parse(waterLoss.toStringAsFixed(2));
    debugPrint("waterloss: $roundedWaterLoss");

    setState(() {
      waterLossDisplay = double.parse(waterLoss.toStringAsFixed(2)).toString();
    });

    await _reportApi.updateReport(
      report!.id,
      _selectedPipeSize,
      pipeSizeMM,
      _selectedDamageType,
      roundedWaterLoss,
      mildLength,
      holeLength,
      holeWidth,
      timeInterval,
      dateTimeRepaired,
    );
    //change status to repaired
    await changeReportStatus(STATUS_REPAIRED);
    // ignore: use_build_context_synchronously
    showTopSnackBar(
      context,
      const CustomSnackBar.success(
        message: "Report repaired.",
      ),
    );
    setState(() {
      loading = false;
    });
  }

  changeReportStatus(status) async {
    setState(() {
      loading = true;
    });
    await _reportApi.updateReportStatus(widget.report.id, status);
    getReportData();
    setState(() {
      loading = false;
    });
    // ignore: use_build_context_synchronously
    showTopSnackBar(
      context,
      const CustomSnackBar.success(
        message: "Report Confirmed.",
      ),
    );
  }

  getReportData() async {
    report = await _reportApi.getReportInfo(widget.report.id);
    setState(() {
      String? temp1;
      pipeSizeController.text = report!.pipeSize.toString();
      pipeSizeMM = report!.pipeSizeMM;
      mildLengthController.text = report!.mildLength.toString();
      holeLengthController.text = report!.holeLength.toString();
      holeWidthController.text = report!.holeWidth.toString();
      dateTimeRepaired = report!.timeRepaired;
      if (report!.status == STATUS_REPAIRED) {
        dateTimeText = dateFormat.format(report!.timeRepaired);
      }

      _selectedPipeSize = report!.pipeSize == "" ? temp1 : report!.pipeSize;
      _selectedDamageType =
          report!.damageType == "" ? temp1 : report!.damageType;
      pageDoneLoading = true;
    });
  }

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
            ));
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

  setReportLocation() async {
    setState(() {
      _kGooglePlex = CameraPosition(
        target: LatLng(widget.report.lat, widget.report.lng),
        zoom: 14.4746,
      );
    });

    BitmapDescriptor markerbitmap = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      "assets/images/car-repair-2.png",
    );

    markers.add(Marker(
      //add start location marker
      markerId:
          MarkerId(LatLng(widget.report.lat, widget.report.lng).toString()),
      position:
          LatLng(widget.report.lat, widget.report.lng), //position of marker
      infoWindow: InfoWindow(
        //popup info
        title: 'Starting Point ',
        snippet: 'Start Marker',
      ),
      icon: markerbitmap, //Icon for Marker
    ));
  }

  getTotalConsumers() async {
    await FirebaseFirestore.instance
        .collection(C_ACCOUNTS)
        .where(USER_TYPE, isEqualTo: "user")
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> snapshot) async {
      if (snapshot.docs.isNotEmpty) {
        setState(() {
          totalConsumers = double.parse(snapshot.size.toString());
        });
      }
    }).catchError((e) {
      debugPrint('No User Found -> error: $e');
    });
  }

  @override
  void initState() {
    getTotalConsumers();
    setReportLocation();
    getDepartments();
    getReportData();
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
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        elevation: 0,
        backgroundColor: const Color(0xff138756),
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
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 30.0),
        physics: const BouncingScrollPhysics(),
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            width: MediaQuery.of(context).size.width,
            height: 300.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Hero(
                tag: widget.report.imageLink,
                child: Image.network(
                  widget.report.imageLink,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            height: 150.0,
            width: MediaQuery.of(context).size.width,
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: GoogleMap(
                mapType: MapType.normal,
                markers: markers,
                initialCameraPosition: _kGooglePlex,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
            child: Text(
              widget.report.address,
              style: TextStyle(
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          GestureDetector(
            onTap: () {
              MapsLauncher.launchCoordinates(
                  widget.report.lat, widget.report.lng);
            },
            child: Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              decoration: BoxDecoration(
                color: COLOR_LIGHT_GREEN.withOpacity(0.5),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/google-maps.png",
                    height: 20.0,
                  ),
                  SizedBox(width: 5.0),
                  Text(
                    "Open location in google maps",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: COLOR_GREEN,
                    ),
                  ),
                ],
              ),
            ),
          ),
          !pageDoneLoading
              ? SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: const Center(
                    child: SizedBox(
                      height: 15,
                      width: 20,
                      child: LoadingIndicator(
                        indicatorType: Indicator.ballPulseSync,
                        colors: [Colors.red, Colors.amber, Colors.green],
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Report Information",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w800,
                          color: COLOR_GREEN,
                        ),
                      ),
                      Text(
                        "Reported on: ${dateFormat.format(report!.timeReported)}",
                        style: const TextStyle(color: Colors.black45),
                      ),
                      const Divider(
                        color: Colors.black12,
                      ),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        margin: const EdgeInsets.only(top: 10),
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
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      color: COLOR_LIGHT_GREEN.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          "${report!.waterLoss} L",
                                          style: const TextStyle(
                                            fontSize: 60.0,
                                            fontWeight: FontWeight.w600,
                                            color: COLOR_GREEN,
                                          ),
                                        ),
                                        const Text(
                                          "Water Loss",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w600,
                                            color: COLOR_GREEN,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  report!.status == STATUS_REPAIRED
                                      ? Column(
                                          children: [
                                            const SizedBox(height: 15),
                                            Text(
                                              "Pipe Size: ${report!.pipeSizeMM} mm",
                                              style: const TextStyle(
                                                fontSize: 15.0,
                                                // fontWeight: FontWeight.w600,
                                                color: COLOR_GREEN,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                            Text(
                                              "Time Reported: ${dateFormat.format(report!.timeReported)}",
                                              style: const TextStyle(
                                                fontSize: 15.0,
                                                // fontWeight: FontWeight.w600,
                                                color: COLOR_GREEN,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                            Text(
                                              "Time Repaired: ${dateFormat.format(report!.timeRepaired)}",
                                              style: const TextStyle(
                                                fontSize: 15.0,
                                                // fontWeight: FontWeight.w600,
                                                fontStyle: FontStyle.italic,
                                                color: COLOR_GREEN,
                                              ),
                                            ),
                                            Text(
                                              "Time Interval: ${(report!.timeInterval / 60).toStringAsFixed(2)} minutes",
                                              style: const TextStyle(
                                                fontSize: 15.0,
                                                // fontWeight: FontWeight.w600,
                                                fontStyle: FontStyle.italic,
                                                color: COLOR_GREEN,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15.0),
                            const Divider(
                              color: Colors.black12,
                            ),
                            const SizedBox(height: 15.0),
                            Text(
                              report!.name,
                              style: const TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              report!.email,
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.black45,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              "Description: ${report!.reason}",
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.orange,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            report!.status == STATUS_SUBMITTED
                                ? CustomBadge(
                                    title: report!.status,
                                    bgColor: Colors.orange,
                                    textColor: Colors.white)
                                : Container(),
                            report!.status == STATUS_CONFIRMED
                                ? CustomBadge(
                                    title: report!.status,
                                    bgColor: Colors.green,
                                    textColor: Colors.white)
                                : Container(),
                            report!.status == STATUS_REPAIRED
                                ? CustomBadge(
                                    title: report!.status,
                                    bgColor: Colors.blue,
                                    textColor: Colors.white)
                                : Container(),
                            const Divider(
                              color: Colors.black12,
                            ),
                            const SizedBox(height: 20.0),
                            const Text(
                              "Pipe Size",
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            DropdownButton(
                              hint: const Text("Choose Pipe Size"),
                              value: _selectedPipeSize,
                              items: pipeSizesInch.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedPipeSize = newValue!;
                                  for (int i = 0;
                                      i < pipeSizesInch.length;
                                      i++) {
                                    if (pipeSizesInch[i] == _selectedPipeSize) {
                                      pipeSizeMM = pipeSizesMM[i];
                                    }
                                  }
                                });
                              },
                            ),
                            Text("Converted to mm: $pipeSizeMM mm"),
                            const SizedBox(height: 30.0),
                            const Divider(
                              color: Colors.black12,
                            ),
                            const SizedBox(height: 30.0),
                            const Text(
                              "Damage Type",
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            DropdownButton(
                              hint: const Text("Choose Damage Type"),
                              value: _selectedDamageType,
                              items: damageType.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedDamageType = newValue!;
                                  mildLengthController.text = "0";
                                  holeLengthController.text = "0";
                                  holeWidthController.text = "0";
                                  for (int i = 0; i < damageType.length; i++) {
                                    if (damageType[i] == _selectedDamageType) {
                                      _selectedDamageType = damageType[i];
                                    }
                                  }
                                });
                              },
                            ),
                            _selectedDamageType == damageType[0]
                                ? Container(
                                    width: 170.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: TextFormField(
                                      controller: mildLengthController,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        border: UnderlineInputBorder(),
                                        labelText: 'Damage Length in Inches',
                                      ),
                                    ),
                                  )
                                : _selectedDamageType == damageType[1]
                                    ? Column(
                                        children: [
                                          Container(
                                            width: 170.0,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            child: TextFormField(
                                              controller: holeLengthController,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: const InputDecoration(
                                                border: UnderlineInputBorder(),
                                                labelText:
                                                    'Damage Length in mm',
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 170.0,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            child: TextFormField(
                                              controller: holeWidthController,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: const InputDecoration(
                                                border: UnderlineInputBorder(),
                                                labelText: 'Damage Width in mm',
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(),
                            const SizedBox(height: 30.0),
                            const Divider(
                              color: Colors.black12,
                            ),
                            const SizedBox(height: 30.0),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Text(
                                  "Repair Time: ",
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                GestureDetector(
                                  // Display a CupertinoDatePicker in dateTime picker mode.
                                  onTap: () => _showDialog(
                                    CupertinoDatePicker(
                                      mode: CupertinoDatePickerMode.dateAndTime,
                                      initialDateTime: DateTime.now(),
                                      onDateTimeChanged:
                                          (DateTime newDateTime) {
                                        DateFormat dateFormat =
                                            DateFormat("yyyy-MM-dd h:mm a");
                                        setState(() {
                                          dateTimeRepaired = newDateTime;
                                          dateTimeText =
                                              dateFormat.format(newDateTime);
                                        });
                                      },
                                    ),
                                  ),

                                  child: const Text(
                                    'Select Date and Time',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.amber,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                report!.status == STATUS_REPAIRED
                                    ? Text(
                                        dateFormat.format(report!.timeRepaired))
                                    : Text(dateTimeText),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      // GestureDetector(
                      //   onTap: () {
                      //     computeWaterLoss();
                      //   },
                      //   child: DefaultButton(
                      //       title: "Compute Water Loss", loading: loading),
                      // ),
                      const SizedBox(height: 10.0),
                      report!.status == STATUS_SUBMITTED
                          ? GestureDetector(
                              onTap: () {
                                // computeWaterLoss();
                                changeReportStatus(STATUS_CONFIRMED);
                              },
                              child: DefaultButton(
                                  title: "Confirm Report", loading: loading),
                            )
                          : Container(),
                      report!.status == STATUS_CONFIRMED
                          ? GestureDetector(
                              onTap: () {
                                if (pipeSizeMM == 0 ||
                                    _selectedDamageType == "" ||
                                    _selectedDamageType == null ||
                                    dateTimeText == "") {
                                  showTopSnackBar(
                                    context,
                                    const CustomSnackBar.error(
                                      message: "All fields are required",
                                    ),
                                  );
                                } else {
                                  computeWaterLoss();
                                }
                              },
                              child: DefaultButton(
                                  title: "Set to Repaired", loading: loading),
                            )
                          : Container(),
                      report!.status == STATUS_REPAIRED
                          ? Column(
                              children: [
                                const Text(
                                  "This report has already been repaired. You can edit and re-submit the information above.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black45, fontSize: 12.0),
                                ),
                                const SizedBox(height: 10),
                                GestureDetector(
                                  onTap: () {
                                    if (pipeSizeMM == 0 ||
                                        _selectedDamageType == "" ||
                                        _selectedDamageType == null ||
                                        dateTimeText == "") {
                                      showTopSnackBar(
                                        context,
                                        const CustomSnackBar.error(
                                          message: "All fields are required",
                                        ),
                                      );
                                    } else {
                                      computeWaterLoss();
                                    }
                                  },
                                  child: DefaultButton(
                                      title: "Re-submit Repair",
                                      loading: loading),
                                ),
                              ],
                            )
                          : Container(),
                      // GestureDetector(
                      //   onTap: () {},
                      //   child: DefaultButton(title: "Submit", loading: loading),
                      // ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
