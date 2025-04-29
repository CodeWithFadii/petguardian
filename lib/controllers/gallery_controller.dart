import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class GalleryController extends GetxController {
  RxList<File> images = <File>[].obs;

  Future<void> pickImages() async {
    Get.bottomSheet(
      Wrap(
        children: [
          ListTile(
            leading: Icon(Icons.photo_camera),
            title: Text('Camera'),
            onTap: () async {
              final picked = await ImagePicker().pickImage(source: ImageSource.camera);
              if (picked != null) images.add(File(picked.path));
              Get.back();
            },
          ),
          ListTile(
            leading: Icon(Icons.photo_library),
            title: Text('Gallery'),
            onTap: () async {
              final result = await FilePicker.platform.pickFiles(allowMultiple: true, type: FileType.image);
              if (result != null) {
                final paths = result.paths.map((path) => File(path!));
                for (var e in paths) {
                  images.add(e);
                }
              }
              Get.back();
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    );
  }
}
