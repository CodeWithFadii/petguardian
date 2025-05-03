import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:petguardian/resources/routes/routes_name.dart';

import '../../resources/constants/app_images.dart';
import '../../resources/services/storage_service.dart';

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

  void _navigate() async {
    bool isNew = await StorageService.isNewUser();
    if (isNew) {
      Future.delayed(Duration(milliseconds: 1500), () => Get.offAllNamed(RoutesName.onboardingScreen));
    } else if (FirebaseAuth.instance.currentUser == null) {
      Future.delayed(Duration(milliseconds: 1500), () => Get.offAllNamed(RoutesName.welcomeScreen));
    } else {
      Future.delayed(Duration(milliseconds: 1500), () => Get.offAllNamed(RoutesName.dashboard));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [Expanded(child: Center(child: SvgPicture.asset(AppImages.splash)))]),
    );
  }
}
