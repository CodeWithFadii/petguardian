import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petguardian/controllers/auth_controller.dart';
import 'package:petguardian/controllers/gallery_controller.dart';
import 'package:petguardian/controllers/otp_controller.dart';
import 'package:petguardian/resources/routes/routes_name.dart';
import 'package:fpdart/fpdart.dart';

import '../../controllers/activity_controller.dart';
import '../../controllers/ad_controller.dart';
import '../../controllers/add_pet_info_controller.dart';
import '../../controllers/dashboard_controller.dart';
import '../../controllers/feeding_controller.dart';
import '../../controllers/forum_controller.dart';
import '../../controllers/grooming_controller.dart';
import '../../controllers/health_controller.dart';
import '../../controllers/lifecycle_controller.dart';
import '../../controllers/setting_controller.dart';
import '../../controllers/user_controller.dart';
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
ForumController get forumC => Get.find<ForumController>();
OTPController get otpC => Get.find<OTPController>();
UserController get userC => Get.find<UserController>();
SettingController get settingC => Get.find<SettingController>();
LifecycleController get lifecycleC => Get.find<LifecycleController>();
AdController get adC => Get.find<AdController>();

String get uid => FirebaseAuth.instance.currentUser!.uid;

const String bodyFont = 'Poppins';
const String headingFont = 'MochiyPopOne';

const List<String> homeTextList = [
  'Settings',
  'Feeding',
  'Grooming',
  'Health',
  // , 'Activity'
  'Gallery',
  'My Posts',
];
const List<String> settingsTextList = [
  'Profile', 'Blocked Users', 'Logout',
  // , 'Delete Account'
];
const List<String> homeIconsList = [
  AppIcons.settings,
  AppIcons.food,
  AppIcons.grooming,
  AppIcons.health,

  // AppIcons.activityHome,
  AppIcons.gallery,
  AppIcons.forum,
];
const List<String> settingsIconsList = [
  AppIcons.profile,
  AppIcons.userBlock,
  AppIcons.logout,

  // AppIcons.delete,
];

List<VoidCallback> homeNavigateList = [
  () => Get.toNamed(RoutesName.settingsScreen),
  () => Get.toNamed(RoutesName.feedingScreen),
  () => Get.toNamed(RoutesName.groomingScreen),
  () => Get.toNamed(RoutesName.healthScreen),
  () => Get.toNamed(RoutesName.galleryScreen),
  () => Get.toNamed(RoutesName.myPostsScreen),
];

enum UserType { email, google, facebook, apple }

class Failure {
  final String message;
  Failure(this.message);
}

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureVoid = FutureEither<void>;

String getOTPEmailTemplate(String otp) {
  return '''
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>OTP Email</title>
  <style>
    body {
      font-family: 'Arial', sans-serif;
      margin: 0;
      padding: 0;
      display: flex;
      justify-content: center;
      align-items: center;
      min-height: 100vh;
    }
    .container {
      max-width: 600px;
      margin: 20px;
      background: #ffffff;
      padding: 40px;
      border-radius: 16px;
      box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
      text-align: center;
    }
    .header h1 {
      color: #333333;
      font-size: 28px;
      margin-bottom: 20px;
      font-weight: bold;
    }
    .content {
      margin: 20px 0;
    }
    .otp {
      font-size: 48px;
      font-weight: bold;
      color: #000000;
      margin: 30px 0;
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      animation: fadeIn 2s ease-in-out;
    }
    .footer {
      font-size: 14px;
      color: #777777;
      margin-top: 30px;
    }
    .footer a {
      color: #007BFF;
      text-decoration: none;
    }
    .footer a:hover {
      text-decoration: underline;
    }
    @keyframes fadeIn {
      from { opacity: 0; }
      to { opacity: 1; }
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h1>Your One-Time Password (OTP)</h1>
    </div>
    <div class="content">
      <p>Hello there! 👋</p>
      <p>Please use the following OTP to complete your verification:</p>
      <div class="otp">$otp</div>
      <p>This OTP is valid for <strong>10 minutes</strong>. Do not share it with anyone.</p>
    </div>
    <div class="footer">
      <p>If you did not request this OTP, please ignore this email or <a href="#">contact support</a>.</p>
      <p>Thank you,<br>Your Awesome Team</p>
    </div>
  </div>
</body>
</html>
  ''';
}

Future<List<File>?> showImagePickerBottomSheet({required bool multiple}) async {
  List<File>? selectedFiles;
  await Get.bottomSheet(
    Wrap(
      children: [
        ListTile(
          leading: Icon(Icons.photo_camera),
          title: Text('Camera'),
          onTap: () async {
            lifecycleC.stopNavigation = true;
            final picked = await ImagePicker().pickImage(source: ImageSource.camera);
            if (picked != null) {
              selectedFiles = [File(picked.path)];
            }
            Get.back();
          },
        ),
        ListTile(
          leading: Icon(Icons.photo_library),
          title: Text('Gallery'),
          onTap: () async {
            lifecycleC.stopNavigation = true;
            final result = await FilePicker.platform.pickFiles(allowMultiple: multiple, type: FileType.image);
            if (result != null) {
              final paths = result.paths.map((path) => File(path!));
              selectedFiles = multiple ? paths.toList() : [paths.first];
            }
            Get.back();
          },
        ),
      ],
    ).paddingSymmetric(horizontal: 20, vertical: 10),
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
  );

  return selectedFiles;
}
