import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant/StyledFont.dart';
import '../../constant/StyledPalette.dart';
import '../../model/Schedule.dart';
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
      child: Row(
        children: [
          SizedBox(
            width: rowHeaderWidth,
            height: tableHeight,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 24,
              itemBuilder: (context, index) => Container(
                width: rowHeaderWidth,
                height: cellHeight,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: index < 14 && index > 1 ? StyledPalette.ACCENT_YELLOW : StyledPalette.ACCENT_LAVENDER,
                      width: 5,
                    ),
                  ),
                  color: StyledPalette.MINERAL,
                ),
                child: Center(
                  child: Text(
                    controller.hourList[index].toString(),
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
                    color: rowIndex < 1 || rowIndex > 14 ? StyledPalette.BLACK50 : StyledPalette.MINERAL,
                    child: Obx(
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
                                            color: StyledPalette.MINERAL,
                                            width: 0.5,
                                            strokeAlign: StrokeAlign.center,
                                          ),
                                          color: cellStyle.color,
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
                                                color: StyledPalette.MINERAL,
                                                width: 0.5,
                                                strokeAlign: StrokeAlign.center,
                                              ),
                                              color: cellStyle.color,
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (cellStyle.text != null)
                                        SizedBox(
                                          width: cellWidth * cellStyle.length,
                                          height: cellHeight,
                                          child: Center(
                                            child: Text(
                                              cellStyle.text!,
                                              style: StyledFont.CALLOUT_700_WHITE,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        )
                                    ],
                                  );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // child: Column(
              //   children: List.generate(24, (rowIndex) {
              //     return Obx(() => Row(
              //       children: _buildTableRow(rowIndex: rowIndex, cellWidth: cellWidth, cellHeight: cellHeight),
              //     ));
              //   }),
              // ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildTableRow({required int rowIndex, required double cellWidth, required double cellHeight}) {
    List<Widget> tableRow = [];
    int columnSpan = 0;

    for (int columnIndex = 0; columnIndex < 6; columnIndex++) {
      if (columnSpan > 1) {
        columnSpan--;
        tableRow.add(SizedBox(width: 0, height: cellHeight));
        continue;
      }

      Schedule? schedule = controller.getIndexSchedule(rowIndex * 6 + columnIndex);

      if (schedule == null) {
        tableRow.add(
          Container(
            width: cellWidth,
            height: cellHeight,
            decoration: BoxDecoration(
              border: Border.all(
                color: StyledPalette.MINERAL,
                width: 0.5,
                strokeAlign: StrokeAlign.center,
              ),
              color: controller.getIndexColor(rowIndex * 6 + columnIndex) ??
                  (controller.isSelectedIndex(rowIndex * 6 + columnIndex)
                      ? Colors.blue
                      : rowIndex < 14 && rowIndex > 1
                          ? StyledPalette.WHITE
                          : StyledPalette.BLACK10),
            ),
          ),
        );
        continue;
      }
      print('=========> schedule.scheduleIndexList');
      print(schedule.scheduleIndexList);
      columnSpan = schedule.scheduleIndexList.where((schedule) => schedule ~/ 6 == rowIndex).length;
      Color scheduleColor = Color(int.parse(schedule.scheduleColorHex, radix: 16) + 0xFF000000);
      tableRow.add(
        SizedBox(
          width: cellWidth * columnSpan,
          height: cellHeight,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: cellWidth * columnSpan,
                height: cellHeight,
                child: Row(
                  children: List.generate(
                    columnSpan,
                    (index) => Container(
                      width: cellWidth,
                      height: cellHeight,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: StyledPalette.MINERAL,
                          width: 0.5,
                          strokeAlign: StrokeAlign.center,
                        ),
                        color: scheduleColor,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: cellWidth * columnSpan,
                height: cellHeight,
                child: Center(
                  child: Text(
                    schedule.scheduleTitle ?? '제목 없음',
                    style: StyledFont.CALLOUT_700_WHITE,
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }

    return tableRow;
  }
}
