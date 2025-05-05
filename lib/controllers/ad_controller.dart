import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdController extends GetxController {
  static const String appId = 'ca-app-pub-9771433924337955~3544526128';
  static const String appOpenAdUnitId = 'ca-app-pub-9771433924337955/9880261388';

  AppOpenAd? _appOpenAd;
  bool _isAdAvailable = false;

  @override
  void onInit() {
    super.onInit();
    _initAdMob();
  }

  void _initAdMob() {
    _loadAppOpenAd();
  }

  void _loadAppOpenAd() {
    AppOpenAd.load(
      adUnitId: appOpenAdUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _isAdAvailable = true;
          showAppOpenAd();
        },
        onAdFailedToLoad: (error) {
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
