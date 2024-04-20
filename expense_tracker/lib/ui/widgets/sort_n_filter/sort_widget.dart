import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/enums/sort_criteria.dart';
import '../../../providers/expense_provider.dart';
import '../../../providers/sort_filter_provider.dart';

class SortWidget extends StatefulWidget {
  const SortWidget({super.key});

  @override
  State<SortWidget> createState() => _SortWidgetState();
}

class _SortWidgetState extends State<SortWidget> {
  _refreshExpenses() {
    final expenseProvider =
        Provider.of<ExpenseProvider>(context, listen: false);
    expenseProvider.refreshExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SortFilterProvider>(
      builder: (context, sortFilterProvider, _) {
        return Row(
          children: [
            _buildSortCriteriaDropdown(sortFilterProvider),
            _buildSortButton(sortFilterProvider),
          ],
        );
      },
    );
  }

  IconButton _buildSortButton(SortFilterProvider sortFilterProvider) {
    return IconButton(
      icon: Transform(
          alignment: Alignment.center,
          transform: sortFilterProvider.isAscendingSort
              ? Matrix4.rotationX(math.pi)
              : Matrix4.rotationX(0),
          child: Transform.rotate(
            angle: math.pi,
            child: const Icon(
              Icons.sort_outlined,
            ),
          )),
      onPressed: () {
        sortFilterProvider.toggleSort();
        _refreshExpenses();
      },
      tooltip: "Sort",
    );
  }

  DropdownButton<SortCriteria> _buildSortCriteriaDropdown(
      SortFilterProvider sortFilterProvider) {
    return DropdownButton<SortCriteria>(
      // icon: SizedBox.shrink(),
      value: sortFilterProvider.sortCriteria,
      onChanged: (criteria) {
        updateSortCriteria(sortFilterProvider, criteria);
      },
      items: SortCriteria.values
          .map<DropdownMenuItem<SortCriteria>>(
            (criteria) => DropdownMenuItem<SortCriteria>(
              value: criteria,
              child: Text(
                  textScaleFactor: .9,
                  SortCriteriaHelper.getSortCriteriaText(criteria)),
            ),
          )
          .toList(),
      underline: Container(),
    );
  }

  void updateSortCriteria(
      SortFilterProvider sortFilterProvider, SortCriteria? criteria) {
    if (criteria! != sortFilterProvider.sortCriteria) {
      sortFilterProvider.setSortCriteria(criteria!);
      _refreshExpenses();
    }
  }
}
