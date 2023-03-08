import 'dart:math';
import 'package:flutter/material.dart';
import '../../../model/Schedule.dart';

class ScheduleTable extends StatefulWidget {
  final List<Schedule> scheduleList;
  final void Function(Schedule schedule) onTapSchedule;
  final void Function(List<Point<int>> pointList) onTapSelectedCell;

  const ScheduleTable({Key? key, required this.scheduleList, required this.onTapSchedule, required this.onTapSelectedCell}) : super(key: key);

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
      for(int x = startPoint!.x; x < endPoint!.x + 1; x++) {
        selectedPointList.add(Point<int>(x, startPoint!.y));
      }
      return;
    }

    for(int x = startPoint!.x; x < 6; x++) {
      selectedPointList.add(Point<int>(x, startPoint!.y));
    }
    for(int y = startPoint!.y + 1; y < endPoint!.y; y++) {
      for(int x = 0; x < 6; x++) {
        selectedPointList.add(Point<int>(x, y));
      }
    }
    for(int x = 0; x < endPoint!.x + 1; x++) {
      selectedPointList.add(Point<int>(x, endPoint!.y));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cellWidth = MediaQuery.of(context).size.width / 6;
    final cellHeight = MediaQuery.of(context).size.height / 24;
    return onLoading ? Container(color: Colors.red,) : GestureDetector(
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
      child: Table(
        children: List.generate(24, (rowIndex) {
          return TableRow(
            children: List.generate(6, (columnIndex) {
              return Container(
                width: cellWidth,
                height: cellHeight,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  color: getCellColor(Point<int>(columnIndex, rowIndex)) ?? (isCellSelected(Point<int>(columnIndex, rowIndex)) ? Colors.blue : Colors.white),
                ),
              );
            }),
          );
        }),
      ),
    );
  }
}
