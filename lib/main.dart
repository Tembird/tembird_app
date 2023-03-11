import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tembird_app/constant/StyledPalette.dart';
import 'package:tembird_app/view/create/schedule/CreateScheduleView.dart';
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
        backgroundColor: StyledPalette.MINERAL,
        scaffoldBackgroundColor: StyledPalette.WHITE,
        dialogBackgroundColor: StyledPalette.MINERAL,
        appBarTheme: const AppBarTheme(
          backgroundColor: StyledPalette.MINERAL,
          foregroundColor: StyledPalette.BLACK,
          elevation: 0,
          titleSpacing: 16,
          centerTitle: false,
          toolbarHeight: 50,
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
      ],
    );
  }
}