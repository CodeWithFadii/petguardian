import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:petguardian/resources/constants/constants.dart';

import '../models/user_model.dart';

class UserController extends GetxController {
  final Rx<UserModel?> _user = Rx<UserModel?>(null);

  UserModel? get user => _user.value;

  set user(UserModel? value) => _user.value = value;

  Future<void> getCurrentUserData() async {
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      _user.value = UserModel.fromFirestore(doc);
      log('User data: ${_user.value.toString()}');
    } catch (e) {
      log('Error getting user data ${e.toString()}');
    }
  }

  @override
  void onInit() {
    getCurrentUserData();
    super.onInit();
  }
}
