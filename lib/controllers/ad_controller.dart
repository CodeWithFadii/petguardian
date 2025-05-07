import 'dart:developer';

import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:petguardian/resources/constants/constants.dart';

class AdController extends GetxController {
  static const String appId = 'ca-app-pub-9771433924337955~3544526128';
  static const String appOpenAdUnitId = 'ca-app-pub-9771433924337955/9880261388';
  final RxBool _isPaid = false.obs;
  AppOpenAd? _appOpenAd;
  bool _isAdAvailable = false;
  bool get isPaid => _isPaid.value;
  set isPaid(bool value) => _isPaid.value = value;

  @override
  void onInit() {
    // _initAdMob();
    super.onInit();
  }

  void initAdMob() {
    if (!_isPaid.value) {
      _loadAppOpenAd();
    }
  }

  void _loadAppOpenAd() {
    loaderC.showLoader();
    AppOpenAd.load(
      adUnitId: appOpenAdUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _isAdAvailable = true;
          loaderC.hideLoader();
          showAppOpenAd();
        },
        onAdFailedToLoad: (error) {
          log('App Open Ad failed to load: $error');
          loaderC.hideLoader();
          _isAdAvailable = false;
        },
      ),
    );
  }

  void showAppOpenAd() {
    if (_isAdAvailable && _appOpenAd != null) {
      _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _isAdAvailable = false;
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _isAdAvailable = false;
        },
      );
      _appOpenAd!.show();
    }
  }
}
