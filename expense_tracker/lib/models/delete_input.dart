class DeleteInput {
  bool deleteExpenses = false;
  bool deleteExpenseItems = false;
  bool deleteCategories = false;
  bool deleteTags = false;

  DeleteInput(
      {required this.deleteExpenses,
      required this.deleteExpenseItems,
      required this.deleteCategories,
      required this.deleteTags});
}
