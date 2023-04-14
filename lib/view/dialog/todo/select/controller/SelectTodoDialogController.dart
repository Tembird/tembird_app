import 'package:get/get.dart';
import 'package:tembird_app/model/ActionResult.dart';
import 'package:tembird_app/model/DailyTodoLabel.dart';
import 'package:tembird_app/repository/DailyTodoRepository.dart';
import 'package:tembird_app/service/RootController.dart';

class SelectTodoDialogResult {
  final int dailyTodoLabelIndex;
  final int dailyTodoIndex;

  SelectTodoDialogResult({
    required this.dailyTodoLabelIndex,
    required this.dailyTodoIndex,
  });
}

class SelectTodoDialogController extends RootController {
  final List<DailyTodoLabel> dailyTodoLabelList;
  final DailyTodoRepository dailyTodoRepository = DailyTodoRepository();
  final int startAt;
  final int endAt;
  bool onLoading = false;

  SelectTodoDialogController({required this.dailyTodoLabelList, required this.startAt, required this.endAt});

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onClose() async {
    super.onClose();
  }

  void updateSelectedDailyTodoDuration({required int dailyTodoLabelIndex, required int dailyTodoIndex}) async {
    try {
      onLoading = true;
      await dailyTodoRepository.updateDailyTodoDuration(
        id: dailyTodoLabelList[dailyTodoLabelIndex].todoList[dailyTodoIndex].id,
        startAt: startAt,
        endAt: endAt,
      );
      dailyTodoLabelList[dailyTodoLabelIndex].todoList[dailyTodoIndex].startAt = startAt;
      dailyTodoLabelList[dailyTodoLabelIndex].todoList[dailyTodoIndex].endAt = endAt;
      Get.back(
        result: ActionResult(
          action: ActionResultType.updated,
          dailyTodoLabelIndex: dailyTodoLabelIndex,
          dailyTodoIndex: dailyTodoIndex,
        ),
      );
    } finally {
      onLoading = false;
    }
  }
}
