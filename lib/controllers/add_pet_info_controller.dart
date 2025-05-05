import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:petguardian/models/pet_model.dart';
import 'package:petguardian/resources/services/storage_service.dart';
import 'package:petguardian/resources/utils.dart';

import '../resources/constants/constants.dart';

class AddPetInfoController extends GetxController {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _breed = TextEditingController();
  final TextEditingController _age = TextEditingController();
  final TextEditingController _weight = TextEditingController();
  final TextEditingController _notes = TextEditingController();
  final RxString _editPetId = ''.obs;
  final RxString _imageUrl = ''.obs;
  final Rx<File?> _selectedImage = Rx<File?>(null);
  final RxString _selectedAnimalType = ''.obs;
  final List<String> _animalTypes = ['Dog', 'Cat', 'Bird', 'Rabbit', 'Fish', 'Other'];

  TextEditingController get name => _name;
  TextEditingController get breed => _breed;
  TextEditingController get age => _age;
  TextEditingController get weight => _weight;
  TextEditingController get notes => _notes;
  String get editPetId => _editPetId.value;
  String get imageUrl => _imageUrl.value;
  File? get selectedImage => _selectedImage.value;
  String get selectedAnimalType => _selectedAnimalType.value;
  List<String> get animalTypes => _animalTypes;

  void setEditPet(PetModel pet) {
    _editPetId.value = pet.id!;
    _name.text = pet.name;
    _breed.text = pet.breed;
    _age.text = pet.age;
    _weight.text = pet.weight;
    _notes.text = pet.notes;
    _selectedAnimalType.value = pet.animalType;
    _imageUrl.value = pet.imageUrl;
    _selectedImage.value = null;
  }

  void setDefault() {
    _editPetId.value = '';
    _imageUrl.value = '';
    _name.clear();
    _breed.clear();
    _age.clear();
    _weight.clear();
    _notes.clear();
    _selectedAnimalType.value = '';
    _selectedImage.value = null;
  }

  void pickImage() async {
    final images = await showImagePickerBottomSheet(multiple: false) ?? [];
    if (images.isNotEmpty) {
      _selectedImage.value = images.first;
    }
  }

  void removeImage() {
    _selectedImage.value = null;
  }

  void selectAnimalType(String type) {
    _selectedAnimalType.value = type;
  }

  Future<void> savePetInfo({required BuildContext context}) async {
    loaderC.showLoader();
    try {
      String? imageUrl;
      if (_selectedImage.value == null) {
        Utils.showMessage('Please select an image', context: context, isError: true);
        loaderC.hideLoader();
        return;
      }
      if (_selectedImage.value != null) {
        imageUrl = await StorageService.uploadFileToCloudinary(_selectedImage.value!.path);
      }
      final petModel = PetModel(
        name: _name.text,
        animalType: _selectedAnimalType.value,
        imageUrl: imageUrl ?? '',
        breed: _breed.text,
        age: _age.text,
        weight: _weight.text,
        notes: _notes.text,
      );
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('pets')
          .add(petModel.toFirestore());
      await Utils.uploadNotificationToFirebase(title: 'Pet Added', body: 'Your Pet added successfully.');
      Utils.showMessage('Pet Added successfully', context: context, isError: false);
      setDefault();
      Get.back();
    } catch (e) {
      log('Error saving pet information: $e');
      Utils.showMessage('Error saving pet information', context: context, isError: true);
    } finally {
      loaderC.hideLoader();
    }
  }

  Future<void> updatePetInfo({required BuildContext context}) async {
    loaderC.showLoader();
    try {
      String? imageUrl;
      if (_selectedImage.value != null) {
        imageUrl = await StorageService.uploadFileToCloudinary(_selectedImage.value!.path);
      }
      final petModel = PetModel(
        name: _name.text,
        animalType: _selectedAnimalType.value,
        imageUrl: imageUrl ?? _imageUrl.value,
        breed: _breed.text,
        age: _age.text,
        weight: _weight.text,
        notes: _notes.text,
      );
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('pets')
          .doc(_editPetId.value)
          .update(petModel.toFirestore());
      await Utils.uploadNotificationToFirebase(title: 'Pet Updated', body: 'Pet Info updated successfully.');
      Utils.showMessage('Pet updated successfully', context: context, isError: false);
      setDefault();
      Get.back();
    } catch (e) {
      log('Error updating pet information: $e');
      Utils.showMessage('Error updating pet information', context: context, isError: true);
    } finally {
      loaderC.hideLoader();
    }
  }

  Future<void> deletePet({required BuildContext context, required String docId}) async {
    loaderC.showLoader();
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).collection('pets').doc(docId).delete();
      Utils.showMessage('Pet deleted successfully', context: context, isError: false);
    } catch (e) {
      log('Error deleting pet: $e');
      Utils.showMessage('Error deleting pet', context: context, isError: true);
    } finally {
      loaderC.hideLoader();
    }
  }

  Stream<List<PetModel>> petsStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('pets')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => PetModel.fromFirestore(doc)).toList());
  }

  Stream<List<PetModel>> userPetsStream({required String userId}) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('pets')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => PetModel.fromFirestore(doc)).toList());
  }

  @override
  void dispose() {
    _name.dispose();
    _breed.dispose();
    _age.dispose();
    _weight.dispose();
    _notes.dispose();
    super.dispose();
  }
}
