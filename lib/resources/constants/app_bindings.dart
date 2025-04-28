import 'package:get/get.dart';
import '../utils.dart';
import '../widgets/loader.dart';

class GlobalBinding extends Bindings {
  @override
  void dependencies() {
    Utils().setPortrait();
    Get.put(LoaderController());
  }
}
