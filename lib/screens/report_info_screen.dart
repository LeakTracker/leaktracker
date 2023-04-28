import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 300.0,
              child: Hero(
                tag: widget.report.imageLink,
                child: Image.network(
                  widget.report.imageLink,
                  fit: BoxFit.cover,
                ),
              )),
          const SizedBox(height: 20.0),
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
