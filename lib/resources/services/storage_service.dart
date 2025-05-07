import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
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

  static Future<String> uploadFileToCloudinary(String filePath) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.cloudinary.com/v1_1/duhqpgtjc/upload'),
      );
      request.fields['api_key'] = '184733417991914';
      request.fields['api_secret'] = 'nA1eoy8qy9A0dnXsD2_aSwWjglc';
      request.fields['upload_preset'] = 'petguardian';
      request.files.add(await http.MultipartFile.fromPath('file', filePath));
      http.StreamedResponse streamedResponse = await request.send();
      http.Response response = await streamedResponse.stream.bytesToString().then((responseBody) {
        return http.Response(responseBody, streamedResponse.statusCode, headers: streamedResponse.headers);
      });
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        String uploadedUrl = jsonResponse['secure_url'];

        log('File uploaded successfully to Cloudinary: $uploadedUrl');
        return uploadedUrl;
      } else {
        log('Failed to upload file to Cloudinary. Status code: ${response.statusCode}');
        return '';
      }
    } catch (e) {
      return '';
    }
  }
}
