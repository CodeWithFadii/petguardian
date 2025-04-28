import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:petguardian/resources/routes/routes_name.dart';

import '../../resources/constants/app_images.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _navigate();
    super.initState();
  }

  void _navigate() =>
      Future.delayed(Duration(milliseconds: 1500), () => Get.offAllNamed(RoutesName.onboardingScreen));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [Expanded(child: Center(child: SvgPicture.asset(AppImages.splash)))]),
    );
  }
}
