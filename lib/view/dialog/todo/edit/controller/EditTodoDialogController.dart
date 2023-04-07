import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tembird_app/model/Todo.dart';
import 'package:tembird_app/model/TodoLabel.dart';
import 'package:tembird_app/repository/TodoRepository.dart';
import 'package:tembird_app/service/RootController.dart';

import '../../../../../model/ModalAction.dart';
import '../../../todoLabel/select/SelectTodoLabelDialogView.dart';

class EditTodoDialogController extends RootController {
  final bool isNew;
  final double bannerAdWidth;
  final TodoLabel initTodoLabel;

  EditTodoDialogController({required this.isNew, required this.initTodoLabel, required this.bannerAdWidth});

  static EditTodoDialogController to = Get.find();
  final TodoRepository todoRepository = TodoRepository();
  final RxBool onLoading = RxBool(true);
  final RxBool onEditing = RxBool(false);

  final Rxn<TodoLabel> todoLabel = Rxn(null);

  final RxBool hasLocation = RxBool(false);
  final RxBool hasDetail = RxBool(false);

  final TextEditingController titleEditingController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController detailController = TextEditingController();

  final Rxn<Todo> resultTodo = Rxn(null);

  @override
  void onInit() async {
    todoLabel.value = initTodoLabel;
    if (isNew) {
      await initializeBannerAds();
      return;
    }
    await Future.wait([
      // Todo : Read TodoDetail to Edit
      initializeBannerAds(),
    ]);
    super.onInit();
  }

  @override
  void onClose() async {
    await disposeBannerAds();
    super.onClose();
  }

  void editTodoLabel() async {
    hideKeyboard();

    await Future.delayed(const Duration(milliseconds: 50));

    TodoLabel? selectedTodoLabel = await Get.bottomSheet(
      SelectTodoLabelDialogView.route(),
      isScrollControlled: true,
      ignoreSafeArea: true,
      enableDrag: false,
    ) as TodoLabel?;

    if (selectedTodoLabel == null) return;

    todoLabel.value = selectedTodoLabel;
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
    // TODO : 완료 시 저장 구현
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
