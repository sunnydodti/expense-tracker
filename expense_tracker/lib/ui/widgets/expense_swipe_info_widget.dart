import 'package:flutter/material.dart';

class ExpenseSwipeInfoWidget extends StatelessWidget {
  const ExpenseSwipeInfoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const message = "to edit or delete";
    return Padding(
      padding: const EdgeInsets.only(bottom: 100),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text(
              'Swipe',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(width: 8),
            Icon(
              Icons.compare_arrows,
              color: Colors.grey,
            ),
            SizedBox(width: 8),
            Text(
              message,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
