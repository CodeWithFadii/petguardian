import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petguardian/resources/constants/app_bindings.dart';
import 'package:petguardian/resources/routes/routes.dart';
import 'package:petguardian/resources/routes/routes_name.dart';
import 'package:petguardian/resources/theme/app_theme.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
