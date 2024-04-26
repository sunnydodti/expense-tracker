enum SortCriteria { modifiedDate, createdDate, expenseDate, expenseAmount }

class SortCriteriaHelper {
  static String getSortCriteriaText(SortCriteria criteria) {
    switch (criteria) {
      case SortCriteria.modifiedDate:
        return 'Modified';
      case SortCriteria.createdDate:
        return 'Created';
      case SortCriteria.expenseDate:
        return 'Date';
      case SortCriteria.expenseAmount:
        return 'Amount';
    }
  }

  static SortCriteria getSortCriteriaByName(String name) {
    return SortCriteria.values.byName(name);
  }
}
