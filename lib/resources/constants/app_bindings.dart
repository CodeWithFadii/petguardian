import 'package:get/get.dart';
import 'package:petguardian/controllers/gallery_controller.dart';
import 'package:petguardian/controllers/otp_controller.dart';
import 'package:petguardian/controllers/user_controller.dart';
import '../../controllers/activity_controller.dart';
import '../../controllers/ad_controller.dart';
import '../../controllers/add_pet_info_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/dashboard_controller.dart';
import '../../controllers/feeding_controller.dart';
import '../../controllers/forum_controller.dart';
import '../../controllers/grooming_controller.dart';
import '../../controllers/health_controller.dart';
import '../../controllers/lifecycle_controller.dart';
import '../../controllers/setting_controller.dart';
import '../../controllers/subscription_controller.dart';
import '../utils.dart';
import '../widgets/loader.dart';

class GlobalBinding extends Bindings {
  @override
  void dependencies() {
    Utils().setPortrait();
    Get.put(LifecycleController());
    Get.put(LoaderController());
    Get.put(AdController());
  }
}

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DashboardController());
    Get.put(ForumController());
    Get.put(UserController());
    Get.put(AddPetInfoController());
  }
}

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
    Get.put(OTPController());
  }
}

class GalleryBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GalleryController());
  }
}

class FeedingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FeedingController());
  }
}

class GroomingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GroomingController());
  }
}

class HealthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HealthController());
  }
}

class ActivityBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ActivityController());
  }
}

class ForumBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ForumController());
  }
}

class SettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SettingController());
  }
}

class SubscriptionBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SubscriptionController());
  }
}
