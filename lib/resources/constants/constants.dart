import 'dart:ui';

import 'package:get/get.dart';
import 'package:petguardian/controllers/auth_controller.dart';
import 'package:petguardian/controllers/gallery_controller.dart';
import 'package:petguardian/controllers/otp_controller.dart';
import 'package:petguardian/resources/routes/routes_name.dart';
import 'package:fpdart/fpdart.dart';

import '../../controllers/activity_controller.dart';
import '../../controllers/add_pet_info_controller.dart';
import '../../controllers/dashboard_controller.dart';
import '../../controllers/feeding_controller.dart';
import '../../controllers/grooming_controller.dart';
import '../../controllers/health_controller.dart';
import '../widgets/loader.dart';
import 'app_icons.dart';

LoaderController get loaderC => Get.find<LoaderController>();
DashboardController get dashboardC => Get.find<DashboardController>();
AddPetInfoController get addPetInfoC => Get.find<AddPetInfoController>();
AuthController get authC => Get.find<AuthController>();
GalleryController get galleryC => Get.find<GalleryController>();
FeedingController get feedingC => Get.find<FeedingController>();
GroomingController get groomingC => Get.find<GroomingController>();
HealthController get healthC => Get.find<HealthController>();
ActivityController get activityC => Get.find<ActivityController>();
OTPController get otpC => Get.find<OTPController>();

const String bodyFont = 'Poppins';
const String headingFont = 'MochiyPopOne';

const List<String> homeTextList = ['Settings', 'Feeding', 'Grooming', 'Health', 'Activity', 'Gallery'];
const List<String> settingsTextList = ['Logout', 'Delete Account'];
const List<String> homeIconsList = [
  AppIcons.settings,
  AppIcons.food,
  AppIcons.grooming,
  AppIcons.health,
  AppIcons.activityHome,
  AppIcons.gallery,
];
const List<String> settingsIconsList = [AppIcons.logout, AppIcons.delete];
List<VoidCallback> homeNavigateList = [
  () => Get.toNamed(RoutesName.settingsScreen),
  () => Get.toNamed(RoutesName.feedingScreen),
  () => Get.toNamed(RoutesName.groomingScreen),
  () => Get.toNamed(RoutesName.healthScreen),
  () => Get.toNamed(RoutesName.activityScreen),
  () => Get.toNamed(RoutesName.galleryScreen),
];

enum UserType { email, google, facebook, apple }

class Failure {
  final String message;
  Failure(this.message);
}

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureVoid = FutureEither<void>;
