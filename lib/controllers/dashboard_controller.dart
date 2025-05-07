import 'package:get/get.dart';
import 'package:petguardian/resources/constants/constants.dart';

class DashboardController extends GetxController {
  final RxInt _selectedIndex = 0.obs;

  int get selectedIndex => _selectedIndex.value;

  set selectedIndex(int value) => _selectedIndex.value = value;

  @override
  void onInit() {
    adC.initAdMob();
    super.onInit();
  }
}
