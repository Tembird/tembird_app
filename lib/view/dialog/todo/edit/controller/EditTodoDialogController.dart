import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tembird_app/model/ActionResult.dart';
import 'package:tembird_app/model/DailyTodo.dart';
import 'package:tembird_app/model/DailyTodoLabel.dart';
import 'package:tembird_app/repository/DailyTodoLabelRepository.dart';
import 'package:tembird_app/repository/DailyTodoRepository.dart';
import 'package:tembird_app/service/RootController.dart';

import '../../../../../model/ModalAction.dart';
import '../../../todoLabel/select/SelectTodoLabelDialogView.dart';

class EditTodoDialogController extends RootController {
  final bool isNew;
  final double bannerAdWidth;
  final DailyTodoLabel initDailyTodoLabel;
  final DailyTodo? initDailyTodo;

  EditTodoDialogController({required this.isNew, required this.initDailyTodoLabel, this.initDailyTodo, required this.bannerAdWidth});

  static EditTodoDialogController to = Get.find();
  final DailyTodoLabelRepository dailyTodoLabelRepository = DailyTodoLabelRepository();
  final DailyTodoRepository dailyTodoRepository = DailyTodoRepository();
  final RxBool onLoading = RxBool(false);
  final RxBool onEditing = RxBool(false);

  final Rxn<DailyTodoLabel> dailyTodoLabel = Rxn(null);
  final Rxn<DailyTodo> dailyTodo = Rxn(null);

  final RxBool hasLocation = RxBool(false);
  final RxBool hasDetail = RxBool(false);

  final TextEditingController titleController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController detailController = TextEditingController();

  bool isChanged = false;

  @override
  void onInit() async {
    dailyTodoLabel.value = initDailyTodoLabel;
    if (!isNew) {
      dailyTodo.value = initDailyTodo!;
      titleController.text = initDailyTodo!.title!;
      if (initDailyTodo!.location != null) {
        locationController.text = initDailyTodo!.location!;
        hasLocation.value = true;
      }
      if (initDailyTodo!.detail != null) {
        detailController.text = initDailyTodo!.detail!;
        hasDetail.value = true;
      }
    } else {
      dailyTodo.value = DailyTodo(
        id: 0,
        title: '',
        status: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
    await initializeBannerAds();
    super.onInit();
  }

  @override
  void onClose() async {
    await disposeBannerAds();
    super.onClose();
  }

  void editDailyTodoLabel() async {
    hideKeyboard();

    await Future.delayed(const Duration(milliseconds: 50));

    DailyTodoLabel? newDailyTodoLabel = await Get.bottomSheet(
      SelectTodoLabelDialogView.route(),
      isScrollControlled: true,
      ignoreSafeArea: true,
      enableDrag: false,
    ) as DailyTodoLabel?;

    if (newDailyTodoLabel == null) return;

    dailyTodoLabel.value = newDailyTodoLabel;
  }

  void addContent() async {
    final List<ModalAction> modalActionList = [
      if (hasLocation.isFalse)
        ModalAction(
          name: '장소 추가',
          onPressed: addLocationForm,
          isNegative: false,
        ),
      if (hasDetail.isFalse)
        ModalAction(
          name: '상세 내용 추가',
          onPressed: addDetailForm,
          isNegative: false,
        ),
    ];
    await showCupertinoActionSheet(modalActionList: modalActionList, title: '다음 항목을 추가할 수 있습니다');
  }

  void addLocationForm() {
    onEditing();
    hasLocation.value = true;
    Get.back();
  }

  void addDetailForm() {
    onEditing();
    hasDetail.value = true;
    Get.back();
  }

  void onConfirm() async {
    if (onLoading.isTrue) return;
    try {
      onLoading.value = true;
      if (titleController.value.text.isEmpty) {
        showAlertDialog(message: '제목을 입력해주세요');
        return;
      }

      isChanged = dailyTodo.value!.title != titleController.value.text ||
          dailyTodo.value!.location != locationController.value.text ||
          dailyTodo.value!.detail != detailController.value.text;

      if (!isChanged) return;

      dailyTodo.value!.title = titleController.value.text;
      dailyTodo.value!.location = locationController.value.text.isEmpty ? null : locationController.value.text;
      dailyTodo.value!.detail = detailController.value.text.isEmpty ? null : detailController.value.text;

      if (!isChanged) {
        Get.back();
        return;
      }

      DailyTodoLabel? dailyTodoLabelResult;
      DailyTodo? dailyTodoResult;
      if (isNew) {
        dailyTodoLabelResult = await dailyTodoLabelRepository.createDailyTodoLabel(
          date: dailyTodoLabel.value!.date,
          labelId: dailyTodoLabel.value!.labelId,
        );
        dailyTodoResult = await dailyTodoRepository.createDailyTodo(
          title: dailyTodo.value!.title,
          dailyLabelId: dailyTodoLabelResult.id,
          location: dailyTodo.value!.location,
          detail: dailyTodo.value!.detail,
        );
        dailyTodoLabelResult.todoList.add(dailyTodoResult);
      } else {
        dailyTodoResult = await dailyTodoRepository.updateDailyTodoInfo(
          id: dailyTodo.value!.id,
          title: dailyTodo.value!.title,
          location: dailyTodo.value!.location,
          detail: dailyTodo.value!.detail,
        );
      }

      Get.back(
        result: ActionResult(
          action: isNew ? ActionResultType.created : ActionResultType.updated,
          dailyTodoLabel: dailyTodoLabelResult,
          dailyTodo: dailyTodoResult,
        ),
      );
    } catch (e) {
      log(e.toString());
      return;
    } finally {
      onLoading.value = false;
    }
  }

  /// Banner Ad
  final Rxn<BannerAd> bannerAd = Rxn(null);

  Future<void> initializeBannerAds() async {
    final iosAppId = kReleaseMode ? FlutterConfig.get('IOS_ADMOB_ID_EDIT_TODO_DIALOG') : FlutterConfig.get('DEV_IOS_ADMOB_ID_EDIT_TODO_DIALOG');
    final aosAppId = kReleaseMode ? FlutterConfig.get('AOS_ADMOB_ID_EDIT_TODO_DIALOG') : FlutterConfig.get('DEV_AOS_ADMOB_ID_EDIT_TODO_DIALOG');

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
