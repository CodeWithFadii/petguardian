import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:petguardian/resources/routes/routes_name.dart';

import '../../models/user_model.dart';
import '../../resources/constants/app_images.dart';
import '../../resources/constants/constants.dart';
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

  Future<UserModel> _returnUserData(String uid) async {
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      log('User document does not exist for UID: $uid');
    } catch (e) {
      log('Error getting user data: $e');
    }
    return UserModel();
  }

  Future<void> _navigate() async {
    bool isNew = await StorageService.isNewUser();
    if (isNew) {
      Future.delayed(Duration(milliseconds: 1500), () => Get.offAllNamed(RoutesName.onboardingScreen));
    } else if (FirebaseAuth.instance.currentUser == null) {
      Future.delayed(Duration(milliseconds: 1500), () => Get.offAllNamed(RoutesName.welcomeScreen));
    } else {
      final user = FirebaseAuth.instance.currentUser!;
      final userData = await _returnUserData(user.uid);

      // Check if subscription has expired
      bool isPaid = userData.isPaid ?? false;
      if (isPaid && userData.planEndDate != null) {
        if (userData.planEndDate!.isBefore(DateTime.now())) {
          // Subscription has expired
          isPaid = false;
          try {
            // Update Firestore
            await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
              'isPaid': false,
              'planEndDate': '', // Optional: Clear planEndDate
            });

            log('Subscription expired for user ${user.uid}. Updated isPaid to false.');
          } catch (e) {
            log('Error updating expired subscription: $e');
          }
        }
      }
      adC.isPaid = isPaid;
      // Navigate to dashboard
      Future.delayed(Duration(milliseconds: 500), () => Get.offAllNamed(RoutesName.dashboard));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [Expanded(child: Center(child: SvgPicture.asset(AppImages.splash)))]),
    );
  }
}
