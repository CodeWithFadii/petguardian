import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petguardian/resources/constants/app_bindings.dart';
import 'package:petguardian/resources/routes/routes.dart';
import 'package:petguardian/resources/routes/routes_name.dart';
import 'package:petguardian/resources/theme/app_theme.dart';
import 'package:sizer/sizer.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
