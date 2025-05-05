import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroomingScheduleModel {
  final String? id;
  final TimeOfDay time;
  final bool isEnabled;
  final List<String> completedPetIds;
  final bool isCompleted;
  final DateTime? createdAt;

  GroomingScheduleModel({
    this.id,
    required this.time,
    this.isEnabled = true,
    this.completedPetIds = const [],
    this.isCompleted = false,
    this.createdAt,
  });

  factory GroomingScheduleModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GroomingScheduleModel(
      id: doc.id,
      time: TimeOfDay(hour: data['hour'] ?? 0, minute: data['minute'] ?? 0),
      isEnabled: data['isEnabled'] ?? true,
      completedPetIds: List<String>.from(data['completedPetIds'] ?? []),
      isCompleted: data['isCompleted'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'hour': time.hour,
      'minute': time.minute,
      'isEnabled': isEnabled,
      'completedPetIds': completedPetIds,
      'isCompleted': isCompleted,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  GroomingScheduleModel copyWith({
    String? id,
    TimeOfDay? time,
    bool? isEnabled,
    List<String>? completedPetIds,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return GroomingScheduleModel(
      id: id ?? this.id,
      time: time ?? this.time,
      isEnabled: isEnabled ?? this.isEnabled,
      completedPetIds: completedPetIds ?? this.completedPetIds,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
