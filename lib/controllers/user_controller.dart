import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:petguardian/resources/constants/constants.dart';
import 'package:petguardian/resources/utils.dart';

import '../models/user_model.dart';

class UserController extends GetxController {
  final Rx<UserModel?> _user = Rx<UserModel?>(null);

  UserModel? get user => _user.value;

  set user(UserModel? value) => _user.value = value;

  Future<void> getCurrentUserData() async {
    loaderC.showLoader();
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      _user.value = UserModel.fromFirestore(doc);
      log('User data: ${_user.value.toString()}');
    } catch (e) {
      log('Error getting user data ${e.toString()}');
    } finally {
      loaderC.hideLoader();
    }
  }

  Future<List<DocumentSnapshot>> fetchBlockedUsers(List<dynamic> ids) async {
    return Future.wait(ids.map((id) => FirebaseFirestore.instance.collection('users').doc(id).get()));
  }

  Future<void> updateBlocks({required String userId, required BuildContext context}) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'blocks': FieldValue.arrayUnion([userId]),
      });
      final updatedBlocks = List<String>.from(_user.value!.blocks)..add(userId);
      _user.value = _user.value?.copyWith(blocks: updatedBlocks);
      log('User data: ${_user.value.toString()}');
      Utils.showMessage('User blocked successfully', context: context, isError: false);
      Get.back();
    } catch (e) {
      log('Error updating user blocks ${e.toString()}');
    }
  }

  @override
  void onInit() {
    getCurrentUserData();
    super.onInit();
  }
}
