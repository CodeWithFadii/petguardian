import 'package:get/get.dart';
import 'package:petguardian/resources/routes/routes_name.dart';
import 'package:petguardian/views/settings/blocked_users_screen.dart';

class AppRoutes {
  static final routes = [
    GetPage(
      name: RoutesName.blockedUsersScreen,
      page: () => const BlockedUsersScreen(),
    ),
  ];
}
