import 'package:flutter/material.dart';

import '../sort_filter_widget.dart';

class TransactionsTile extends StatelessWidget {
  const TransactionsTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
      ),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_getTransactionsText(), const SortFilterWidget()],
      ),
    );
  }

  Text _getTransactionsText() {
    return const Text(
      'Transactions',
      style: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 18,
      ),
    );
  }
}
