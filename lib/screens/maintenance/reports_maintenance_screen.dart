import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:water_loss_project/api/user_api.dart';
import 'package:water_loss_project/constant/constant.dart';
import 'package:water_loss_project/screens/maintenance/reports_all.dart';
import 'package:water_loss_project/screens/maintenance/reports_confirmed.dart';
import 'package:water_loss_project/screens/maintenance/reports_repaired.dart';
import 'package:water_loss_project/screens/maintenance/reports_submitted.dart';
import 'package:water_loss_project/screens/settings_screen.dart';
import 'package:water_loss_project/constant/global.dart' as global;

class ReportsMaintenanceScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ReportsMaintenanceScreenState();
  }
}

class _ReportsMaintenanceScreenState extends State<ReportsMaintenanceScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late final Stream<QuerySnapshot> _reportsStreamAll;
  late final Stream<QuerySnapshot> _reportsStreamSubmitted;
  late final Stream<QuerySnapshot> _reportsStreamConfirmed;
  late final Stream<QuerySnapshot> _reportsStreamRepaired;
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
    _reportsStreamAll = FirebaseFirestore.instance
        .collection(C_REPORTS)
        .orderBy(REPORT_TIMESTAMP, descending: true)
        .snapshots();
    _reportsStreamSubmitted = FirebaseFirestore.instance
        .collection(C_REPORTS)
        .orderBy(REPORT_TIMESTAMP, descending: true)
        .snapshots();

    _reportsStreamConfirmed = FirebaseFirestore.instance
        .collection(C_REPORTS)
        .orderBy(REPORT_TIMESTAMP, descending: true)
        .snapshots();

    _reportsStreamRepaired = FirebaseFirestore.instance
        .collection(C_REPORTS)
        .orderBy(REPORT_TIMESTAMP, descending: true)
        .snapshots();
  }

  getUserData() async {
    global.user = await _userApi.getUserInfo();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _tabController.animateTo(2);
  }

  static const List<Tab> _tabs = [
    Tab(child: Text('All')),
    Tab(text: 'Submitted'),
    Tab(text: 'Confirmed'),
    Tab(text: 'Repaired'),
  ];

  static const List<Widget> _views = [
    ReportsAllScreen(),
    ReportsSubmittedScreen(),
    ReportsConfirmedScreen(),
    ReportsRepairedScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.grey,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        fontFamily: 'Quicksand',
      ),
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            bottom: TabBar(
              padding: const EdgeInsets.all(0),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black26,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              overlayColor:
                  MaterialStateProperty.all<Color>(Colors.transparent),
              indicatorColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding: const EdgeInsets.all(5),
              // indicator: BoxDecoration(
              //   border: Border.all(color: Colors.red),
              //   borderRadius: BorderRadius.circular(10),
              //   color: Colors.pinkAccent,
              // ),
              isScrollable: true,
              physics: BouncingScrollPhysics(),
              onTap: (int index) {
                print('Tab $index is tapped');
              },
              enableFeedback: false,
              // Uncomment the line below and remove DefaultTabController if you want to use a custom TabController
              // controller: _tabController,
              tabs: _tabs,
            ),
            title: const Text('Reports'),
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
                    size: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          body: const TabBarView(
            physics: BouncingScrollPhysics(),
            // Uncomment the line below and remove DefaultTabController if you want to use a custom TabController
            // controller: _tabController,
            children: _views,
          ),
        ),
      ),
    );
  }
}
