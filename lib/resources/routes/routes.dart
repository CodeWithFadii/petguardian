

import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:petguardian/resources/routes/routes_name.dart';

import '../../views/auth/splash_screen.dart';

class Routes {
  static final routes = [
    GetPage(name: RoutesName.splashScreen, page: () => SplashScreen()),

  ];
}
