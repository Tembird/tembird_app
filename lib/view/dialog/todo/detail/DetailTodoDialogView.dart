import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tembird_app/constant/StyledPalette.dart';
import 'package:tembird_app/view/dialog/todo/detail/argument/DetailTodoDialogArgument.dart';
import 'package:tembird_app/view/dialog/todo/detail/controller/DetailTodoDialogController.dart';

import '../../../../constant/StyledFont.dart';

class DetailTodoDialogView extends GetView<DetailTodoDialogController> {
  const DetailTodoDialogView({Key? key}) : super(key: key);

  static route({required DetailTodoDialogArgument argument}) {
    return GetBuilder(
      init: DetailTodoDialogController(argument: argument),
      builder: (_) => const DetailTodoDialogView(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: StyledPalette.TRANSPARENT,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Obx(
            () => controller.bannerAd.value == null
                ? const SizedBox(height: 66)
                : SizedBox(
                    height: 66,
                    child: Material(
                      borderRadius: BorderRadius.circular(16),
                      color: StyledPalette.MINERAL,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: AdWidget(ad: controller.bannerAd.value!),
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 16),
          Material(
            borderRadius: BorderRadius.circular(16),
            color: StyledPalette.MINERAL,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              constraints: BoxConstraints(maxHeight: Get.height / 2),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      controller.argument.labelTitle,
                      style: StyledFont.CALLOUT_700.copyWith(color: controller.argument.labelColor),
                    ),
                    const Divider(
                      height: 16,
                      thickness: 0.5,
                    ),
                    Row(
                      children: const [
                        Icon(
                          Icons.access_time_outlined,
                          size: 12,
                          color: StyledPalette.GRAY,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '제목',
                          style: StyledFont.FOOTNOTE_GRAY,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      controller.argument.title,
                      style: StyledFont.TITLE_3_700,
                    ),
                    if (controller.argument.location != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.location_on_outlined,
                              size: 12,
                              color: StyledPalette.GRAY,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '장소',
                              style: StyledFont.FOOTNOTE_GRAY,
                            ),
                          ],
                        ),
                      ),
                    if (controller.argument.location != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          controller.argument.location!,
                          style: StyledFont.CALLOUT,
                        ),
                      ),
                    if (controller.argument.detail != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.article_outlined,
                              size: 12,
                              color: StyledPalette.GRAY,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '상세 내용',
                              style: StyledFont.FOOTNOTE_GRAY,
                            ),
                          ],
                        ),
                      ),
                    if (controller.argument.detail != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          controller.argument.detail!,
                          style: StyledFont.CALLOUT,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => Get.back(result: true),
            child: const Icon(Icons.settings, size: 24, color: StyledPalette.GRAY),
          )
        ],
      ),
    );
  }
}
