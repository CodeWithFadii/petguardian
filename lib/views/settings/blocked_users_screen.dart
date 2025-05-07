import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:petguardian/resources/constants/app_colors.dart';
import 'package:petguardian/resources/constants/app_icons.dart';
import 'package:petguardian/resources/constants/constants.dart';
import 'package:petguardian/resources/utils.dart';
import 'package:petguardian/resources/widgets/app_text_widget.dart';
import 'package:petguardian/resources/widgets/shimmer_cached_image.dart';
import 'package:sizer/sizer.dart';

class BlockedUsersScreen extends StatelessWidget {
  const BlockedUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 5.w),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: SizedBox(height: 5.5.h, width: 11.w, child: SvgPicture.asset(AppIcons.backButton)),
                  ),
                  SizedBox(width: 5.w),
                  AppTextWidget(text: 'Blocked Users', fontWeight: FontWeight.w500, fontSize: 17.5),
                ],
              ),
              SizedBox(height: 3.h),
              Expanded(
                child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: AppTextWidget(text: 'Error: ${snapshot.error}', color: Colors.red),
                      );
                    }

                    final data = snapshot.data?.data() as Map<String, dynamic>?;
                    final blockedUserIds = data?['blocks'] != null ? List<String>.from(data!['blocks']) : [];

                    if (blockedUserIds.isEmpty) {
                      return Center(child: AppTextWidget(text: 'No blocked users yet', fontSize: 16));
                    }

                    return FutureBuilder<List<DocumentSnapshot>>(
                      future: userC.fetchBlockedUsers(blockedUserIds),
                      builder: (context, userSnapshot) {
                        if (userSnapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (userSnapshot.hasError) {
                          return Center(
                            child: AppTextWidget(text: 'Error: ${userSnapshot.error}', color: Colors.red),
                          );
                        }

                        final users = userSnapshot.data ?? [];

                        return ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            final user = users[index].data() as Map<String, dynamic>;
                            final userId = users[index].id;

                            return Container(
                              padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 3.w),
                              margin: EdgeInsets.only(bottom: 2.h),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  user['img']?.isNotEmpty == true
                                      ? ClipRRect(
                                        borderRadius: BorderRadius.circular(100),
                                        child: CircleAvatar(
                                          radius: 20,
                                          child: ShimmerCachedImage(imageUrl: user['img']),
                                        ),
                                      )
                                      : CircleAvatar(
                                        radius: 20,
                                        backgroundColor: AppColors.secondary,
                                        child: AppTextWidget(
                                          text: Utils.getInitial(user['name'] ?? ''),
                                          fontFamily: headingFont,
                                        ),
                                      ),
                                  SizedBox(width: 3.w),
                                  AppTextWidget(
                                    text: user['name'] ?? 'Unknown User',
                                    fontWeight: FontWeight.w600,
                                  ),
                                  Spacer(),
                                  TextButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder:
                                            (context) => AlertDialog(
                                              title: Text('Unblock User'),
                                              content: Text(
                                                'Are you sure you want to unblock ${user['name']}?',
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Get.back(),
                                                  child: Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    await FirebaseFirestore.instance
                                                        .collection('users')
                                                        .doc(uid)
                                                        .update({
                                                          'blocks': FieldValue.arrayRemove([userId]),
                                                        });
                                                    final updatedBlocks = List<String>.from(
                                                      userC.user!.blocks,
                                                    )..remove(userId);
                                                    userC.user = userC.user?.copyWith(blocks: updatedBlocks);
                                                    Get.back();
                                                  },
                                                  child: Text('Unblock'),
                                                ),
                                              ],
                                            ),
                                      );
                                    },
                                    child: Text('Unblock'),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
