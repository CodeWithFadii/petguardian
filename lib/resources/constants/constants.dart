import 'package:get/get.dart';

import '../../controllers/add_pet_info_controller.dart';
import '../../controllers/dashboard_controller.dart';
import '../widgets/loader.dart';

LoaderController get loaderC => Get.find<LoaderController>();
DashboardController get dashboardC => Get.find<DashboardController>();
AddPetInfoController get addPetInfoC => Get.find<AddPetInfoController>();

const String bodyFont = 'Poppins';
const String headingFont = 'MochiyPopOne';
