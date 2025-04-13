import 'package:flutter/material.dart';

class ContentAreaNavigation extends StatefulWidget {
  final Widget defaultContent;

  const ContentAreaNavigation({
    Key? key,
    required this.defaultContent,
  }) : super(key: key);

  @override
  State<ContentAreaNavigation> createState() => ContentAreaNavigationState();
}

class ContentAreaNavigationState extends State<ContentAreaNavigation> {
  late Widget _currentContent;
  final List<Widget> _navigationStack = [];

  @override
  void initState() {
    super.initState();
    _currentContent = widget.defaultContent;
  }

  void pushContent(Widget content) {
    setState(() {
      _navigationStack.add(_currentContent);
      _currentContent = content;
    });
  }

  bool popContent() {
    if (_navigationStack.isEmpty) return false;

    setState(() {
      _currentContent = _navigationStack.removeLast();
    });
    return true;
  }

  bool canPop() => _navigationStack.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: _currentContent,
      ),
    );
  }
}
