import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

class ForumController extends GetxController {
  final RxList<File> _selectedImages = <File>[].obs;
  final RxList<String> _tags = <String>[].obs;

  List<File> get selectedImages => _selectedImages;
  List<String> get tags => _tags;

  void pickImages() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image, allowMultiple: true);

    if (result != null && result.files.isNotEmpty) {
      final newImages = result.files.map((f) => File(f.path!)).toList();
      final totalImages = _selectedImages.length + newImages.length;

      if (totalImages > 3) {
        Get.snackbar(
          'Limit Exceeded',
          'You can only select up to ${3} images. Please select fewer images.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      _selectedImages.addAll(newImages);
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < _selectedImages.length) {
      _selectedImages.removeAt(index);
    }
  }

  void addTag(String tag) {
    if (tag.isNotEmpty) {
      _tags.add(tag);
    }
  }

  void removeTag(int index) {
    if (index >= 0 && index < _tags.length) {
      _tags.removeAt(index);
    }
  }
}
