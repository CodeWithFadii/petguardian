import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:sizer/sizer.dart';

import '../../../resources/constants/app_colors.dart';

//
// class TermsAndConditions extends StatelessWidget {
//   const TermsAndConditions({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(top: 2.5.h),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           SizedBox(
//             width: 6.5.w,
//             height: 3.25.h,
//             child: Obx(() {
//               return Checkbox(
//                 focusColor: AppColors.primary,
//                 value: authC.privacyChecked,
//                 onChanged: (bool? value) {
//                   authC.togglePrivacy();
//                 },
//                 activeColor: AppColors.primary,
//               );
//             }),
//           ),
//           SizedBox(width: 2.w),
//           Flexible(
//             child: GestureDetector(
//               onTap: () {
//                 authC.togglePrivacy();
//               },
//               child: RichText(
//                 text: TextSpan(
//                   style: const TextStyle(
//                     color: Colors.black,
//                     fontSize: 15.5,
//                     height: 1.4,
//                     fontFamily: 'Poppins',
//                   ),
//                   children: [
//                     const TextSpan(text: 'By continue you accept our '),
//                     TextSpan(
//                       text: 'Privacy Policy',
//                       style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w500),
//                       recognizer: TapGestureRecognizer()..onTap = () {},
//                     ),
//                     const TextSpan(text: ' and '),
//                     TextSpan(
//                       text: 'Terms & Conditions',
//                       style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w500),
//                       recognizer: TapGestureRecognizer()..onTap = () {},
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
final defaultPinTheme = PinTheme(
  margin: EdgeInsets.symmetric(horizontal: 2.w),
  width: 13.w,
  height: 6.h,
  textStyle: TextStyle(fontSize: 18.sp, fontFamily: 'Poppins', fontWeight: FontWeight.w600),
  decoration: BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: AppColors.black),
  ),
);
