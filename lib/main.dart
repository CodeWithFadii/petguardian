import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:petguardian/resources/constants/app_bindings.dart';
import 'package:petguardian/resources/routes/routes.dart';
import 'package:petguardian/resources/routes/routes_name.dart';
import 'package:petguardian/resources/services/notification_service.dart';
import 'package:petguardian/resources/theme/app_theme.dart';
import 'package:sizer/sizer.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService().init();
  final bool available = await InAppPurchase.instance.isAvailable();
  log("In-App Purchase Available: $available");
  MobileAds.instance.initialize();
  RequestConfiguration requestConfiguration = RequestConfiguration(
    testDeviceIds: ['F97BCE9EF4C89A087E58BB0E19ED3C19'],
  );
  MobileAds.instance.updateRequestConfiguration(requestConfiguration);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (buildContext, orientation, screenType) {
        return GetMaterialApp(
          initialBinding: GlobalBinding(),
          title: 'Pet Guardian',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.theme,
          initialRoute: RoutesName.splashScreen,
          getPages: Routes.routes,
        );
      },
    );
  }
}
