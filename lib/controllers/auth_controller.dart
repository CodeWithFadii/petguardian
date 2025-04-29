import 'package:get/get.dart';

class AuthController extends GetxController {
  final RxBool _privacyChecked = false.obs;

  bool get privacyChecked => _privacyChecked.value;

  void togglePrivacy() {
    _privacyChecked.value = !_privacyChecked.value;
  }
}
