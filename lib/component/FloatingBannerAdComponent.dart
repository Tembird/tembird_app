import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../../constant/StyledPalette.dart';

class FloatingBannerAdComponent extends StatelessWidget {
  final BannerAd bannerAd;
  const FloatingBannerAdComponent({Key? key, required this.bannerAd}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 66,
      child: Material(
        borderRadius: BorderRadius.circular(16),
        color: StyledPalette.MINERAL,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: AdWidget(ad: bannerAd),
        ),
      ),
    );
  }
}
