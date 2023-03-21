import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:tembird_app/constant/StyledPalette.dart';

import '../../constant/StyledFont.dart';

class HtmlViewArguments {
  final String title;
  final String data;

  HtmlViewArguments({
    required this.title,
    required this.data,
  });
}

class HtmlView extends StatelessWidget {
  const HtmlView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HtmlViewArguments htmlViewArguments = Get.arguments as HtmlViewArguments;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: Get.back,
          color: StyledPalette.BLACK,
        ),
        title: Text(
          htmlViewArguments.title,
          style: StyledFont.TITLE_2,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Html(
            style: {
              'html': Style(
                color: StyledPalette.MINERAL,
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              'h2': Style(
                color: StyledPalette.BLACK,
                fontSize: const FontSize(16),
              ),
              'h3': Style(
                color: StyledPalette.BLACK,
                fontSize: const FontSize(14),
              ),
              'h4': Style(
                color: StyledPalette.BLACK,
                fontWeight: FontWeight.w600,
                fontSize: const FontSize(12),
                padding: EdgeInsets.zero,
              ),
              'p': Style(
                color: StyledPalette.BLACK,
                fontWeight: FontWeight.w400,
                fontSize: const FontSize(12),
                padding: EdgeInsets.zero,
              ),
              'li': Style(
                color: StyledPalette.BLACK,
                fontSize: const FontSize(14),
              ),
            },
            data: htmlViewArguments.data,
          ),
        ),
      ),
    );
  }
}
