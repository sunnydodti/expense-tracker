import 'dart:ui';

import 'package:flutter/material.dart';

class BlurScreen extends StatefulWidget {
  final bool animate;
  final VoidCallback? onTap;
  final Color color;
  final double colorOpacity;

  const BlurScreen({
    super.key,
    this.animate = true,
    this.onTap,
    this.color = Colors.blue,
    this.colorOpacity = 0.01,
  });

  @override
  State<BlurScreen> createState() => _BlurScreenState();
}

class _BlurScreenState extends State<BlurScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _blurAnimation;
  late Animation<double> _colorOpacityAnimation;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void initialize() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _blurAnimation = Tween<double>(begin: 0.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _colorOpacityAnimation =
        Tween<double>(begin: 0.0, end: widget.colorOpacity).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    if (widget.animate) {
      _controller.forward();
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            color: widget.color.withValues(alpha: _colorOpacityAnimation.value),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: _blurAnimation.value,
                sigmaY: _blurAnimation.value,
              ),
              child: const SizedBox.expand(),
            ),
          );
        },
      ),
    );
  }
}
