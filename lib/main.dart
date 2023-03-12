import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tembird_app/constant/Common.dart';
import 'package:tembird_app/constant/StyledPalette.dart';
import 'package:tembird_app/view/create/schedule/CreateScheduleView.dart';
import 'package:tembird_app/view/home/HomeView.dart';
import 'package:tembird_app/view/home/binding/HomeBinding.dart';
import 'package:tembird_app/view/init/InitView.dart';
import 'package:tembird_app/view/init/binding/InitBinding.dart';

import 'constant/PageNames.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  await Hive.initFlutter();
  await Hive.openBox(Common.session);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
      initialBinding: InitBinding(),
      initialRoute: PageNames.INIT,
      getPages: [
        GetPage(
          name: PageNames.INIT,
          page: () => const InitView(),
          binding: InitBinding(),
        ),
        GetPage(
          name: PageNames.HOME,
          page: () => const HomeView(),
          binding: HomeBinding(),
        ),
      ],
    );
  }
}