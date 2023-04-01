import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tembird_app/service/RootController.dart';

class GoogleAdsController extends RootController {
  final double width;
  GoogleAdsController({required this.width});

  final Rxn<BannerAd> bannerAd = Rxn(null);

  @override
  void onInit() async {
    initializeBannerAds();
    super.onInit();
  }

  @override
  void dispose() {
    if (bannerAd.value == null) return;
    bannerAd.value!.dispose();
    bannerAd.value == null;
    super.dispose();
  }

  void initializeBannerAds() async {
    final IOS_APP_ID = kReleaseMode ? FlutterConfig.get('IOS_ADMOB_BANNER_APP_ID') : FlutterConfig.get('DEV_IOS_ADMOB_BANNER_APP_ID');
    final AOS_APP_ID = kReleaseMode ? FlutterConfig.get('AOS_ADMOB_BANNER_APP_ID') : FlutterConfig.get('DEV_AOS_ADMOB_BANNER_APP_ID');

    bannerAd.value = BannerAd(
      adUnitId: Platform.isIOS ? IOS_APP_ID : AOS_APP_ID,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (Ad ad) => print('Ad loaded.'),
        // Called when an ad request failed.
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          // Dispose the ad here to free resources.
          ad.dispose();
          print('Ad failed to load: $error');
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) => print('Ad opened.'),
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) => print('Ad closed.'),
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) => print('Ad impression.'),
      ),
      request: const AdRequest(),
      size: AdSize.getCurrentOrientationInlineAdaptiveBannerAdSize(width.toInt()),
    );
    if (bannerAd.value == null) return;
    bannerAd.value!.load();
  }
}
