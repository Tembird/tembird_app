import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tembird_app/constant/AssetNames.dart';
import 'package:tembird_app/constant/StyledFont.dart';
import 'package:tembird_app/constant/StyledPalette.dart';

import 'controller/InitController.dart';

class InitView extends GetView<InitController> {
  const InitView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.onLoading.isTrue
          ? Scaffold(
              backgroundColor: StyledPalette.PRIMARY_BLUE,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset(AssetNames.logoSplash, width: 200),
                  ),
                ],
              ),
            )
          : Scaffold(
        backgroundColor: StyledPalette.MINERAL,
        appBar: AppBar(
          title: Center(child: Image.asset(AssetNames.logoText, width: 100)),
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Image.asset(AssetNames.logo, width: 200),
                  ),
                ),
                const SizedBox(height: 8),
                const LoginButton(),
                const SizedBox(height: 8),
                const SignUpButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginButton extends GetView<InitController> {
  const LoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: controller.routeLogin,
      radius: 16,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: StyledPalette.PRIMARY_BLUE,
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
        width: double.infinity,
        child: const Center(
          child: Text(
            '로그인',
            style: StyledFont.TITLE_2_WHITE,
          ),
        ),
      ),
    );
  }
}

class SignUpButton extends GetView<InitController> {
  const SignUpButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: controller.routeSignUp,
      radius: 16,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: StyledPalette.MINERAL,
          border: Border.all(color: StyledPalette.PRIMARY_BLUE, width: 1),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
        width: double.infinity,
        child: const Center(
          child: Text(
            '계정 만들기',
            style: StyledFont.TITLE_2_SKY,
          ),
        ),
      ),
    );
  }
}
