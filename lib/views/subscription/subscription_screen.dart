import 'dart:developer';

import 'package:get/get.dart';
import 'package:petguardian/controllers/subscription_controller.dart';
import 'package:petguardian/resources/constants/app_colors.dart';
import 'package:petguardian/resources/widgets/app_button_widget.dart';
import 'package:petguardian/resources/widgets/app_text_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:petguardian/resources/widgets/loader.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';

import '../../resources/constants/app_icons.dart';
import '../../resources/constants/constants.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GlobalLoader(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 5.w),
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: SizedBox(
                        height: 5.5.h,
                        width: 11.w,
                        child: SvgPicture.asset(AppIcons.backButton),
                      ),
                    ),
                    SizedBox(width: 5.w),
                    AppTextWidget(text: 'Subscription', fontWeight: FontWeight.w500, fontSize: 17.5),
                  ],
                ),
                SizedBox(height: 3.h),

                Obx(() {
                  if (!subscriptionC.isAvailable.value) {
                    return Center(child: Loader());
                  }
                  if (subscriptionC.products.isEmpty) {
                    return Center(child: Loader());
                  }
                  // Access selectedProduct to make Obx depend on it
                  final selectedId = subscriptionC.selectedProduct.value?.id ?? '';
                  return Column(
                    children: [
                      ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: subscriptionC.products.length,
                        separatorBuilder: (_, __) => SizedBox(height: 2.h),
                        itemBuilder: (context, index) {
                          final product = subscriptionC.products[index];
                          final isSelected = selectedId == product.id;
                          return GestureDetector(
                            onTap: () => subscriptionC.selectProduct(product),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    isSelected
                                        ? Border.all(color: AppColors.primary)
                                        : Border.all(color: AppColors.bg),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        AppTextWidget(
                                          height: 1.3,
                                          textAlign: TextAlign.left,
                                          text: product.title.replaceAll('(Pet Guardian)', ''),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                          fontFamily: headingFont,
                                          color: AppColors.primary,
                                        ),
                                        SizedBox(height: 2.h),
                                        AppTextWidget(
                                          textAlign: TextAlign.left,
                                          height: 1.3,
                                          text: product.description,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        SizedBox(height: 2.h),
                                        AppTextWidget(
                                          text: product.price,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: AppColors.primary,
                                          fontFamily: headingFont,
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isSelected)
                                    Padding(
                                      padding: EdgeInsets.only(left: 2.w),
                                      child: Icon(Icons.check_circle, color: AppColors.primary, size: 28),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                }),
                Spacer(),
                Obx(() {
                  return AppButtonWidget(
                    text: 'Pay & Subscribe',
                    onTap:
                        subscriptionC.selectedProduct.value == null
                            ? null
                            : () {
                              showDialog(
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      title: Text('Confirm Payment'),
                                      content: Text(
                                        'Do you want to subscribe for ${subscriptionC.selectedProduct.value!.price}?',
                                      ),
                                      actions: [
                                        TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
                                        TextButton(
                                          onPressed: () {
                                            Get.back();
                                            subscriptionC.buy(subscriptionC.selectedProduct.value!);
                                          },
                                          child: Text('Pay'),
                                        ),
                                      ],
                                    ),
                              );
                            },
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
