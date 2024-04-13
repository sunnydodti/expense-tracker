import 'package:flutter/material.dart';

class ExpandableListTile extends StatefulWidget {
  final String title;
  final Widget content;

  const ExpandableListTile({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  ExpandableListTileState createState() => ExpandableListTileState();
}

class ExpandableListTileState extends State<ExpandableListTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(widget.title),
      onExpansionChanged: (bool isExpanded) {
        setState(() {
          _isExpanded = isExpanded;
        });
      },
      initiallyExpanded: _isExpanded,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: widget.content,
        ),
      ],
    );
  }
}
