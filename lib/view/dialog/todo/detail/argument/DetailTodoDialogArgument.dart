import 'package:flutter/material.dart';

class DetailTodoDialogArgument {
  final double bannerAdWidth;
  final String labelTitle;
  final Color labelColor;
  final String title;
  final String? location;
  final String? detail;

  DetailTodoDialogArgument({
    required this.bannerAdWidth,
    required this.labelTitle,
    required this.labelColor,
    required this.title,
    required this.location,
    required this.detail,
  });
}
