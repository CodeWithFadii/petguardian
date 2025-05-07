import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FeedingScheduleModel {
  final String? id;
  final TimeOfDay time;
  final bool isEnabled;
  final String? createdAt;
  final List<String> completedPetIds;
  final bool isCompleted;

  FeedingScheduleModel({
    this.id,
    required this.time,
    this.isEnabled = true,
    this.createdAt,
    this.completedPetIds = const [],
    this.isCompleted = false,
  });

  factory FeedingScheduleModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final Timestamp? timestamp = data['createdAt'] as Timestamp?;
    return FeedingScheduleModel(
      id: doc.id,
      time: TimeOfDay(hour: data['hour'] ?? 0, minute: data['minute'] ?? 0),
      isEnabled: data['isEnabled'] ?? true,
      createdAt: timestamp?.toDate().toIso8601String(),
      completedPetIds: List<String>.from(data['completedPetIds'] ?? []),
      isCompleted: data['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'hour': time.hour,
      'minute': time.minute,
      'isEnabled': isEnabled,
      'createdAt': FieldValue.serverTimestamp(),
      'completedPetIds': completedPetIds,
      'isCompleted': isCompleted,
    };
  }

  FeedingScheduleModel copyWith({
    String? id,
    TimeOfDay? time,
    bool? isEnabled,
    String? createdAt,
    List<String>? completedPetIds,
    bool? isCompleted,
  }) {
    return FeedingScheduleModel(
      id: id ?? this.id,
      time: time ?? this.time,
      isEnabled: isEnabled ?? this.isEnabled,
      createdAt: createdAt ?? this.createdAt,
      completedPetIds: completedPetIds ?? this.completedPetIds,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
