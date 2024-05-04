import 'package:flutter/material.dart';

class ScaleUp extends StatefulWidget {
  final Widget child;

  const ScaleUp({super.key, required this.child});

  @override
  State<ScaleUp> createState() => _ScaleUpState();
}

class _ScaleUpState extends State<ScaleUp> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 150));
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    return ScaleTransition(
      scale: _scaleAnimation,
      child: widget.child,
    );
  }
}
