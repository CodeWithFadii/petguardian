import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petguardian/resources/services/storage_service.dart';

import '../models/gallery_image.dart';
import '../resources/constants/constants.dart';
import '../resources/widgets/loader.dart';

class GalleryController extends GetxController {
  RxList<GalleryImage> images = <GalleryImage>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUploadedImages();
  }

  // Fetch images from Firebase
  Future<void> fetchUploadedImages() async {
    loaderC.showLoader();
    final snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid) // Replace with actual user ID
            .collection('gallery')
            .orderBy('createdAt', descending: true)
            .get();
    images.value = snapshot.docs.map((doc) => GalleryImage(url: doc['imageUrl'], docId: doc.id)).toList();
    loaderC.hideLoader();
  }

  // Pick new images and add them to the top
  Future<void> pickImages({bool multiple = true}) async {
    List<File> newFiles = await showImagePickerBottomSheet(multiple: multiple) ?? [];
    images.insertAll(0, newFiles.map((file) => GalleryImage(file: file)));
  }

  // Upload image to Firebase Storage and get URL
  Future<String> uploadImage(File file) async {
    final url = await StorageService.uploadFileToCloudinary(file.path);

    return url;
  }

  // Save new images to Firebase and refresh list
  Future<void> saveImages() async {
    loaderC.showLoader();
    try {
      List<GalleryImage> newImages = images.where((img) => img.file != null).toList();
      for (var image in newImages) {
        String url = await uploadImage(image.file!);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid) // Replace with actual user ID
            .collection('gallery')
            .add({'imageUrl': url, 'createdAt': FieldValue.serverTimestamp()});
      }
    } finally {
      loaderC.hideLoader();
    }
  }

  // Remove image from list and Firebase if uploaded
  void removeImage(GalleryImage image) {
    if (image.docId != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid) // Replace with actual user ID
          .collection('gallery')
          .doc(image.docId)
          .delete();
    }
    images.remove(image);
  }
}
