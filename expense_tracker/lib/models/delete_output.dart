class DeleteOutput {
  bool expenses = false;
  bool expenseItems = false;
  bool categories = false;
  bool tags = false;

  int expenseCount = 0;
  int expenseItemsCount = 0;
  int categoriesCount = 0;
  int tagsCount = 0;

  int _totalDeletedCount = -1;

  DeleteOutput();

  int get totalDeletedCount {
    if (_totalDeletedCount > -1) return _totalDeletedCount;
    _totalDeletedCount =
        expenseCount + expenseItemsCount + categoriesCount + tagsCount;
    return _totalDeletedCount;
  }
}
