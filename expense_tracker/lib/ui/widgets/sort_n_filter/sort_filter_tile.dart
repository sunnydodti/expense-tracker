import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/sort_filter_provider.dart';
import 'filter_widget.dart';
import 'sort_widget.dart';

class SortFilterTile extends StatefulWidget {
  const SortFilterTile({super.key});

  @override
  State<SortFilterTile> createState() => _SortFilterTileState();
}

class _SortFilterTileState extends State<SortFilterTile> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SortFilterProvider>(context, listen: false)
          .refreshPreferences(notify: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    double lerpT =
        Theme.of(context).colorScheme.brightness == Brightness.light ? .7 : .1;
    return Card(
      color: Color.lerp(
          Theme.of(context).colorScheme.primary, Colors.white, lerpT),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [FilterWidget(), SortWidget()],
      ),
    );
  }
}
