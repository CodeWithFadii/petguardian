import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petguardian/models/user_model.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'dart:developer';

class CommentModel {
  final String? id;
  final String postId;
  final String userId;
  final String commentText;
  final String? createdAt;
  final UserModel? user;

  CommentModel({
    this.id,
    required this.postId,
    required this.userId,
    required this.commentText,
    this.createdAt,
    this.user,
  });

  static Future<CommentModel> fromFirestoreWithUser(DocumentSnapshot doc, String postId) async {
    final data = doc.data() as Map<String, dynamic>;
    final Timestamp? timestamp = data['createdAt'] as Timestamp?;
    UserModel? user;
    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(data['userId']).get();
      user = UserModel.fromFirestore(userDoc);
    } catch (e) {
      log('Error fetching user data: $e');
    }
    return CommentModel(
      id: doc.id,
      postId: postId,
      userId: data['userId'] ?? '',
      commentText: data['commentText'] ?? '',
      createdAt: timestamp != null ? timeago.format(timestamp.toDate()) : null,
      user: user,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'postId': postId,
      'userId': userId,
      'commentText': commentText,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
