import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tembird_app/constant/Common.dart';
import 'package:tembird_app/constant/StyledFont.dart';
import 'package:tembird_app/constant/StyledPalette.dart';
import 'package:tembird_app/view/auth/login/LoginView.dart';
import 'package:tembird_app/view/auth/login/binding/LoginBinding.dart';
import 'package:tembird_app/view/auth/resetPassword/ResetPasswordView.dart';
import 'package:tembird_app/view/auth/resetPassword/binding/ResetPasswordBinding.dart';
import 'package:tembird_app/view/auth/signup/SignupView.dart';
import 'package:tembird_app/view/auth/signup/binding/SignupBinding.dart';
import 'package:tembird_app/view/common/HtmlView.dart';
import 'package:tembird_app/view/help/announcement/AnnouncementDetailView.dart';
import 'package:tembird_app/view/help/announcement/AnnouncementView.dart';
import 'package:tembird_app/view/help/announcement/binding/AnnouncementBinding.dart';
import 'package:tembird_app/view/help/contact/ContactView.dart';
import 'package:tembird_app/view/help/contact/binding/ContactBinding.dart';
import 'package:tembird_app/view/help/main/HelpView.dart';
import 'package:tembird_app/view/help/main/binding/HelpBinding.dart';
import 'package:tembird_app/view/help/removeAccount/RemoveAccountView.dart';
import 'package:tembird_app/view/help/removeAccount/binding/RemoveAccountBinding.dart';
import 'package:tembird_app/view/help/updatePassword/UpdatePasswordView.dart';
import 'package:tembird_app/view/help/updatePassword/binding/UpdatePasswordBinding.dart';
import 'package:tembird_app/view/help/updateUsername/RegisterUsername.dart';
import 'package:tembird_app/view/help/updateUsername/UpdateUsernameView.dart';
import 'package:tembird_app/view/help/updateUsername/binding/UpdateUsernameBinding.dart';
import 'package:tembird_app/view/home/HomeView.dart';
import 'package:tembird_app/view/home/binding/HomeBinding.dart';
import 'package:tembird_app/view/init/InitView.dart';
import 'package:tembird_app/view/init/binding/InitBinding.dart';
import 'package:tembird_app/view/todoLabel/all/binding/AllTodoLabelBinding.dart';
import 'package:tembird_app/view/todoLabel/all/AllTodoLabelView.dart';
import 'package:tembird_app/view/todoLabel/edit/EditTodoLabelView.dart';
import 'package:tembird_app/view/todoLabel/edit/binding/EditTodoLabelBinding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();

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
        scaffoldBackgroundColor: StyledPalette.MINERAL,
        dialogBackgroundColor: StyledPalette.MINERAL,
        appBarTheme: const AppBarTheme(
          backgroundColor: StyledPalette.MINERAL,
          foregroundColor: StyledPalette.BLACK,
          elevation: 0,
          titleSpacing: 16,
          centerTitle: false,
          toolbarHeight: 50,
          titleTextStyle: StyledFont.TITLE_3,
        ),
      ),
      initialBinding: InitBinding(),
      initialRoute: InitView.routeName,
      getPages: [
        GetPage(
          name: InitView.routeName,
          page: () => const InitView(),
          binding: InitBinding(),
        ),
        GetPage(
          name: LoginView.routeName,
          page: () => const LoginView(),
          binding: LoginBinding(),
        ),
        GetPage(
          name: SignupView.routeName,
          page: () => const SignupView(),
          binding: SignupBinding(),
        ),
        GetPage(
          name: ResetPasswordView.routeName,
          page: () => const ResetPasswordView(),
          binding: ResetPasswordBinding(),
        ),
        GetPage(
          name: RegisterUsernameView.routeName,
          page: () => const RegisterUsernameView(),
          binding: UpdateUsernameBinding(),
          popGesture: false,
        ),
        GetPage(
          name: HomeView.routeName,
          page: () => const HomeView(),
          binding: HomeBinding(),
          transition: Transition.noTransition,
          popGesture: false,
          transitionDuration: Duration.zero,
        ),
        GetPage(
          name: HelpView.routeName,
          page: () => const HelpView(),
          binding: HelpBinding(),
          fullscreenDialog: true,
        ),
        GetPage(
          name: AnnouncementView.routeName,
          page: () => const AnnouncementView(),
          binding: AnnouncementBinding(),
        ),
        GetPage(
          name: AnnouncementDetailView.routeName,
          page: () => const AnnouncementDetailView(),
        ),
        GetPage(
          name: HtmlView.routeName,
          page: () => const HtmlView(),
        ),
        GetPage(
          name: UpdateUsernameView.routeName,
          page: () => const UpdateUsernameView(),
          binding: UpdateUsernameBinding(),
        ),
        GetPage(
          name: UpdatePasswordView.routeName,
          page: () => const UpdatePasswordView(),
          binding: UpdatePasswordBinding(),
        ),
        GetPage(
          name: RemoveAccountView.routeName,
          page: () => const RemoveAccountView(),
          binding: RemoveAccountBinding(),
        ),
        GetPage(
          name: ContactView.routeName,
          page: () => const ContactView(),
          binding: ContactBinding(),
        ),
        GetPage(
          name: AllTodoLabelView.routeName,
          page: () => const AllTodoLabelView(),
          binding: AllTodoLabelBinding(),
        ),
        GetPage(
          name: EditTodoLabelView.routeName,
          page: () => const EditTodoLabelView(),
          binding: EditTodoLabelBinding(),
        ),
      ],
    );
  }
}
