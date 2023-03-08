import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tembird_app/constant/StyledFont.dart';
import 'package:tembird_app/constant/StyledPalette.dart';
import 'package:tembird_app/constant/StyledPalette.dart';
import 'package:tembird_app/constant/StyledPalette.dart';
import 'package:tembird_app/constant/StyledPalette.dart';
import 'package:tembird_app/constant/StyledPalette.dart';
import 'package:tembird_app/view/create/CreateView.dart';
import 'package:tembird_app/view/home/HomeView.dart';
import 'package:tembird_app/view/home/binding/HomeBinding.dart';

import 'constant/PageNames.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Tembird',
      theme: ThemeData(
        backgroundColor: StyledPalette.WHITE,
        scaffoldBackgroundColor: StyledPalette.WHITE,
        primaryColor: StyledPalette.PRIMARY_SKY_BRIGHT,
        appBarTheme: const AppBarTheme(
          backgroundColor: StyledPalette.WHITE,
          foregroundColor: StyledPalette.BLACK,
          elevation: 0,
          titleSpacing: 16,
          centerTitle: false,
          titleTextStyle: StyledFont.TITLE_3,
        ),
      ),
      initialBinding: HomeBinding(),
      initialRoute: PageNames.HOME,
      getPages: [
        GetPage(
          name: PageNames.HOME,
          page: () => const HomeView(),
          binding: HomeBinding(),
        ),
        GetPage(
          name: PageNames.CREATE,
          page: () => const CreateView(),
        ),
      ],
    );
  }
}