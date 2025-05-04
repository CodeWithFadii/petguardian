import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:petguardian/resources/routes/routes_name.dart';

class LifecycleController extends GetxController with WidgetsBindingObserver {
  final RxBool _stopNavigation = false.obs;

  bool get stopNavigation => _stopNavigation.value;

  set stopNavigation(bool value) => _stopNavigation.value = value;

  @override
  void onInit() {
    WidgetsBinding.instance.addObserver(this);
    super.onInit();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused && !stopNavigation) {
      Future.delayed(const Duration(milliseconds: 100), () {
        Get.offAllNamed(RoutesName.splashScreen);
      });
    }
    if (state == AppLifecycleState.resumed) {
      _stopNavigation.value = false;
    }
  }
}
