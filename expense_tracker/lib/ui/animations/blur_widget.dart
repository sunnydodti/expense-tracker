import 'dart:ui';

import 'package:flutter/material.dart';

class BlurWidget extends StatefulWidget {
  final Widget widget;
  final double blur;
  final bool animate;

  const BlurWidget(
      {super.key, required this.widget, this.blur = 2.5, this.animate = true});

  @override
  State<BlurWidget> createState() => _BlurWidgetState();
}

class _BlurWidgetState extends State<BlurWidget> {
  late double blurSigmaX;
  late double blurSigmaY;

  @override
  void initState() {
    super.initState();
    blurSigmaX = widget.animate ? 0 : widget.blur;
    blurSigmaY = widget.animate ? 0 : widget.blur;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.animate) animateBlur();
    return ClipRect(
      child: Stack(
        children: [
          Center(child: widget.widget),
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: blurSigmaX,
              sigmaY: blurSigmaY,
            ),
            child: Container(
              color: Colors.transparent,
            ),
          )
        ],
      ),
    );
  }

  void animateBlur() async {
    while (blurSigmaX < widget.blur) {
      await Future.delayed(const Duration(milliseconds: 50));
      if (mounted) {
        setState(() {
          blurSigmaX += 3;
          blurSigmaY += 3;
        });
      }
    }
  }
}
