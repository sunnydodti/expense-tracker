import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/enums/sort_criteria.dart';
import '../../providers/expense_provider.dart';
import '../../providers/sort_filter_provider.dart';

class SortFilterWidget extends StatefulWidget {
  const SortFilterWidget({super.key});

  @override
  State<SortFilterWidget> createState() => _SortFilterWidgetState();
}

class _SortFilterWidgetState extends State<SortFilterWidget> {
  _refreshExpenses() {
    final expenseProvider =
        Provider.of<ExpenseProvider>(context, listen: false);
    expenseProvider.refreshExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SortFilterProvider>(
      builder: (context, sortFilterProvider, _) => Row(
        children: [
          getSortButton(sortFilterProvider),
          getSortCriteriaDropdown(sortFilterProvider),
          getFilterButton(),
        ],
      ),
    );
  }

  IconButton getFilterButton() {
    return IconButton(
      icon: const Icon(Icons.filter_list),
      onPressed: () {},
      tooltip: "Filter",
    );
  }

  IconButton getSortButton(SortFilterProvider sortFilterProvider) {
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

  DropdownButton<SortCriteria> getSortCriteriaDropdown(
      SortFilterProvider sortFilterProvider) {
    return DropdownButton<SortCriteria>(
      value: sortFilterProvider.sortCriteria,
      onChanged: (criteria) {
        sortFilterProvider.setSortCriteria(criteria!);
        _refreshExpenses();
      },
      items: SortCriteria.values
          .map<DropdownMenuItem<SortCriteria>>(
            (criteria) => DropdownMenuItem<SortCriteria>(
              value: criteria,
              child: Text(_getSortCriteriaText(criteria)),
            ),
          )
          .toList(),
      underline: Container(),
    );
  }

  String _getSortCriteriaText(SortCriteria criteria) {
    switch (criteria) {
      case SortCriteria.modifiedDate:
        return 'Modified';
      case SortCriteria.createdDate:
        return 'Created';
      case SortCriteria.expenseDate:
        return 'Date';
    }
  }
}
