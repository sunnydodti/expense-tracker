import 'dart:ui';

import 'package:flutter/material.dart';

class BlurScreen extends StatefulWidget {
  final bool animate;

  const BlurScreen({super.key, this.animate = true});

  @override
  State<BlurScreen> createState() => _BlurScreenState();
}

class _BlurScreenState extends State<BlurScreen> {
  late double blurSigmaX;
  late double blurSigmaY;

  @override
  void initState() {
    super.initState();
    blurSigmaX = widget.animate ? 0 : 2;
    blurSigmaY = widget.animate ? 0 : 2;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.animate) animateBlur();
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: blurSigmaX,
        sigmaY: blurSigmaY,
      ),
      child: Container(),
    );
  }

  void animateBlur() async {
    while (blurSigmaX < 2) {
      await Future.delayed(const Duration(milliseconds: 50));
      setState(() {
        blurSigmaX += .01;
        blurSigmaY += .01;
      });
    }
  }
}
