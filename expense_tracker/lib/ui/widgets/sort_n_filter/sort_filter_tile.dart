import 'package:flutter/material.dart';

import 'filter_widget.dart';
import 'sort_widget.dart';

class SortFilterTile extends StatelessWidget {
  const SortFilterTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
      ),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          // _getTransactionsText(),
          FilterWidget(),
          SortWidget()
        ],
      ),
    );
  }

  Padding _getTransactionsText() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Text(
        'Transactions',
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 18,
        ),
      ),
    );
  }
}
