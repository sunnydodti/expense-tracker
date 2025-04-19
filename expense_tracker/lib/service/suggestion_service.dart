import '../data/constants/db_constants.dart';
import '../models/expense.dart';
import '../models/expense_category.dart';
import '../models/tag.dart';
import 'package:logger/logger.dart';

import 'expense_service.dart';

class SuggestionService {
  static final Future<ExpenseService> _expenseService = ExpenseService.create();

  static final Logger _logger =
      Logger(printer: SimplePrinter(), level: Level.info);

  // Singleton pattern
  static final SuggestionService _instance = SuggestionService._internal();
  factory SuggestionService() => _instance;
  SuggestionService._internal();

  // Get suggestions based on title input
  static Future<List<Expense>> getSuggestionsForTitle(String titleQuery) async {
    if (titleQuery.isEmpty) return [];
    ExpenseService service = await _expenseService;

    _logger.i('Getting suggestions for: $titleQuery');
    List<Expense> results = await service.getSuggestionsFromTitle(titleQuery);

    return _convertToSuggestions(results);
  }

  // Get default/frequently used expenses
  static Future<List<Expense>> getFrequentSuggestions() async {
    _logger.i('Getting frequent suggestions');
    // final db = await DatabaseHelper.instance.database;

    // // Get most frequent expenses
    // final results = await db.rawQuery('''
    //   SELECT
    //     ${DBConstants.expense.title},
    //     ${DBConstants.expense.category},
    //     COUNT(*) as count
    //   FROM ${DBConstants.expense.table}
    //   GROUP BY ${DBConstants.expense.title}, ${DBConstants.expense.category}
    //   ORDER BY count DESC
    //   LIMIT 5
    // ''');

    List<Expense> suggestions = [];

    // for (final row in results) {
    //   final title = row[DBConstants.expense.title] as String;
    //   final category = row[DBConstants.expense.category] as String;
    //   final count = row['count'] as int;

    //   // Get the most recent expense with this title and category
    //   final expenseResults = await db.query(
    //     DBConstants.expense.table,
    //     where:
    //         '${DBConstants.expense.title} = ? AND ${DBConstants.expense.category} = ?',
    //     whereArgs: [title, category],
    //     orderBy: '${DBConstants.common.modifiedAt} DESC',
    //     limit: 1,
    //   );

    //   if (expenseResults.isNotEmpty) {
    //     final expense = Expense.fromMap(expenseResults.first);
    //     suggestions.add(_expenseToSuggestion(expense, count));
    //   }
    // }

    return suggestions;
  }

  // Get recent expenses
  static Future<List<Expense>> getRecentSuggestions() async {
    _logger.i('Getting recent suggestions');
    ExpenseService service = await _expenseService;
    List<Expense> results = await service.getRecentExpenses();
    return _convertToSuggestions(results);
  }

  static List<Expense> _convertToSuggestions(List<Expense> expenses) {
    return expenses.map((e) => _expenseToSuggestion(e, 1)).toList();
  }

  static Expense _expenseToSuggestion(Expense expense, int frequency) {
    return expense;
  }
}
