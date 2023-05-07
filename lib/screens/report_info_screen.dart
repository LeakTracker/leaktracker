import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:water_loss_project/constant/constant.dart';
import 'package:water_loss_project/data/department.dart';
import 'package:water_loss_project/data/report.dart';
import 'package:water_loss_project/screens/settings_screen.dart';
import 'package:water_loss_project/widgets/badge.dart';

class ReportInfoScreen extends StatefulWidget {
  final Report report;

  const ReportInfoScreen({super.key, required this.report});

  @override
  State<ReportInfoScreen> createState() => _ReportInfoScreenState();
}

class _ReportInfoScreenState extends State<ReportInfoScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  List<Department> departmentList = [];
  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(0, 0),
    zoom: 14.4746,
  );
  Set<Marker> markers = Set();

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

    setState(() {
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
    });
  }

  @override
  void initState() {
    setReportLocation();
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
          const SizedBox(height: 10.0),
          Padding(
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
                  "Reported on: ${widget.report.timestamp}",
                  style: TextStyle(color: Colors.black45),
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
                      Text(
                        widget.report.name,
                        style: const TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        widget.report.email,
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.black45,
                        ),
                      ),
                      Text(
                        widget.report.department,
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.black45,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        "Reason: ${widget.report.reason}",
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.orange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      widget.report.status == STATUS_SUBMITTED
                          ? CustomBadge(
                              title: widget.report.status,
                              bgColor: Colors.orange,
                              textColor: Colors.white)
                          : Container(),
                      widget.report.status == STATUS_CONFIRMED
                          ? CustomBadge(
                              title: widget.report.status,
                              bgColor: Colors.green,
                              textColor: Colors.white)
                          : Container(),
                      widget.report.status == STATUS_REPAIRED
                          ? CustomBadge(
                              title: widget.report.status,
                              bgColor: Colors.blue,
                              textColor: Colors.white)
                          : Container(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
