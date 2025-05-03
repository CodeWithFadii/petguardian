import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:petguardian/resources/constants/app_bindings.dart';
import 'package:petguardian/resources/routes/routes_name.dart';
import 'package:petguardian/views/auth/login_screen.dart';
import 'package:petguardian/views/auth/signup_screen.dart';
import 'package:petguardian/views/auth/verify_otp_screen.dart';
import 'package:petguardian/views/dashboard/dashboard.dart';
import 'package:petguardian/views/forum/my_posts_screen.dart';
import 'package:petguardian/views/home/home_screen.dart';
import 'package:petguardian/views/my_pets/edit_pet_screen.dart';

import '../../controllers/forum_controller.dart';
import '../../views/auth/welcome_screen.dart';
import '../../views/forum/add_post_screen.dart';
import '../../views/forum/edit_post_screen.dart';
import '../../views/forum/forum_screen.dart';
import '../../views/forum/other_user_profile.dart';
import '../../views/home/activity_screen.dart';
import '../../views/home/feeding_screen.dart';
import '../../views/home/gallery_screen.dart';
import '../../views/home/grooming_screen.dart';
import '../../views/home/health_screen.dart';
import '../../views/home/profile_screen.dart';
import '../../views/home/settings_screen.dart';
import '../../views/my_pets/add_pet_screen.dart';
import '../../views/my_pets/pet_detail_screen.dart';
import '../../views/onboarding/onboarding_screen.dart';
import '../../views/splash/splash_screen.dart';

class Routes {
  static final routes = [
    GetPage(name: RoutesName.splashScreen, page: () => SplashScreen()),
    GetPage(name: RoutesName.onboardingScreen, page: () => OnboardingScreen()),
    GetPage(name: RoutesName.dashboard, page: () => Dashboard(), binding: DashboardBinding()),
    GetPage(name: RoutesName.homeScreen, page: () => HomeScreen()),
    GetPage(name: RoutesName.addPetScreen, page: () => AddPetScreen(), binding: AddPetInfoBinding()),
    GetPage(name: RoutesName.editPetScreen, page: () => EditPetScreen(), binding: AddPetInfoBinding()),
    GetPage(name: RoutesName.signupScreen, page: () => SignupScreen()),
    GetPage(name: RoutesName.loginScreen, page: () => LoginScreen()),
    GetPage(name: RoutesName.verifyOtpScreen, page: () => VerifyOtpScreen()),
    GetPage(name: RoutesName.welcomeScreen, page: () => WelcomeScreen(), binding: AuthBinding()),
    GetPage(name: RoutesName.settingsScreen, page: () => SettingsScreen()),
    GetPage(name: RoutesName.groomingScreen, page: () => GroomingScreen(), binding: GroomingBinding()),
    GetPage(name: RoutesName.galleryScreen, page: () => GalleryScreen(), binding: GalleryBinding()),
    GetPage(name: RoutesName.feedingScreen, page: () => FeedingScreen(), binding: FeedingBinding()),
    GetPage(name: RoutesName.healthScreen, page: () => HealthScreen(), binding: HealthBinding()),
    GetPage(name: RoutesName.activityScreen, page: () => ActivityScreen(), binding: ActivityBinding()),
    GetPage(name: RoutesName.forumScreen, page: () => ForumScreen()),
    GetPage(name: RoutesName.myPostsScreen, page: () => MyPostsScreen()),
    GetPage(name: RoutesName.profileScreen, page: () => ProfileScreen()),
    GetPage(name: RoutesName.otherUserProfile, page: () => OtherUserProfile()),
    GetPage(name: RoutesName.petDetailScreen, page: () => PetDetailScreen()),
    GetPage(name: RoutesName.addPostScreen, page: () => AddPostScreen(), binding: ForumBinding()),
    GetPage(name: RoutesName.editPostScreen, page: () => EditPostScreen(), binding: ForumBinding()),
  ];
}
