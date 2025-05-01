import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

import '../resources/constants/constants.dart';
import '../resources/utils.dart';

class OTPController extends GetxController {
  TextEditingController? _otpC;

  // Getters
  TextEditingController? get otpC => _otpC;
  String get currentOTP => _otp.value;
  bool get isOtpTimerRunning => _isTimerRunning.value;
  int get remainingTime => _timeLeft.value;

  // Observables
  final RxString _otp = ''.obs;
  final RxBool _isTimerRunning = false.obs;
  final RxInt _timeLeft = 60.obs;

  Timer? _timer;

  @override
  void onInit() {
    _otpC = TextEditingController();
    super.onInit();
  }

  void generateOTP() {
    _otp.value = (1000 + Random().nextInt(9000)).toString();
  }

  Future<void> sendOTP(context) async {
    loaderC.showLoader();
    generateOTP();

    final smtpServer = gmail('amirsohail200rb@gmail.com', 'qvcl hvuq bgus qtlg');
    final message =
        Message()
          ..from = Address('amirsohail200rb@gmail.com', 'Soapah')
          ..recipients.add(authC.emailC!.text)
          ..subject = 'Soapah'
          ..text = 'Your OTP code is: ${_otp.value}';

    try {
      await send(message, smtpServer);
      Utils.showMessage('OTP sent successfully', isError: false, context: context);
      startTimer();
    } catch (e) {
      Utils.showMessage('Failed to send OTP', context: context);
      debugPrint(e.toString());
    } finally {
      loaderC.hideLoader();
    }
  }

  void startTimer() {
    _timer?.cancel();
    _isTimerRunning.value = true;
    _timeLeft.value = 60;

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timeLeft.value > 0) {
        _timeLeft.value--;
      } else {
        _isTimerRunning.value = false;
        _timer?.cancel();
      }
    });
  }

  Future<void> resendOTP(context) async {
    if (!_isTimerRunning.value) {
      await sendOTP(context);
    }
  }

  bool verifyOTP(String inputOTP) {
    return _otp.value == inputOTP;
  }

  @override
  void dispose() {
    _otpC!.dispose();
    super.dispose();
  }
}
