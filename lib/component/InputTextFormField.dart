import 'package:flutter/material.dart';
import 'package:tembird_app/constant/StyledFont.dart';
import 'package:tembird_app/constant/StyledPalette.dart';

class InputTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final String? errorText;
  final Widget? suffixWidget;
  final bool? isObscured;
  final bool? enabled;
  final TextInputAction? textInputAction;
  final void Function(String?)? onChanged;
  final void Function(String?)? onFieldSubmitted;
  final TextInputType? keyboardType;
  final int? maxLength;
  final int? maxLines;

  const InputTextFormField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.errorText,
    this.suffixWidget,
    this.isObscured,
    this.enabled,
    this.textInputAction,
    this.keyboardType,
    this.onChanged,
    this.onFieldSubmitted,
    this.maxLength,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (controller.value.text.isNotEmpty)
          Text(labelText, style: StyledFont.CALLOUT_700_BLACK50),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.never,
            hintText: hintText,
            hintMaxLines: 1,
            hintStyle: StyledFont.BODY_GRAY,
            errorText: errorText,
            errorMaxLines: 1,
            errorStyle: StyledFont.FOOTNOTE_NEGATIVE,
            border: const UnderlineInputBorder(
              borderSide: BorderSide(color: StyledPalette.GRAY, width: 1),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: StyledPalette.GRAY, width: 1),
            ),
            disabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: StyledPalette.GRAY, width: 1),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: StyledPalette.GRAY, width: 1),
            ),
            errorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: StyledPalette.STATUS_NEGATIVE, width: 1),
            ),
            focusedErrorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: StyledPalette.STATUS_NEGATIVE, width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            suffix: suffixWidget,
            isDense: true,
            enabled: enabled ?? true,
          ),
          style: StyledFont.BODY,
          obscureText: isObscured ?? false,
          maxLength: maxLength,
          textAlign: TextAlign.start,
          textAlignVertical: TextAlignVertical.center,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
          maxLines: maxLines ?? 1,
        ),
      ],
    );
  }
}
