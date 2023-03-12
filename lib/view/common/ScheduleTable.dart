import 'package:flutter/material.dart';
import 'package:tembird_app/constant/StyledFont.dart';
import 'package:tembird_app/constant/StyledPalette.dart';
import '../../../model/Schedule.dart';

const List<int> hourList = [4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 0, 1, 2, 3];

class ScheduleTable extends StatefulWidget {
  final List<Schedule> scheduleList;
  final void Function(Schedule schedule) onTapSchedule;
  final void Function(List<int> indexList) onTapSelected;
  final double width;
  final double? height;
  final double? rowHeaderWidth;
  final double? columnHeaderHeight;
  final bool showColumnHeader;

  const ScheduleTable({
    Key? key,
    required this.scheduleList,
    required this.onTapSchedule,
    required this.onTapSelected,
    required this.width,
    this.height,
    this.rowHeaderWidth,
    this.columnHeaderHeight,
    required this.showColumnHeader,
  }) : super(key: key);

  @override
  State<ScheduleTable> createState() => _ScheduleTableState();
}

class _ScheduleTableState extends State<ScheduleTable> {
  List<int> unselectableIndexList = [];
  List<int> selectedIndexList = [];
  int? startIndex;
  int minUnselectableIndex = 144;
  int? endIndex;

  @override
  void initState() {
    setState(() {
      widget.scheduleList.forEach((schedule) => unselectableIndexList.addAll(schedule.scheduleIndexList));
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getMinUnselectableIndex(int currentIndex) {
    if (unselectableIndexList.contains(currentIndex)) {
      minUnselectableIndex = currentIndex;
      return;
    }
    int minDistance = 144;
    for (int i = 0; i < unselectableIndexList.length; i++) {
      int unselectableIndex = unselectableIndexList[i];
      int distance = unselectableIndex - currentIndex;
      if (distance > 0 && distance < minDistance) {
        minDistance = distance;
        minUnselectableIndex = unselectableIndex;
      }
    }
  }

  bool isEnableIndex(int index) {
    return (minUnselectableIndex - index) > 0;
  }

  Color? getIndexColor(int index) {
    if (unselectableIndexList.contains(index)) {
      String colorHex = widget.scheduleList.firstWhere((schedule) => schedule.scheduleIndexList.contains(index)).scheduleColorHex;
      return Color(int.parse(colorHex, radix: 16) + 0xFF000000);
    }
    return null;
  }

  Schedule? getIndexSchedule(int index) {
    try {
      return widget.scheduleList.firstWhere((schedule) => schedule.scheduleIndexList.first == index);
    } catch (e) {
      return null;
    }
  }

  bool isSelectedIndex(int index) {
    if (startIndex == null || endIndex == null) {
      return false;
    }
    return !(index - startIndex!).isNegative && !(endIndex! - index).isNegative;
  }

  int getIndexFromPosition({required Offset position, required double cellHeight, required double cellWidth}) {
    final int x = position.dx ~/ cellWidth;
    final int y = position.dy ~/ cellHeight;
    return (x + 6 * y);
  }

  void setSelectedIndexList() {
    for (int index = startIndex! ; index < endIndex! + 1 ; index++) {
      selectedIndexList.add(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = widget.height ?? 1172;
    final double rowHeaderWidth = widget.rowHeaderWidth ?? 32;
    final double columnHeaderHeight = widget.columnHeaderHeight ?? 20;
    final double tableHeight = widget.showColumnHeader ? height - columnHeaderHeight : height;
    final double tableWidth = widget.width - rowHeaderWidth;
    final double cellWidth = tableWidth / 6;
    final double cellHeight = tableHeight / 24;
    return SizedBox(
      height: height,
      width: widget.width,
      child: Column(
        children: [
          if (widget.showColumnHeader)
            Container(
              color: StyledPalette.MINERAL,
              child: SizedBox(
                width: widget.width,
                height: columnHeaderHeight,
                child: Row(
                  children: [
                    SizedBox(
                      width: rowHeaderWidth,
                      height: columnHeaderHeight,
                      child: const Center(child: Text('시/분', style: StyledFont.CAPTION_2)),
                    ),
                    SizedBox(
                      width: tableWidth,
                      height: columnHeaderHeight,
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: 6,
                        itemBuilder: (context, index) => Container(
                          width: cellWidth,
                          height: columnHeaderHeight,
                          child: Center(
                            child: Text(
                              '${index * 10}',
                              textAlign: TextAlign.center,
                              style: StyledFont.FOOTNOTE,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          SizedBox(
            width: widget.width,
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
                          hourList[index].toString(),
                          textAlign: TextAlign.center,
                          style: StyledFont.FOOTNOTE,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTapDown: (TapDownDetails details) {
                    int selectedIndex = getIndexFromPosition(position: details.localPosition, cellHeight: cellHeight, cellWidth: cellWidth);
                    if (selectedIndexList.contains(selectedIndex)) {
                      widget.onTapSelected(selectedIndexList);
                      return;
                    }
                    if (endIndex != null) {
                      setState(() {
                        startIndex = null;
                        endIndex = null;
                        minUnselectableIndex = 144;
                        selectedIndexList.clear();
                      });
                      return;
                    }
                    final int scheduleIndex = widget.scheduleList.indexWhere((schedule) => schedule.scheduleIndexList.contains(selectedIndex));
                    if (scheduleIndex == -1) return;

                    final Schedule schedule = widget.scheduleList[scheduleIndex];
                    widget.onTapSchedule(schedule);
                  },
                  onLongPressStart: (LongPressStartDetails details) {
                    selectedIndexList.clear();
                    int selectedIndex = getIndexFromPosition(position: details.localPosition, cellHeight: cellHeight, cellWidth: cellWidth);
                    getMinUnselectableIndex(selectedIndex);
                    if (!isEnableIndex(selectedIndex)) return;
                    setState(() {
                      startIndex = selectedIndex;
                      endIndex = null;
                    });
                  },
                  onLongPressMoveUpdate: (LongPressMoveUpdateDetails details) {
                    int selectedIndex = getIndexFromPosition(position: details.localPosition, cellHeight: cellHeight, cellWidth: cellWidth);

                    setState(() {
                      if (startIndex == null || !isEnableIndex(selectedIndex)) {
                        return;
                      }
                      endIndex = selectedIndex;
                    });
                  },
                  onLongPressEnd: (LongPressEndDetails details) {
                    setState(() {
                      minUnselectableIndex = 144;
                      if (startIndex == null || endIndex == null) return;
                      setSelectedIndexList();
                    });
                  },
                  child: SizedBox(
                    width: tableWidth,
                    height: tableHeight,
                    child: Column(
                      children: List.generate(24, (rowIndex) {
                        return Row(
                          children: _buildTableRow(rowIndex: rowIndex, cellWidth: cellWidth, cellHeight: cellHeight),
                        );
                      }),
                    ),
                  ),
                ),
              ],
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
      if (columnSpan > 0) {
        columnSpan--;
        tableRow.add(SizedBox(width: 0, height: cellHeight));
        continue;
      }

      Schedule? schedule = getIndexSchedule(rowIndex * 6 + columnIndex);

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
              color: getIndexColor(rowIndex * 6 + columnIndex) ??
                  (isSelectedIndex(rowIndex * 6 + columnIndex)
                      ? Colors.blue
                      : rowIndex < 14 && rowIndex > 1
                          ? StyledPalette.WHITE
                          : StyledPalette.BLACK10),
            ),
          ),
        );
        continue;
      }

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
                    schedule.scheduleTitle??'제목 없음',
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
