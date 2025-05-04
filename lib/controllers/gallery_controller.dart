import 'dart:io';
import 'package:get/get.dart';

import '../resources/constants/constants.dart';

class GalleryController extends GetxController {
  RxList<File> images = <File>[].obs;

  Future<void> pickImages({bool multiple = true}) async {
    images.value = await showImagePickerBottomSheet(multiple: multiple) ?? [];
  }
}
