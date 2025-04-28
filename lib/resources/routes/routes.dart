import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:petguardian/resources/constants/app_bindings.dart';
import 'package:petguardian/resources/routes/routes_name.dart';
import 'package:petguardian/views/activity/add_pet_screen.dart';
import 'package:petguardian/views/dashboard/dashboard.dart';
import 'package:petguardian/views/home/home_screen.dart';

import '../../views/onboarding/onboarding_screen.dart';
import '../../views/splash/splash_screen.dart';

class Routes {
  static final routes = [
    GetPage(name: RoutesName.splashScreen, page: () => SplashScreen()),
    GetPage(name: RoutesName.onboardingScreen, page: () => OnboardingScreen()),
    GetPage(name: RoutesName.dashboard, page: () => Dashboard(), binding: DashboardBinding()),
    GetPage(name: RoutesName.homeScreen, page: () => HomeScreen()),
    GetPage(name: RoutesName.addPetScreen, page: () => AddPetScreen(), binding: AddPetInfoBinding()),
  ];
}
