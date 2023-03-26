import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tembird_app/constant/StyledFont.dart';

import '../../../constant/StyledPalette.dart';
import 'controller/HelpController.dart';

class HelpView extends GetView<HelpController> {
  const HelpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('설정', style: StyledFont.TITLE_2),
        centerTitle: true,
        actions: [
          CloseButton(
            onPressed: controller.back,
            color: StyledPalette.BLACK,
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: const [
                ProfileInfoCard(),
                SizedBox(height: 16),
                ProfileSettingCard(),
                SizedBox(height: 16),
                AppInfoCard(),
                SizedBox(height: 16),
                SessionCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CardView extends StatelessWidget {
  final Widget child;

  const CardView({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: StyledPalette.GRAY, width: 1),
      ),
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }
}

class CardItem extends StatelessWidget {
  final void Function() onTap;
  final String title;
  final String? content;
  final bool? isNegative;

  const CardItem({Key? key, required this.onTap, required this.title, this.content, this.isNegative}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(title, style: isNegative == null || !isNegative! ? StyledFont.BODY : StyledFont.BODY_NEGATIVE),
            ),
            if (content != null) Text(content!, style: StyledFont.BODY_GRAY)
          ],
        ),
      ),
    );
  }
}

class ProfileInfoCard extends GetView<HelpController> {
  const ProfileInfoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('ID', style: StyledFont.HEADLINE),
              const SizedBox(width: 4),
              Obx(() => Text(controller.username.value, style: StyledFont.BODY)),
            ],
          ),
          const SizedBox(height: 4),
          Text(controller.email, style: StyledFont.FOOTNOTE_GRAY),
        ],
      ),
    );
  }
}

class ProfileSettingCard extends GetView<HelpController> {
  const ProfileSettingCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('계정 설정', style: StyledFont.HEADLINE),
          const SizedBox(height: 8),
          CardItem(onTap: controller.updateUsername, title: '아이디 설정'),
          CardItem(onTap: controller.updatePassword, title: '비밀번호 변경'),
        ],
      ),
    );
  }
}

class AppInfoCard extends GetView<HelpController> {
  const AppInfoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('이용 안내', style: StyledFont.HEADLINE),
          const SizedBox(height: 8),
          CardItem(
            onTap: controller.checkRecentVersion,
            title: '앱 버전',
            content: controller.appVersion,
          ),
          CardItem(
            onTap: controller.showAnnouncement,
            title: '공지사항',
          ),
          CardItem(
            onTap: controller.showTerms,
            title: '서비스 이용약관',
          ),
          CardItem(
            onTap: controller.showPrivacyPolicy,
            title: '개인정보 처리방침',
          ),
          CardItem(
            onTap: controller.contact,
            title: '이용 문의',
          ),
        ],
      ),
    );
  }
}

class SessionCard extends GetView<HelpController> {
  const SessionCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('기타', style: StyledFont.HEADLINE),
          const SizedBox(height: 8),
          CardItem(
            onTap: controller.signOut,
            title: '로그아웃',
          ),
          CardItem(
            onTap: controller.removeAccount,
            title: '회원 탈퇴',
            isNegative: true,
          ),
        ],
      ),
    );
  }
}
