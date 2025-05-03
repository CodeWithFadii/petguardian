import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _keyIsNewUser = 'is_new_user';

  /// Check if user is new
  static Future<bool> isNewUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsNewUser) ?? true; // default is true
  }

  /// Set user as new or not
  static Future<void> setUser(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsNewUser, value);
  }

  /// Optional: Reset status for testing
  static Future<void> resetUserStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyIsNewUser);
  }
}
