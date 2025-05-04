import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:petguardian/resources/constants/app_colors.dart';
import 'package:sizer/sizer.dart';

import '../../models/notification_model.dart';
import '../../resources/constants/app_icons.dart';
import '../../resources/constants/constants.dart';
import '../../resources/widgets/app_text_widget.dart';

class ReminderScreen extends StatelessWidget {
  const ReminderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 6.w),
          child: Column(
            children: [
              SizedBox(height: 2.h),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream:
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(uid)
                          .collection('notifications')
                          .orderBy('createdAt', descending: true)
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: AppTextWidget(
                          text: 'No notifications yet.',
                          fontSize: 16,
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }
                    final notifications =
                        snapshot.data!.docs.map((doc) => NotificationModel.fromMap(doc)).toList();
                    return ListView.builder(
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        final notification = notifications[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.all(1.2.h),
                                height: 6.h,
                                width: 12.w,
                                decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.secondary),
                                child: SvgPicture.asset(AppIcons.announcement, color: AppColors.black),
                              ),
                              SizedBox(width: 4.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: AppTextWidget(
                                            text: notification.title,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            maxLines: 2,
                                          ),
                                        ),
                                        SizedBox(width: 2.w),
                                        AppTextWidget(
                                          text: notification.createdAt ?? '',
                                          color: const Color(0xffAAAFB6),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 1.h),
                                    AppTextWidget(
                                      color: const Color(0xff585A5B),
                                      text: notification.body,
                                      fontSize: 15.5,
                                      padding: EdgeInsets.only(right: 5.w),
                                      maxLines: 2,
                                      textAlign: TextAlign.left,
                                      height: 1.3,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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

// @override
// void initState() {
//   super.initState();
//   // _markNotificationsAsRead();
// }
//
// Future<void> _markNotificationsAsRead() async {
//   final batch = FirebaseFirestore.instance.batch();
//   final notificationsRef = FirebaseFirestore.instance
//       .collection('users')
//       .doc(uid)
//       .collection('notifications');
//
//   final snapshot = await notificationsRef.where('isRead', isEqualTo: false).get();
//
//   for (var doc in snapshot.docs) {
//     batch.update(doc.reference, {'isRead': true});
//   }
//
//   await batch.commit();
// }
