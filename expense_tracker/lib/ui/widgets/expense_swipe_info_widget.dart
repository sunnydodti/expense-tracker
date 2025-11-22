import 'package:flutter/material.dart';

import '../../data/constants/ui_constants.dart';

class ExpenseSwipeInfoWidget extends StatelessWidget {
  const ExpenseSwipeInfoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const message = "to edit or delete";
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: uiPadding * 10),
      child: const Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Swipe', style: TextStyle(color: Colors.grey)),
            SizedBox(width: uiSize),
            Icon(Icons.compare_arrows, color: Colors.grey),
            SizedBox(width: uiSize),
            Text(message, style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
