import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:petguardian/resources/constants/constants.dart';
import 'package:petguardian/resources/routes/routes_name.dart';
import 'package:sizer/sizer.dart';
import '../../resources/constants/app_colors.dart';
import '../../resources/constants/app_images.dart';
import '../../resources/services/storage_service.dart';
import '../../resources/widgets/app_button_widget.dart';
import '../../resources/widgets/app_text_widget.dart';
import 'components/onboarding_indicator_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> _content = [
    {
      'title': 'Never Miss a Meal',
      'subtitle': 'Track your pet’s feeding schedule and make sure they’re always happy and healthy.',
    },
    {
      'title': 'Stay Groomed & Clean',
      'subtitle': 'Get reminders for grooming sessions and keep your furry friend fresh and tidy.',
    },
    {
      'title': 'Health Records in One Place',
      'subtitle': 'Easily manage vet visits, medications, and health updates in one app.',
    },
    {
      'title': 'Fun Activities',
      'subtitle': 'Log walks, playtime, and more to keep track of your pet’s daily happiness.',
    },
    {
      'title': 'Happy Pet, Happy You!',
      'subtitle': 'A simple way to take the best care of your pet — right from your phone.',
    },
  ];

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onContinue() {
    if (_currentIndex < _content.length - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      _navigate();
    }
  }

  void _navigate() {
    if (mounted) {
      StorageService.setUser(false);
      Get.offAllNamed(RoutesName.welcomeScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            children: [
              SvgPicture.asset(AppImages.onboarding),
              SizedBox(
                height: 35.h,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: _content.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        AppTextWidget(
                          text: _content[index]['title']!,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                          fontFamily: headingFont,
                          height: 1.4,
                          fontSize: 26,
                        ),
                        SizedBox(height: 2.h),
                        AppTextWidget(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          text: _content[index]['subtitle']!,
                          fontSize: 15,
                          height: 1.5,
                        ),
                      ],
                    );
                  },
                ),
              ),
              OnboardingIndicatorWidget(index: _currentIndex),
              Spacer(),
              AppButtonWidget(
                onTap: _onContinue,
                text: _currentIndex == _content.length - 1 ? 'Get Started' : 'Next',
              ),
              GestureDetector(
                onTap: _navigate,
                child: AppTextWidget(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  text: 'Skip',
                  fontWeight: FontWeight.w600,
                  textDecoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
