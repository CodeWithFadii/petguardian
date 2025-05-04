import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String? createdAt;
  final bool isRead;

  NotificationModel({
    required this.title,
    required this.body,
    this.createdAt,
    this.isRead = false,
    this.id = '',
  });

  factory NotificationModel.fromMap(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final Timestamp? timestamp = data['createdAt'] as Timestamp?;
    return NotificationModel(
      id: doc.id,
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      createdAt: timestamp != null ? relativeDate(timestamp.toDate()) : null,
      isRead: data['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {'title': title, 'body': body, 'isRead': isRead, 'createdAt': FieldValue.serverTimestamp()};
  }

  static String relativeDate(DateTime dateTime) {
    return timeago.format(dateTime);
  }
}
