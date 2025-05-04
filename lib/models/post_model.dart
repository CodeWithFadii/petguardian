import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petguardian/models/user_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostModel {
  final String? id;
  final String postDetail;
  final UserModel? owner;
  final int? commentsCount;
  final String ownerId;
  final String imageUrl;
  final List<String> tags;
  final String? createdAt;
  List<String> likes = [];

  PostModel({
    this.id,
    required this.postDetail,
    required this.ownerId,
    this.owner,
    this.commentsCount,
    required this.imageUrl,
    required this.tags,
    this.createdAt,
    required this.likes,
  });

  static Future<PostModel> fromFirestoreWithUser(DocumentSnapshot doc) async {
    final data = doc.data() as Map<String, dynamic>;
    final Timestamp? timestamp = data['createdAt'] as Timestamp?;
    UserModel? owner;
    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(data['ownerId']).get();
      owner = UserModel.fromFirestore(userDoc);
    } catch (e) {
      log('Error fetching user data: $e');
    }
    return PostModel(
      id: doc.id,
      postDetail: data['postDetail'] ?? '',
      ownerId: data['ownerId'] ?? '',
      owner: owner,
      imageUrl: data['imageUrl'] ?? '',
      tags: List<String>.from(data['tags'] ?? []),
      createdAt: timestamp != null ? relativeDate(timestamp.toDate()) : null,
      likes: List<String>.from(data['likes'] ?? []),
      commentsCount: data['commentsCount'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'postDetail': postDetail,
      'ownerId': ownerId,
      'commentsCount': commentsCount,
      'imageUrl': imageUrl,
      'tags': tags,
      'likes': likes,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  static String relativeDate(DateTime dateTime) {
    return timeago.format(dateTime);
  }

  PostModel copyWith({
    String? id,
    String? postDetail,
    String? ownerId,
    String? imageUrl,
    List<String>? tags,
    String? createdAt,
    UserModel? owner,
    int? commentsCount,
    List<String>? likes,
  }) {
    return PostModel(
      id: id ?? this.id,
      postDetail: postDetail ?? this.postDetail,
      ownerId: ownerId ?? this.ownerId,
      owner: owner ?? this.owner,
      imageUrl: imageUrl ?? this.imageUrl,
      tags: tags ?? this.tags,
      commentsCount: commentsCount ?? this.commentsCount,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
    );
  }
}
