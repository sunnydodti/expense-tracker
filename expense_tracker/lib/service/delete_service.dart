import 'dart:ui';

import '../models/delete_input.dart';
import 'category_service.dart';
import 'expense_item_service.dart';
import 'expense_service.dart';
import 'tag_service.dart';

class DeleteService {
  static Future<int> deleteFromDatabase(DeleteInput deleteInput,
      {VoidCallback? refreshMethod}) async {
    ExpenseService expenseService = await ExpenseService.create();
    ExpenseItemService expenseItemService = await ExpenseItemService.create();
    CategoryService categoryService = await CategoryService.create();
    TagService tagService = await TagService.create();

    int result = 0;
    if (deleteInput.deleteExpenses) {
      result += await expenseService.deleteAllExpenses();
    }

    if (deleteInput.deleteExpenseItems) {
      result += await expenseItemService.deleteAllExpenseItems();
    }
    if (deleteInput.deleteCategories) {
    result += await categoryService.deleteAllCategories();
    }
    if (deleteInput.deleteTags) {
    result += await tagService.deleteAllTags();
    }

    if (result > 0) {
      if (refreshMethod != null) refreshMethod();
    }

    return result;
  }
}
