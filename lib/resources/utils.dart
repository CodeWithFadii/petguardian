import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../resources/widgets/icon_snackbar.dart';

class Utils {
  // Private constructor
  Utils._privateConstructor();

  // The single instance
  static final Utils _instance = Utils._privateConstructor();

  // Factory constructor always returns the same instance
  factory Utils() {
    return _instance;
  }

  static bool _isSnackbarActive = false;

  static void showMessage(String text, {bool isError = false, required BuildContext context}) {
    if (!context.mounted || _isSnackbarActive) return;

    _isSnackbarActive = true;

    IconSnackBar.show(
      context,
      duration: Duration(milliseconds: 1200),
      snackBarType: isError ? SnackBarType.fail : SnackBarType.success,
      label: text,
      maxLines: 2,
    );

    Future.delayed(Duration(milliseconds: 1300), () {
      _isSnackbarActive = false;
    });
  }

  Color withOpacity({required Color color, required double opacity}) {
    return color.withAlpha((opacity * 255).toInt());
  }

  void changeStatusBarColor() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  void setPortrait() {
    changeStatusBarColor();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  static Future<String> selectDate(BuildContext context, {DateTime? initialPickedDate}) async {
    final DateTime now = DateTime.now();
    final DateTime lastDate = DateTime(now.year, now.month, now.day);

    // Ensure initialDate is not after lastDate
    DateTime initialDate =
        initialPickedDate != null && initialPickedDate.isBefore(lastDate) ? initialPickedDate : lastDate;

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1950),
      lastDate: lastDate,
    );

    if (picked != null) {
      return formatDate(picked);
    }
    return '';
  }

  static String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('MM/dd/yyyy');
    return formatter.format(date);
  }

  static Color getColorWithOpacity({required Color color, required double opacity}) {
    return color.withAlpha((opacity * 255).toInt());
  }
}
