import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../models/user_model.dart';
import '../repository/auth_repository.dart';
import '../resources/constants/constants.dart';
import '../resources/routes/routes_name.dart';
import '../resources/utils.dart';

class AuthController extends GetxController {
  final _authRepository = AuthRepository.instance;
  final Rx<UserModel?> _user = Rx<UserModel?>(null);

  TextEditingController? _emailC;
  TextEditingController? _nameC;
  TextEditingController? _passwordC;
  TextEditingController? _confirmPasswordC;

  TextEditingController? get emailC => _emailC;
  TextEditingController? get nameC => _nameC;
  TextEditingController? get passwordC => _passwordC;
  TextEditingController? get confirmPasswordC => _confirmPasswordC;

  UserModel? get user => _user.value;

  @override
  void onInit() {
    _emailC = TextEditingController();
    _passwordC = TextEditingController();
    _confirmPasswordC = TextEditingController();
    super.onInit();
  }

  Future<void> continueWithGoogle({required BuildContext context}) async {
    loaderC.showLoader();
    final response = await _authRepository.continueWithGoogle();

    response.fold(
      (error) {
        Utils.showMessage(error.message, context: context, isError: true);
        loaderC.hideLoader();
      },
      (user) {
        _user.value = user;
        Utils.showMessage('Login Successful', context: context, isError: false);
        Get.offAllNamed(RoutesName.dashboard);
        loaderC.hideLoader();
      },
    );
  }

  Future<void> sendPasswordResetEmail({required BuildContext context}) async {
    if (_emailC!.text.trim().isEmpty) {
      Utils.showMessage('Please enter your email', context: context, isError: true);
      return;
    }

    loaderC.showLoader();
    final response = await _authRepository.sendPasswordResetEmail(email: _emailC!.text.trim());

    response.fold(
      (error) => Utils.showMessage(error.message, context: context, isError: true),
      (_) => Utils.showMessage('Password reset email sent', context: context, isError: false),
    );

    loaderC.hideLoader();
  }

  Future<void> signup({required BuildContext context}) async {
    loaderC.showLoader();
    final response = await _authRepository.signup(
      user: UserModel(email: _emailC!.text.trim(), password: _passwordC!.text.trim()),
    );

    response.fold((error) => Utils.showMessage(error.message, context: context, isError: true), (_) async {
      Utils.showMessage('Signup Successful', context: context, isError: false);
      Get.offAllNamed(RoutesName.dashboard);
    });
    loaderC.hideLoader();
  }

  Future<void> login({required BuildContext context}) async {
    loaderC.showLoader();
    final response = await _authRepository.login(
      user: UserModel(email: _emailC!.text.trim(), password: _passwordC!.text.trim()),
    );

    response.fold((error) => Utils.showMessage(error.message, context: context, isError: true), (user) {
      _user.value = user;
      Utils.showMessage('Login Successful', context: context, isError: false);
      Get.offAllNamed(RoutesName.dashboard);
    });

    loaderC.hideLoader();
  }

  Future<void> logout() async {
    loaderC.showLoader();
    await _authRepository.logout();
    _user.value = null;
    loaderC.hideLoader();
  }

  @override
  void dispose() {
    _nameC!.dispose();
    _emailC!.dispose();
    _passwordC!.dispose();
    _confirmPasswordC!.dispose();
    super.dispose();
  }
}
