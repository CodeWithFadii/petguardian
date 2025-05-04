import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;

class PetModel {
  final String? id;
  final String name;
  final String breed;
  final String age;
  final String weight;
  final String notes;
  final String animalType;
  final String imageUrl;
  final String? createdAt;

  PetModel({
    this.id,
    required this.name,
    this.breed = '',
    this.age = '',
    this.weight = '',
    this.notes = '',
    this.createdAt,
    required this.animalType,
    required this.imageUrl,
  });

  factory PetModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final Timestamp? timestamp = data['createdAt'] as Timestamp?;
    return PetModel(
      id: doc.id,
      name: data['name'] ?? '',
      breed: data['breed'] ?? '',
      age: data['age'] ?? '',
      weight: data['weight'] ?? '',
      notes: data['notes'] ?? '',
      animalType: data['animalType'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      createdAt: timestamp != null ? relativeDate(timestamp.toDate()) : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'breed': breed,
      'age': age,
      'weight': weight,
      'notes': notes,
      'animalType': animalType,
      'imageUrl': imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  static String relativeDate(DateTime dateTime) {
    return timeago.format(dateTime);
  }

  PetModel copyWith({
    String? id,
    String? name,
    String? breed,
    String? age,
    String? weight,
    String? notes,
    String? animalType,
    String? imageUrl,
  }) {
    return PetModel(
      id: id ?? this.id,
      name: name ?? this.name,
      breed: breed ?? this.breed,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      notes: notes ?? this.notes,
      animalType: animalType ?? this.animalType,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
