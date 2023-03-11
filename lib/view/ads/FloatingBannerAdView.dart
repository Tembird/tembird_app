import 'package:flutter/material.dart';

import '../../../../constant/StyledPalette.dart';

class FloatingBannerAdView extends StatelessWidget {
  const FloatingBannerAdView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 66,
      child: Material(
        borderRadius: BorderRadius.circular(16),
        color: StyledPalette.MINERAL,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: SizedBox(
            height: 50,
            width: 325,
            // TODO : Google AdMob
          ),
        ),
      ),
    );
  }
}
