import 'dart:ui';

import '../models/delete_input.dart';
import '../models/delete_output.dart';
import 'category_service.dart';
import 'expense_item_service.dart';
import 'expense_service.dart';
import 'tag_service.dart';

class DeleteService {
  static Future<DeleteOutput> deleteFromDatabase(DeleteInput deleteInput,
      {VoidCallback? refreshMethod}) async {
    ExpenseService expenseService = await ExpenseService.create();
    ExpenseItemService expenseItemService = await ExpenseItemService.create();
    CategoryService categoryService = await CategoryService.create();
    TagService tagService = await TagService.create();

    DeleteOutput deleteOutput = DeleteOutput();
    deleteOutput.expenses = deleteInput.deleteExpenses;
    deleteOutput.expenseItems = deleteInput.deleteExpenseItems;
    deleteOutput.categories = deleteInput.deleteCategories;
    deleteOutput.tags = deleteInput.deleteTags;

    if (deleteInput.deleteExpenses) {
      deleteOutput.expenseCount = await expenseService.deleteAllExpenses();
    }
    if (deleteInput.deleteExpenseItems) {
      deleteOutput.expenseItemsCount =
          await expenseItemService.deleteAllExpenseItems();
    }
    if (deleteInput.deleteCategories) {
      deleteOutput.categoriesCount =
          await categoryService.deleteAllCategories();
    }
    if (deleteInput.deleteTags) {
      deleteOutput.tagsCount = await tagService.deleteAllTags();
    }

    if (deleteOutput.totalDeletedCount > 0) {
      if (refreshMethod != null) refreshMethod();
    }

    return deleteOutput;
  }
}
