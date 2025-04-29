import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AddPetInfoController extends GetxController {
  Rx<TextEditingController>? _name;
  Rx<TextEditingController>? _breed;
  Rx<TextEditingController>? _age;
  Rx<TextEditingController>? _weight;
  Rx<TextEditingController>? _notes;
  final RxList<File> _selectedImages = <File>[].obs;
  final RxString _selectedAnimalType = ''.obs;
  final List<String> _animalTypes = ['Dog', 'Cat', 'Bird', 'Rabbit', 'Fish', 'Other'];

  TextEditingController? get name => _name?.value;
  TextEditingController? get breed => _breed?.value;
  TextEditingController? get age => _age?.value;
  TextEditingController? get weight => _weight?.value;
  TextEditingController? get notes => _notes?.value;
  List<File> get selectedImages => _selectedImages;
  String get selectedAnimalType => _selectedAnimalType.value;
  List<String> get animalTypes => _animalTypes;

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

  void selectAnimalType(String type) {
    _selectedAnimalType.value = type;
  }

  @override
  void onInit() {
    _name = Rx<TextEditingController>(TextEditingController());
    _breed = Rx<TextEditingController>(TextEditingController());
    _age = Rx<TextEditingController>(TextEditingController());
    _weight = Rx<TextEditingController>(TextEditingController());
    _notes = Rx<TextEditingController>(TextEditingController());
    super.onInit();
  }

  @override
  void dispose() {
    _name?.value.dispose();
    _breed?.value.dispose();
    _age?.value.dispose();
    _weight?.value.dispose();
    _notes?.value.dispose();
    super.dispose();
  }
}
