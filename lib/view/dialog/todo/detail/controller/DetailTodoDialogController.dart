import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tembird_app/service/RootController.dart';
import 'package:tembird_app/view/dialog/todo/detail/argument/DetailTodoDialogArgument.dart';

class DetailTodoDialogController extends RootController {
  final DetailTodoDialogArgument argument;

  DetailTodoDialogController({required this.argument});

  @override
  void onInit() async {
    await initializeBannerAds();
    super.onInit();
  }

  @override
  void onClose() async {
    await disposeBannerAds();
    super.onClose();
  }

  final Rxn<BannerAd> bannerAd = Rxn(null);

  Future<void> initializeBannerAds() async {
    final iosAppId = kReleaseMode ? FlutterConfig.get('IOS_ADMOB_ID_DETAIL_TODO_DIALOG') : FlutterConfig.get('DEV_IOS_ADMOB_ID');
    final aosAppId = kReleaseMode ? FlutterConfig.get('AOS_ADMOB_ID_DETAIL_TODO_DIALOG') : FlutterConfig.get('DEV_AOS_ADMOB_ID');

    bannerAd.value = BannerAd(
      adUnitId: Platform.isIOS ? iosAppId : aosAppId,
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
      size: AdSize.getCurrentOrientationInlineAdaptiveBannerAdSize(argument.bannerAdWidth.toInt() - 64),
    );
    if (bannerAd.value == null) return;
    await bannerAd.value!.load();
  }

  Future<void> disposeBannerAds() async {
    if (bannerAd.value == null) return;
    await bannerAd.value!.dispose();
    bannerAd.value == null;
  }
}
