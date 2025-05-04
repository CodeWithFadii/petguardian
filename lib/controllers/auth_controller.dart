import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../models/user_model.dart';
import '../repository/auth_repository.dart';
import '../resources/constants/constants.dart';
import '../resources/routes/routes_name.dart';
import '../resources/utils.dart';

class AuthController extends GetxController {
  final _authRepository = AuthRepository.instance;

  TextEditingController? _signUpEmailC;
  TextEditingController? _signUpNameC;
  TextEditingController? _signUpPasswordC;
  TextEditingController? _loginEmailC;
  TextEditingController? _loginPasswordC;

  TextEditingController? get signUpNameC => _signUpNameC;
  TextEditingController? get signUpEmailC => _signUpEmailC;
  TextEditingController? get signUpPasswordC => _signUpPasswordC;
  TextEditingController? get loginEmailC => _loginEmailC;
  TextEditingController? get loginPasswordC => _loginPasswordC;

  @override
  void onInit() {
    _signUpEmailC = TextEditingController();
    _signUpNameC = TextEditingController();
    _signUpPasswordC = TextEditingController();
    _loginEmailC = TextEditingController();
    _loginPasswordC = TextEditingController();
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
        Utils.showMessage('Login Successful', context: context, isError: false);
        Get.offAllNamed(RoutesName.dashboard);
        loaderC.hideLoader();
      },
    );
  }

  Future<void> sendPasswordResetEmail({required BuildContext context}) async {
    if (_loginEmailC!.text.trim().isEmpty) {
      Utils.showMessage('Please enter your email', context: context, isError: true);
      return;
    }

    loaderC.showLoader();
    final response = await _authRepository.sendPasswordResetEmail(email: _loginEmailC!.text.trim());

    response.fold((error) => Utils.showMessage(error.message, context: context, isError: true), (_) async {
      await Utils.uploadNotificationToFirebase(
        title: 'Password Reset',
        body: 'Password reset email sent successfully.',
      );
      Utils.showMessage('Password reset email sent', context: context, isError: false);
    });

    loaderC.hideLoader();
  }

  Future<void> signup({required BuildContext context}) async {
    loaderC.showLoader();
    final response = await _authRepository.signup(
      user: UserModel(
        name: signUpNameC!.text.trim(),
        email: _signUpEmailC!.text.trim(),
        password: _signUpPasswordC!.text.trim(),
      ),
    );

    response.fold((error) => Utils.showMessage(error.message, context: context, isError: true), (_) async {
      await Utils.uploadNotificationToFirebase(
        title: 'Account Created',
        body: 'Your account created successfully.',
      );
      Utils.showMessage('Signup Successful', context: context, isError: false);
      Get.offAllNamed(RoutesName.dashboard);
    });
    loaderC.hideLoader();
  }

  Future<void> checkEmailExist({required BuildContext context}) async {
    loaderC.showLoader();
    final response = await _authRepository.checkEmailExist(email: _signUpEmailC!.text);

    response.fold(
      (error) {
        Utils.showMessage(error.message, context: context, isError: true);
      },
      (isEmailExist) async {
        if (isEmailExist) {
          Utils.showMessage('Email already exist', context: context, isError: true);
          loaderC.hideLoader();
          return;
        } else {
          await otpC.sendOTP(context);
          loaderC.hideLoader();
          Get.toNamed(RoutesName.verifyOtpScreen);
        }
      },
    );
  }

  Future<void> login({required BuildContext context}) async {
    loaderC.showLoader();
    final response = await _authRepository.login(
      user: UserModel(email: _loginEmailC!.text.trim(), password: _loginPasswordC!.text.trim()),
    );

    response.fold((error) => Utils.showMessage(error.message, context: context, isError: true), (user) async {
      await Utils.uploadNotificationToFirebase(
        title: 'Account Logged in',
        body: 'Your account logged in successfully.',
      );
      Utils.showMessage('Login Successful', context: context, isError: false);
      Get.offAllNamed(RoutesName.dashboard);
    });

    loaderC.hideLoader();
  }

  Future<void> logout() async {
    loaderC.showLoader();
    await _authRepository.logout();
    loaderC.hideLoader();
  }

  @override
  void dispose() {
    _signUpEmailC!.dispose();
    _signUpNameC!.dispose();
    _signUpPasswordC!.dispose();
    _loginEmailC!.dispose();
    _loginPasswordC!.dispose();
    super.dispose();
  }
}
