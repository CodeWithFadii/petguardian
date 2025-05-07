import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:petguardian/resources/services/storage_service.dart';
import 'package:petguardian/resources/utils.dart';

import '../resources/constants/constants.dart';

class SettingController extends GetxController {
  TextEditingController? _nameC;
  final RxList<File> _selectedImages = <File>[].obs;

  TextEditingController? get nameC => _nameC;
  File? get selectedImage => _selectedImages.isNotEmpty ? _selectedImages.first : null;

  Future<void> pickImage() async {
    final images = await showImagePickerBottomSheet(multiple: false) ?? [];
    if (images.isNotEmpty) {
      _selectedImages.value = images;
    }
  }

  Future<void> updateProfile({required BuildContext context}) async {
    loaderC.showLoader();

    try {
      String imageUrl = '';
      if (_selectedImages.isNotEmpty) {
        imageUrl = await StorageService.uploadFileToCloudinary(_selectedImages.first.path);
      }
      final userModel = userC.user?.copyWith(
        name: nameC!.text.trim(),
        img: imageUrl.isNotEmpty ? imageUrl : userC.user!.img,
      );
      userC.user = userModel;
      await FirebaseFirestore.instance.collection('users').doc(uid).update(userModel!.toFirestore());
      await Utils.uploadNotificationToFirebase(
        title: 'Profile Updated',
        body: 'Your profile updated successfully.',
      );
      Utils.showMessage('Profile updated successfully', context: context, isError: false);
    } catch (e) {
      Utils.showMessage('Unable to update profile please try again', context: context, isError: true);
      log('Error updating profile: $e');
    } finally {
      Get.back();
      _selectedImages.clear();
      loaderC.hideLoader();
    }
  }

  @override
  void onInit() {
    _nameC = TextEditingController(text: userC.user?.name);
    super.onInit();
  }

  @override
  void dispose() {
    _nameC?.dispose();
    super.dispose();
  }
}
