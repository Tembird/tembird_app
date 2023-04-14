import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tembird_app/service/RootController.dart';

class CalendarController extends RootController {
  final DateTime initDate;
  final double bannerAdWidth;
  static CalendarController to = Get.find();

  CalendarController({required this.initDate, required this.bannerAdWidth});

  double? y;
  final Rx<bool> onLoading = RxBool(true);

  final Rxn<DateTime> selectedDate = Rxn(null);
  final RxString selectedDateText = RxString('');
  @override
  void onInit() async {
    onLoading.value = true;
    selectedDate.value = initDate;
    selectedDateText.value = dateToString(date: initDate);
    onLoading.value = false;
    await initializeBannerAds();
    super.onInit();
  }

  @override
  void onClose() {
    if (bannerAd.value == null) return;
    bannerAd.value!.dispose();
    bannerAd.value = null;
    super.onClose();
  }

  void changeDate(DateTime date) {
    selectedDate.value = date;
    selectedDateText.value = dateToString(date: date);
  }

  void closeCalendar() {
    Get.back();
  }

  void confirmCalendar() {
    if (selectedDate.value == initDate) {
      Get.back();
      return;
    }
    Get.back(result: selectedDate.value);
  }

  /// GoogleAds
  final Rxn<BannerAd> bannerAd = Rxn(null);

  Future<void> initializeBannerAds() async {
    final iosAppId = kReleaseMode ? FlutterConfig.get('IOS_ADMOB_ID_CALENDAR_DIALOG') : FlutterConfig.get('DEV_IOS_ADMOB_ID');
    final aosAppId = kReleaseMode ? FlutterConfig.get('AOS_ADMOB_ID_CALENDAR_DIALOG') : FlutterConfig.get('DEV_AOS_ADMOB_ID');

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
      size: AdSize.getCurrentOrientationInlineAdaptiveBannerAdSize(bannerAdWidth.toInt() - 64),
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
