import 'package:flutter/material.dart';

class ExpenseTileWidgets {

  static Container expenseTile(Map<String, dynamic> expenseMap) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      // padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children:[
          Row(
            children: [
              ExpenseTileWidgets.titleWidget(expenseMap),
              ExpenseTileWidgets.categoryWidget(expenseMap),
            ],
          ),
          const SizedBox(height: 5.0),
          Row(
            children: [
              ExpenseTileWidgets.tagsWidget(expenseMap)
            ],
          ),
          const SizedBox(height: 5.0),
          Row(
            children: [
              ExpenseTileWidgets.noteWidget(expenseMap),
              ExpenseTileWidgets.amountWidget(expenseMap),
            ],
          )
        ],
      ),
    );
  }

  static Expanded titleWidget(Map<String, dynamic> expenseMap) {
    return Expanded(
      child: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: EdgeInsets.zero,
          child: Text(
            expenseMap['title'],
            style: const TextStyle(fontSize: 16.0),
          ),
        ),
      ),
    );
  }

  static Expanded categoryWidget(Map<String, dynamic> expenseMap) {
    return Expanded(
      child: Align(
        alignment: Alignment.topRight,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '${expenseMap['category']} ',
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
              const Icon(Icons.category_outlined,
                size: 20.0,)
            ]
        ),
      ),
    );
  }

  static Container tagsWidget(Map<String, dynamic> expenseMap) {
    Text tags;
    expenseMap['note'] == null
        ? tags = const Text("")
        : tags = Text(
      expenseMap['tags'],
      style: const TextStyle(fontSize: 10.0),
    );
    return Container(
        child: tags
    );
  }

  static Expanded noteWidget(Map<String, dynamic> expenseMap) {
    Text note;
    expenseMap['note'] == null
        ? note = const Text("")
        : note = Text(
      '${expenseMap['note']}',
      style: const TextStyle(fontSize: 13.5),
    );
    return Expanded(
      flex: 2,
      child: Align(
          alignment: Alignment.topLeft,
          child: FractionallySizedBox(
            widthFactor: 1,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.circular(5.0),
              ),
              padding: const EdgeInsets.all(5.0),
              child: Padding(
                padding: EdgeInsets.zero,
                child: note,
              ),
            ),
          )
      ),
    );
  }

  static Expanded amountWidget(Map<String, dynamic> expenseMap) {
    return Expanded(
      flex: 1,
      child: Align(
        alignment: Alignment.topRight,
        child: Text(
          '+ ${expenseMap["currency"]}${expenseMap["amount"]}',
          style: const TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}
