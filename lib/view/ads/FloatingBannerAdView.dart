import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tembird_app/view/ads/controller/GoogleAdsController.dart';

import '../../../../constant/StyledPalette.dart';

class FloatingBannerAdView extends GetView<GoogleAdsController> {
  const FloatingBannerAdView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: GoogleAdsController(width: Get.width - 64),
      builder: (_) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        height: 66,
        child: Material(
          borderRadius: BorderRadius.circular(16),
          color: StyledPalette.MINERAL,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: controller.bannerAd.value == null ? Container() : AdWidget(ad: controller.bannerAd.value!),
          ),
        ),
      ),
    );
  }
}
