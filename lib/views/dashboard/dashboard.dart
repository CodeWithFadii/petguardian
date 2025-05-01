import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petguardian/views/forum/forum_screen.dart';
import 'package:petguardian/views/home/home_screen.dart';
import 'package:petguardian/views/my_pets/my_pets_screen.dart';

import '../../resources/constants/constants.dart';
import '../reminders/reminder_screen.dart';
import 'components/dashboard_navbar.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Obx(() {
              return [HomeScreen(), MyPetsScreen(), ForumScreen(), ReminderScreen()][dashboardC
                  .selectedIndex];
            }),
            DashboardNavbar(),
          ],
        ),
      ),
    );
  }
}
