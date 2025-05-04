import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:petguardian/models/post_model.dart';
import 'package:petguardian/models/comment_model.dart';

import '../resources/constants/constants.dart';
import '../resources/services/storage_service.dart';
import '../resources/utils.dart';

class ForumController extends GetxController {
  final Rx<File?> _selectedImage = Rx<File?>(null);
  final RxList<String> _tags = <String>[].obs;
  TextEditingController? tagC;
  TextEditingController? _postDetailC;

  File? get selectedImage => _selectedImage.value;
  List<String> get tags => _tags;
  TextEditingController? get tagController => tagC;
  TextEditingController? get postDetailC => _postDetailC;

  @override
  onInit() {
    tagC = TextEditingController();
    _postDetailC = TextEditingController();
    super.onInit();
  }

  void setDefault() {
    _selectedImage.value = null;
    _tags.clear();
    tagC!.clear();
    _postDetailC!.clear();
  }

  Future<void> uploadPost({required BuildContext context}) async {
    loaderC.showLoader();
    try {
      String? imageUrl;
      if (_selectedImage.value == null) {
        Utils.showMessage('Please select an image', context: context, isError: true);
        loaderC.hideLoader();
        return;
      }
      if (_tags.isEmpty) {
        Utils.showMessage('Please enter a tag', context: context, isError: true);
        loaderC.hideLoader();
        return;
      }
      if (_selectedImage.value != null) {
        imageUrl = await StorageService.uploadFileToCloudinary(_selectedImage.value!.path);
      }
      final postModel = PostModel(
        postDetail: _postDetailC!.text.trim(),
        ownerId: userC.user!.id!,
        imageUrl: imageUrl ?? '',
        tags: _tags,
        likes: [],
        commentsCount: 0,
      );
      await FirebaseFirestore.instance.collection('posts').add(postModel.toFirestore());
      await Utils.uploadNotificationToFirebase(
        title: 'Post Uploaded',
        body: 'New Post uploaded successfully.',
      );
      Utils.showMessage('Post uploaded successfully', context: context, isError: false);
      setDefault();
      Get.back();
    } catch (e, stackTrace) {
      log('Error uploading post : $e\n$stackTrace');
      Utils.showMessage('Error uploading post', context: context, isError: true);
    } finally {
      loaderC.hideLoader();
    }
  }

  Stream<List<PostModel>> postsStream() {
    return FirebaseFirestore.instance
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
          final posts = await Future.wait(
            snapshot.docs.map((doc) async {
              return await PostModel.fromFirestoreWithUser(doc);
            }),
          );
          return posts;
        });
  }

  Stream<List<PostModel>> myPostsStream() {
    return FirebaseFirestore.instance
        .collection('posts')
        .where('ownerId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
          final posts = await Future.wait(
            snapshot.docs.map((doc) async {
              return await PostModel.fromFirestoreWithUser(doc);
            }),
          );
          return posts;
        });
  }

  Future<void> likePost(String postId) async {
    try {
      final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);
      await postRef.update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    } catch (e) {
      log('Error liking post: $e');
    }
  }

  Future<void> unlikePost(String postId) async {
    try {
      final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);
      await postRef.update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } catch (e) {
      log('Error unliking post: $e');
    }
  }

  void pickImage() async {
    final images = await showImagePickerBottomSheet(multiple: false) ?? [];
    if (images.isNotEmpty) {
      _selectedImage.value = images.first;
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

  Stream<List<CommentModel>> commentsStream(String postId) {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
          final comments = await Future.wait(
            snapshot.docs.map((doc) async {
              return await CommentModel.fromFirestoreWithUser(doc, postId);
            }),
          );
          return comments;
        });
  }

  Future<void> addComment(String postId, String commentText) async {
    try {
      final commentModel = CommentModel(postId: postId, userId: uid, commentText: commentText);
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .add(commentModel.toFirestore());
      final doc = await FirebaseFirestore.instance.collection('posts').doc(postId).get();
      final newCommentCount = (doc.data()!['commentsCount'] as int) + 1;
      await FirebaseFirestore.instance.collection('posts').doc(postId).update({
        'commentsCount': newCommentCount,
      });
    } catch (e) {
      log('Error adding comment: $e');
    }
  }

  Future<void> deleteComment(String postId, String commentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .delete();
      final doc = await FirebaseFirestore.instance.collection('posts').doc(postId).get();
      final newCommentCount = (doc.data()!['commentsCount'] as int) - 1;
      await FirebaseFirestore.instance.collection('posts').doc(postId).update({
        'commentsCount': newCommentCount,
      });
    } catch (e) {
      log('Error deleting comment: $e');
    }
  }

  @override
  void dispose() {
    tagC!.dispose();
    _postDetailC!.dispose();
    super.dispose();
  }
}
