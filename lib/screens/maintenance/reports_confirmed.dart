import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:water_loss_project/api/user_api.dart';
import 'package:water_loss_project/constant/constant.dart';
import 'package:water_loss_project/constant/global.dart' as global;
import 'package:water_loss_project/data/report.dart';
import 'package:water_loss_project/screens/maintenance/reports_info_screen.dart';
import 'package:water_loss_project/screens/report_info_screen.dart';
import 'package:water_loss_project/widgets/badge.dart';

class ReportsConfirmedScreen extends StatefulWidget {
  const ReportsConfirmedScreen({super.key});

  @override
  State<ReportsConfirmedScreen> createState() => _ReportsConfirmedScreenState();
}

class _ReportsConfirmedScreenState extends State<ReportsConfirmedScreen> {
  late final Stream<QuerySnapshot> _reportsStream;
  final UserApi _userApi = UserApi();

  getUserInfo() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      global.user_email = user.email!;
      getUserData();
      debugPrint(user.email);
    } else {
      debugPrint(null);
    }
    _reportsStream = FirebaseFirestore.instance
        .collection(C_REPORTS)
        .where(REPORT_STATUS, isEqualTo: STATUS_CONFIRMED)
        .orderBy(REPORT_TIMESTAMP, descending: true)
        .snapshots();
  }

  getUserData() async {
    global.user = await _userApi.getUserInfo();
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _reportsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Icon(
                  FontAwesomeIcons.circleExclamation,
                  color: Colors.red,
                ),
                SizedBox(height: 10.0),
                Text(
                  'Something went wrong, Please try again later.',
                  style:
                      TextStyle(fontWeight: FontWeight.w700, color: Colors.red),
                )
              ],
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                SizedBox(
                  height: 50,
                  width: 50,
                  child: LoadingIndicator(
                    indicatorType: Indicator.ballPulseSync,
                    colors: [Colors.red, Colors.amber, Colors.green],
                    strokeWidth: 2,
                  ),
                )
              ],
            ),
          );
        }

        return ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          children: [
            Container(
              padding: const EdgeInsets.all(15.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                gradient: const LinearGradient(
                    begin: FractionalOffset(0.0, 1.0),
                    end: FractionalOffset(2.0, 1.0),
                    stops: [0.0, 10.0],
                    tileMode: TileMode.clamp,
                    colors: [Color(0xff55c073), Color(0xff138756)]),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      FaIcon(
                        FontAwesomeIcons.userAlt,
                        color: Colors.white,
                        size: 15.0,
                      ),
                      SizedBox(width: 6.0),
                      Text(
                        "Maintenance Insights",
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "${snapshot.data!.size}",
                    style: const TextStyle(
                      fontSize: 60.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Text(
                    "Total number of confirmed reports.",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Recently Added",
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                final data = document.data()! as Map<String, dynamic>;
                Report report = Report.fromDocument(data);
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ReportsInfoScreen(report: report)));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    margin: const EdgeInsets.only(top: 15.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: COLOR_LIGHT_GREEN.withOpacity(0.2),
                      border: Border.all(width: 0.1, color: Colors.black45),
                    ),
                    child: Row(
                      children: [
                        Center(
                          child: Container(
                            height: 50.0,
                            margin: const EdgeInsets.symmetric(vertical: 10.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Hero(
                                  tag: report.imageLink,
                                  child: Image.network(report.imageLink)),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 120,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      report.name,
                                      style: const TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      "${report.timestamp}",
                                      style: const TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 15.0),
                                    report.status == STATUS_SUBMITTED
                                        ? CustomBadge(
                                            title: report.status,
                                            bgColor: Colors.orange,
                                            textColor: Colors.white)
                                        : Container(),
                                    report.status == STATUS_CONFIRMED
                                        ? CustomBadge(
                                            title: report.status,
                                            bgColor: Colors.green,
                                            textColor: Colors.white)
                                        : Container(),
                                    report.status == STATUS_REPAIRED
                                        ? CustomBadge(
                                            title: report.status,
                                            bgColor: Colors.blue,
                                            textColor: Colors.white)
                                        : Container(),
                                  ],
                                ),
                              ),
                              const Icon(
                                FontAwesomeIcons.arrowRight,
                                size: 10.0,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );

        // return ListView(
        //   children: snapshot.data!.docs.map((DocumentSnapshot document) {
        //   Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        //     return ListTile(
        //       title: Text(data['full_name']),
        //       subtitle: Text(data['company']),
        //     );
        //   }).toList(),
      },
    );
  }
}
