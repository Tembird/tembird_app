import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tembird_app/model/ActionResult.dart';
import 'package:tembird_app/model/DailyTodoLabel.dart';
import 'package:tembird_app/model/TodoLabel.dart';
import 'package:tembird_app/repository/TodoLabelRepository.dart';
import 'package:tembird_app/service/RootController.dart';
import 'package:tembird_app/view/home/controller/HomeController.dart';
import 'package:tembird_app/view/todoLabel/all/AllTodoLabelView.dart';

class SelectTodoLabelDialogController extends RootController {
  final double bannerAdWidth;
  final DateTime date;
  static SelectTodoLabelDialogController to = Get.find();

  SelectTodoLabelDialogController({required this.bannerAdWidth, required this.date});

  final TodoLabelRepository todoLabelRepository = TodoLabelRepository();

  final RxList<TodoLabel> todoLabelList = RxList([]);
  final RxBool onLoading = RxBool(false);

  @override
  void onInit() async {
    await Future.wait([
      initializeBannerAds(),
      getTodoLabelList(),
    ]);
    super.onInit();
  }

  @override
  void onClose() async {
    await disposeBannerAds();
    super.onClose();
  }

  Future<void> getTodoLabelList() async {
    if (onLoading.isTrue) return;
    try {
      onLoading.value = true;
      todoLabelList.clear();
      todoLabelList.value = await todoLabelRepository.readAllTodoLabel();
    } catch (e) {
      log(e.toString());
    } finally {
      todoLabelList.refresh();
      onLoading.value = false;
    }
  }

  void routeTodoLabelListView() async {
    Get.back(closeOverlays: true);
    bool? hasChanged = await Get.toNamed(AllTodoLabelView.routeName) as bool?;
    if (hasChanged == null || !hasChanged) return;

    await HomeController.to.getAllDailyTodoList(date: date);
  }

  void selectTodoLabel({required int index}) async {
    TodoLabel selectedTodoLabel = todoLabelList[index];
    DailyTodoLabel dailyTodoLabel = DailyTodoLabel(
      id: 0,
      labelId: selectedTodoLabel.id,
      title: selectedTodoLabel.title,
      colorHex: selectedTodoLabel.colorHex,
      date: dateToInt(date: date),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      todoList: [],
    );
    print(dailyTodoLabel.date);
    Get.back(result: dailyTodoLabel);
  }

  /// Banner Ad
  final Rxn<BannerAd> bannerAd = Rxn(null);

  Future<void> initializeBannerAds() async {
    final iosAppId = kReleaseMode ? FlutterConfig.get('IOS_ADMOB_ID_SELECT_TODO_LABEL_DIALOG') : FlutterConfig.get('DEV_AOS_ADMOB_ID_SELECT_TODO_LABEL_DIALOG');
    final aosAppId = kReleaseMode ? FlutterConfig.get('AOS_ADMOB_ID_SELECT_TODO_LABEL_DIALOG') : FlutterConfig.get('DEV_AOS_ADMOB_ID_SELECT_TODO_LABEL_DIALOG');

    bannerAd.value = BannerAd(
      adUnitId: Platform.isIOS ? iosAppId : aosAppId,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (Ad ad) => print('Ad loaded.'),
        // Called when an ad request failed.
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          // Dispose the ad here to free resources.
          ad.dispose();
          print('Ad failed to load: $error');
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) => print('Ad opened.'),
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) => print('Ad closed.'),
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) => print('Ad impression.'),
      ),
      request: const AdRequest(),
      size: AdSize.getCurrentOrientationInlineAdaptiveBannerAdSize(bannerAdWidth.toInt() - 64),
    );
    if (bannerAd.value == null) return;
    await bannerAd.value!.load();
  }

  Future<void> disposeBannerAds() async {
    if (bannerAd.value == null) return;
    await bannerAd.value!.dispose();
    bannerAd.value == null;
  }
}
