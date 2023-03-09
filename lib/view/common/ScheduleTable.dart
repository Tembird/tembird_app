import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tembird_app/constant/StyledFont.dart';
import 'package:tembird_app/constant/StyledPalette.dart';
import '../../../model/Schedule.dart';

const List<int> hourList = [4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 0, 1, 2, 3];

class ScheduleStartEndPoint {
  final Schedule schedule;
  final Point<int> startPoint;
  final Point<int> endPoint;

  ScheduleStartEndPoint({
    required this.schedule,
    required this.startPoint,
    required this.endPoint,
  });
}

class ScheduleTable extends StatefulWidget {
  final List<Schedule> scheduleList;
  final void Function(Schedule schedule) onTapSchedule;
  final void Function(List<Point<int>> pointList) onTapSelectedCell;
  final double width;
  final double? height;
  final double? rowHeaderWidth;
  final double? columnHeaderHeight;
  final bool showColumnHeader;

  const ScheduleTable({
    Key? key,
    required this.scheduleList,
    required this.onTapSchedule,
    required this.onTapSelectedCell,
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
  bool onLoading = true;
  List<Point<int>> unselectableCellList = [];
  List<Point<int>> selectedPointList = [];
  Point<int>? startPoint;
  Point<int> minUnselectablePoint = const Point(0, 24);
  Point<int>? endPoint;

  @override
  void initState() {
    setState(() {
      widget.scheduleList.forEach((schedule) => unselectableCellList.addAll(schedule.schedulePointList));
      onLoading = false;
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getMinUnselectablePoint(Point<int> point) {
    if (unselectableCellList.contains(point)) {
      minUnselectablePoint = point;
      return;
    }
    int minDistance = 144;
    for (int i = 0; i < unselectableCellList.length; i++) {
      Point<int> unselectablePoint = unselectableCellList[i];
      int distance = (unselectablePoint.y - point.y) * 6 + (unselectablePoint.x - point.x);
      if (distance > 0 && distance < minDistance) {
        minDistance = distance;
        minUnselectablePoint = unselectablePoint;
      }
    }
  }

  bool enablePoint(Point<int> point) {
    return ((minUnselectablePoint.y - point.y) * 6 + minUnselectablePoint.x - point.x) > 0;
  }

  Color? getCellColor(Point<int> point) {
    if (unselectableCellList.contains(point)) {
      String colorHex = widget.scheduleList.firstWhere((schedule) => schedule.schedulePointList.contains(point)).scheduleColorHex;
      return Color(int.parse(colorHex, radix: 16) + 0xFF000000);
    }
    return null;
  }

  Schedule? getCellSchedule({required Point<int> point}) {
    try {
      return widget.scheduleList.firstWhere((e) => e.schedulePointList.first == point);
    } catch (e) {
      return null;
    }
  }

  bool isCellSelected(Point<int> point) {
    if (startPoint == null || endPoint == null) {
      return false;
    }
    return ((point.y - startPoint!.y) * 6 + point.x - startPoint!.x) >= 0 && ((endPoint!.y - point.y) * 6 + endPoint!.x - point.x) >= 0;
  }

  Point<int> getPointFromPosition({required Offset position, required double cellHeight, required double cellWidth}) {
    final x = position.dx ~/ cellWidth;
    final y = position.dy ~/ cellHeight;
    return Point<int>(x, y);
  }

  void setSelectedPointList() {
    if (startPoint!.y == endPoint!.y) {
      for (int x = startPoint!.x; x < endPoint!.x + 1; x++) {
        selectedPointList.add(Point<int>(x, startPoint!.y));
      }
      return;
    }

    for (int x = startPoint!.x; x < 6; x++) {
      selectedPointList.add(Point<int>(x, startPoint!.y));
    }
    for (int y = startPoint!.y + 1; y < endPoint!.y; y++) {
      for (int x = 0; x < 6; x++) {
        selectedPointList.add(Point<int>(x, y));
      }
    }
    for (int x = 0; x < endPoint!.x + 1; x++) {
      selectedPointList.add(Point<int>(x, endPoint!.y));
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
    return onLoading
        ? Container(color: Colors.red)
        : SizedBox(
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
                          Point<int> selectedPoint = getPointFromPosition(position: details.localPosition, cellHeight: cellHeight, cellWidth: cellWidth);
                          if (selectedPointList.contains(selectedPoint)) {
                            widget.onTapSelectedCell(selectedPointList);
                            return;
                          }
                          if (endPoint != null) {
                            setState(() {
                              startPoint = null;
                              endPoint = null;
                              minUnselectablePoint = const Point(0, 24);
                              selectedPointList.clear();
                            });
                            return;
                          }
                          final int scheduleIndex = widget.scheduleList.indexWhere((schedule) => schedule.schedulePointList.contains(selectedPoint));
                          if (scheduleIndex == -1) return;

                          final Schedule schedule = widget.scheduleList[scheduleIndex];
                          widget.onTapSchedule(schedule);
                        },
                        onLongPressStart: (LongPressStartDetails details) {
                          selectedPointList.clear();
                          Point<int> selectedPoint = getPointFromPosition(position: details.localPosition, cellHeight: cellHeight, cellWidth: cellWidth);
                          getMinUnselectablePoint(selectedPoint);
                          if (!enablePoint(selectedPoint)) return;
                          setState(() {
                            startPoint = selectedPoint;
                            endPoint = null;
                          });
                        },
                        onLongPressMoveUpdate: (LongPressMoveUpdateDetails details) {
                          Point<int> selectedPoint = getPointFromPosition(position: details.localPosition, cellHeight: cellHeight, cellWidth: cellWidth);

                          setState(() {
                            if (startPoint == null || !enablePoint(selectedPoint)) {
                              return;
                            }
                            endPoint = selectedPoint;
                          });
                        },
                        onLongPressEnd: (LongPressEndDetails details) {
                          setState(() {
                            minUnselectablePoint = const Point(0, 24);
                            if (startPoint == null || endPoint == null) return;
                            setSelectedPointList();
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

      Schedule? schedule = getCellSchedule(point: Point<int>(columnIndex, rowIndex));

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
              color: getCellColor(Point<int>(columnIndex, rowIndex)) ??
                  (isCellSelected(Point<int>(columnIndex, rowIndex))
                      ? Colors.blue
                      : rowIndex < 14 && rowIndex > 1
                          ? StyledPalette.WHITE
                          : StyledPalette.BLACK10),
            ),
          ),
        );
        continue;
      }

      columnSpan = schedule.schedulePointList.where((element) => element.y == rowIndex).length;
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
                    schedule.scheduleName,
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
