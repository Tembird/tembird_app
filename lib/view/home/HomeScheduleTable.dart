import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant/StyledFont.dart';
import '../../constant/StyledPalette.dart';
import '../../model/CellStyle.dart';
import 'controller/HomeController.dart';

class HomeScheduleTable extends GetView<HomeController> {
  const HomeScheduleTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double tableHeight = 1080;
    const double rowHeaderWidth = 32;
    final double tableWidth = controller.cellWidth * 6;
    final double cellWidth = controller.cellWidth;
    final double cellHeight = controller.cellHeight;
    return SizedBox(
      height: tableHeight,
      width: controller.tableWidth,
      child: Row(
        children: [
          SizedBox(
            width: rowHeaderWidth,
            height: tableHeight,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 24,
              itemBuilder: (context, index) => SizedBox(
                width: rowHeaderWidth,
                height: cellHeight,
                child: Center(
                  child: Text(
                    index.toString(),
                    textAlign: TextAlign.center,
                    style: StyledFont.FOOTNOTE,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTapDown: controller.onTableTapDown,
            onLongPressStart: controller.onTableLongPressStart,
            onLongPressMoveUpdate: controller.onTableLongPressMoveUpdate,
            onLongPressEnd: controller.onTableLongPressEnd,
            child: SizedBox(
              width: tableWidth,
              height: tableHeight,
              child: Column(
                children: List.generate(
                  24,
                  (rowIndex) => Container(
                    color: StyledPalette.MINERAL,
                    child: Stack(
                      children: [
                        Obx(
                          () => Row(
                            children: List.generate(
                              6,
                              (columnIndex) {
                                CellStyle cellStyle = controller.cellStyleList[rowIndex * 6 + columnIndex];
                                if (cellStyle.length == 0) {
                                  return Container();
                                }
                                return cellStyle.text == null
                                    ? Row(
                                        children: List.generate(
                                          cellStyle.length,
                                          (index) => Container(
                                            width: cellWidth,
                                            height: cellHeight,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: StyledPalette.BLACK10,
                                                width: 0.5,
                                                strokeAlign: StrokeAlign.center,
                                              ),
                                            ),
                                            padding: EdgeInsets.only(
                                              top: 2,
                                              bottom: 2,
                                              left: index == 0 ? 4 : 0,
                                              right: index == cellStyle.length - 1 ? 4 : 0,
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.horizontal(
                                                  left: index == 0 ? const Radius.circular(32) : Radius.zero,
                                                  right: index == cellStyle.length - 1 ? const Radius.circular(32) : Radius.zero,
                                                ),
                                                color: cellStyle.color,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Stack(
                                        children: [
                                          Row(
                                            children: List.generate(
                                              cellStyle.length,
                                              (index) => Container(
                                                width: cellWidth,
                                                height: cellHeight,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: StyledPalette.BLACK10,
                                                    width: 0.5,
                                                    strokeAlign: StrokeAlign.center,
                                                  ),
                                                ),
                                                padding: EdgeInsets.only(
                                                  top: 2,
                                                  bottom: 2,
                                                  left: index == 0 ? 4 : 0,
                                                  right: index == cellStyle.length - 1 ? 4 : 0,
                                                ),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.horizontal(
                                                      left: index == 0 ? const Radius.circular(32) : Radius.zero,
                                                      right: index == cellStyle.length - 1 ? const Radius.circular(32) : Radius.zero,
                                                    ),
                                                    color: cellStyle.color,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                            alignment: Alignment.center,
                                            width: cellWidth * cellStyle.length,
                                            height: cellHeight,
                                            child: Text(
                                              cellStyle.text!,
                                              style: StyledFont.FOOTNOTE_500,
                                              textAlign: TextAlign.center,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      );
                              },
                            ),
                          ),
                        ),
                        Obx(
                          () => controller.startIndex.value == null || controller.startIndex.value! + 1 > (rowIndex + 1) * 6 || (controller.endIndex.value! < rowIndex * 6)
                              ? Container()
                              : Row(
                                  children: List.generate(
                                    6,
                                    (index) => rowIndex * 6 + index < controller.startIndex.value! || rowIndex * 6 + index > controller.endIndex.value!
                                        ? SizedBox(
                                            width: cellWidth,
                                            height: cellHeight,
                                          )
                                        : Container(
                                            width: cellWidth,
                                            height: cellHeight,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: StyledPalette.BLACK10,
                                                width: 0.5,
                                                strokeAlign: StrokeAlign.center,
                                              ),
                                            ),
                                            padding: EdgeInsets.only(
                                              top: 2,
                                              bottom: 2,
                                              left: index == 0 || rowIndex * 6 + index == controller.startIndex.value ? 4 : 0,
                                              right: index == 5 || rowIndex * 6 + index == controller.endIndex.value ? 4 : 0,
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.horizontal(
                                                  left: index == 0 || rowIndex * 6 + index == controller.startIndex.value ? const Radius.circular(32) : Radius.zero,
                                                  right: index == 5 || rowIndex * 6 + index == controller.endIndex.value ? const Radius.circular(32) : Radius.zero,
                                                ),
                                                color: StyledPalette.STATUS_INFO_50,
                                              ),
                                            ),
                                          ),
                                  ),
                                ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
