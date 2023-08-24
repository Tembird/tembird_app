import 'package:flutter/material.dart';

class CellStyle {
  final int length;
  final String? text;
  final Color? color;

  CellStyle({
    required this.length,
    this.text,
    this.color,
  });
}