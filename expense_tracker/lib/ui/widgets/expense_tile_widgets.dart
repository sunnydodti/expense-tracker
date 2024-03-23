import 'package:expense_tracker/data/db_constants/DBExpenseTableConstants.dart';
import 'package:expense_tracker/models/transaction_type.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseTileWidgets {

  static Container expenseTile(Map<String, dynamic> expenseMap) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        children:[
          Row(
            children: [
              titleWidget(expenseMap),
              categoryWidget(expenseMap),
              getExpenseDate(expenseMap)
            ],
          ),
          const SizedBox(height: 5.0),
          Row(
            children: [
              tagsWidget(expenseMap)
            ],
          ),
          const SizedBox(height: 5.0),
          Row(
            children: [
              noteWidget(expenseMap),
              amountWidget(expenseMap),
            ],
          )
        ],
      ),
    );
  }

  static Expanded getExpenseDate(Map<String, dynamic> expenseMap) {
    return Expanded(
      child: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: EdgeInsets.zero,
          child: Text(
            DateFormat('dd-MM-yy').format(DateTime.parse(expenseMap[DBExpenseTableConstants.expenseColDate])),
            style: const TextStyle(fontSize: 16.0),
          ),
        ),
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
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.only(right: 0.0),
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
        )
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
    (expenseMap['note'] == null || expenseMap['note'] == "")
        ? note = const Text(
          "Add Notes",
          style: TextStyle(
              fontSize: 13.5,
              color: Colors.grey
          ),
        )
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
        child: _getAmount(expenseMap),
      ),
    );
  }

  static Align _getAmount(Map<String, dynamic> expenseMap) {
    String transactionType = expenseMap[DBExpenseTableConstants.expenseColTransactionType];
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 45.0),
        child: Text(
          _getAmountText(expenseMap),
          style: TextStyle(
            fontSize: 16.0,
            color: _getAmountColor(transactionType),
          ),
        ),
      )
    );
  }

  static String _getAmountText(Map<String, dynamic> expenseMap) {
    String amountText = "${expenseMap[DBExpenseTableConstants.expenseColCurrency]}"
        "${expenseMap[DBExpenseTableConstants.expenseColAmount]}";
    amountText = (expenseMap[DBExpenseTableConstants.expenseColTransactionType] == TransactionType.expense.name)
      ? "- $amountText"
      : "+ $amountText";
    return amountText;
  }
  static Color _getAmountColor(String transactionType){
      if (transactionType == TransactionType.expense.name) return Colors.red.shade300;
      if (transactionType == TransactionType.income.name) return Colors.green.shade300;
      return Colors.white;
    }
  }