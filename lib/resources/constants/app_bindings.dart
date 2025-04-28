import 'package:get/get.dart';
import '../../controllers/add_pet_info_controller.dart';
import '../../controllers/dashboard_controller.dart';
import '../utils.dart';
import '../widgets/loader.dart';

class GlobalBinding extends Bindings {
  @override
  void dependencies() {
    Utils().setPortrait();
    Get.put(LoaderController());
  }
}

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DashboardController());
  }
}

class AddPetInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AddPetInfoController());
  }
}
