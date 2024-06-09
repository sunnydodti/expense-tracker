import 'dart:ui';

import 'package:flutter/material.dart';

class BlurScreen extends StatefulWidget {
  final bool animate;
  final VoidCallback? onTap;
  final Color color;
  final double colorOpacity;

  const BlurScreen(
      {super.key,
      this.animate = true,
      this.onTap,
      this.color = Colors.blue,
      this.colorOpacity = .01});

  @override
  State<BlurScreen> createState() => _BlurScreenState();
}

class _BlurScreenState extends State<BlurScreen> {
  late double blurSigmaX;
  late double blurSigmaY;

  double colorOpacity = 0;

  @override
  void initState() {
    super.initState();
    blurSigmaX = widget.animate ? 0 : 2;
    blurSigmaY = widget.animate ? 0 : 2;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.animate) animateBlur();
    animateColor();
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        color: widget.color.withOpacity(colorOpacity),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blurSigmaX,
            sigmaY: blurSigmaY,
          ),
          child: Container(),
        ),
      ),
    );
  }

  void animateBlur() async {
    while (blurSigmaX < 2) {
      await Future.delayed(const Duration(milliseconds: 50));
      if (mounted) {
        setState(() {
          blurSigmaX += .01;
          blurSigmaY += .01;
        });
      }
    }
  }

  void animateColor() async {
    while (colorOpacity < widget.colorOpacity) {
      await Future.delayed(const Duration(milliseconds: 50));
      if (mounted) {
        setState(() {
          colorOpacity += .001;
        });
      }
    }
  }
}
