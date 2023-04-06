import 'package:get/get.dart';
import 'package:tembird_app/service/RootController.dart';

class CommonDialogController extends RootController {
  static CommonDialogController to = Get.find();

  /// Route
  void close() {
    Get.back();
  }

  /// BottomSheet
  double? y;

  void bottomSheetVerticalDragStart(double start) {
    y = start;
  }

  void bottomSheetVerticalDragCancel() {
    y = null;
  }

  void bottomSheetVerticalDragUpdate(double current) {
    if (y == null || current < (y! + 30)) return;
    close();
  }
}