import 'package:flutter/material.dart';

import '../../../data/constants/ui_constants.dart';

class ScaledText extends StatelessWidget {
  const ScaledText(
    this.data, {
    super.key,
    this.style,
    this.maxLines,
    this.overflow,
    this.textAlign,
  });

  final String data;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: style,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      textScaler: const TextScaler.linear(uiTextScaler),
    );
  }
}
