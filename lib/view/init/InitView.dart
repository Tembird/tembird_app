import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tembird_app/constant/AssetNames.dart';
import 'package:tembird_app/constant/StyledFont.dart';
import 'package:tembird_app/constant/StyledPalette.dart';

import 'controller/InitController.dart';

class InitView extends GetView<InitController> {
  static String routeName = '/';
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
              backgroundColor: StyledPalette.PRIMARY_BLUE,
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Expanded(child: MainContent()),
                      SizedBox(height: 8),
                      LoginButton(),
                      SizedBox(height: 8),
                      SignUpButton(),
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
          color: StyledPalette.WHITE,
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
        width: double.infinity,
        child: const Center(
          child: Text(
            '로그인',
            style: StyledFont.TITLE_2_PRIMARY_BLUE,
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
          border: Border.all(color: StyledPalette.WHITE, width: 1),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
        width: double.infinity,
        child: const Center(
          child: Text(
            '계정 만들기',
            style: StyledFont.TITLE_2_WHITE,
          ),
        ),
      ),
    );
  }
}

class MainContent extends StatelessWidget {
  const MainContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 150,
              child: Image.asset(AssetNames.logoTextWhite),
            ),
            const SizedBox(height: 16),
            Container(
              width: 60,
              height: 4,
              color: StyledPalette.WHITE,
            ),
            const SizedBox(height: 16),
          ],
        ));
  }
}
