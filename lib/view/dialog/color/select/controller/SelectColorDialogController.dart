import 'dart:developer';
import 'package:get/get.dart';
import 'package:tembird_app/constant/StyledPalette.dart';
import 'package:tembird_app/repository/ColorRepository.dart';
import 'package:tembird_app/service/RootController.dart';

class SelectColorDialogController extends RootController {
  final String? initColorHex;
  final ColorRepository colorRepository = ColorRepository();

  final RxList<String> colorHexList = RxList([]);
  final RxString selectedColorHex = RxString(StyledPalette.DEFAULT_COLOR_HEX);
  final RxBool onLoading = RxBool(false);

  SelectColorDialogController({required this.initColorHex});

  @override
  void onInit() async {
    if (initColorHex != null) {
      selectedColorHex.value = initColorHex!;
    }
    await getColorHexList();
    super.onInit();
  }

  @override
  void onClose() async {
    super.onClose();
  }

  Future<void> getColorHexList() async {
    if (onLoading.isTrue) return;
    try {
      onLoading.value = true;
      colorHexList.clear();
      colorHexList.value = await colorRepository.readAllColorHexList();
    } catch (e) {
      log(e.toString());
    } finally {
      colorHexList.refresh();
      onLoading.value = false;
    }
  }

  void selectColorHex({required String colorHex}) async {
    selectedColorHex.value = colorHex;
  }

  void save() async {
    Get.back(result: selectedColorHex.value == StyledPalette.DEFAULT_COLOR_HEX ? null : selectedColorHex.value);
  }
}
