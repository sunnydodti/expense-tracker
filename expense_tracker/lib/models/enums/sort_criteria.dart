enum SortCriteria { modifiedDate, createdDate, expenseDate }

class SortCriteriaHelper {

  static String getSortCriteriaText(SortCriteria criteria) {
    switch (criteria) {
      case SortCriteria.modifiedDate:
        return 'Modified';
      case SortCriteria.createdDate:
        return 'Created';
      case SortCriteria.expenseDate:
        return 'Date';
    }
  }

  static SortCriteria getSortCriteriaByName(String name){
    return SortCriteria.values.byName(name);
  }
}