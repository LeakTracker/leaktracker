import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:water_loss_project/constant/constant.dart';
import 'package:water_loss_project/screens/create_report.dart';
import 'package:water_loss_project/screens/dashboard_screen.dart';

class HomeMaintenanceScreen extends StatefulWidget {
  const HomeMaintenanceScreen({super.key});

  @override
  State<HomeMaintenanceScreen> createState() => HomeMaintenanceScreenState();
}

class HomeMaintenanceScreenState extends State<HomeMaintenanceScreen> {
  int _selectedIndex = 0;

  /// Tab navigation
  Widget _showCurrentNavBar() {
    List<Widget> options = <Widget>[
      const DashboardScreen(),
      const ReportsScreen()
    ];

    return options.elementAt(_selectedIndex);
  }

  /// Update selected tab
  void _onTappedNavBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          elevation: 0.5,
          currentIndex: _selectedIndex,
          backgroundColor: Colors.white,
          onTap: _onTappedNavBar,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedItemColor: COLOR_GREEN,
          unselectedItemColor: Colors.black38,
          // unselectedItemColor: _selectedIndex == 3
          //     ? Colors.white
          //     : Color.fromARGB(255, 145, 144, 144),
          // selectedItemColor: Color(0xfff04c76),
          items: const [
            BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.chartSimple,
                size: 18.0,
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.listCheck,
                size: 18.0,
              ),
              label: "",
            ),
          ]),
      body: _showCurrentNavBar(),
    );
  }
}
