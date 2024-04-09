import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import '../models/expense_category.dart';
import '../service/category_service.dart';

class CategoryProvider extends ChangeNotifier {
  late final Future<CategoryService> _categoryService;
  static final Logger _logger =
      Logger(printer: SimplePrinter(), level: Level.info);

  CategoryProvider() {
    _init();
  }

  Future<void> _init() async {
    _categoryService = CategoryService.create();
  }

  List<ExpenseCategory> _categories = [];

  /// get list of all categories
  List<ExpenseCategory> get categories => _categories;

  /// add an category. this does not add in db
  void addCategory(ExpenseCategory category) {
    _categories.add(category);
    notifyListeners();
  }

  /// insert an category. this does not insert in db
  void insertCategory(int index, ExpenseCategory category) {
    _categories.insert(index, category);
    notifyListeners();
  }

  /// get category by id. this does not get from db
  ExpenseCategory? getCategory(int id) {
    try {
      return _categories.firstWhere((category) => category.id == id);
    } catch (e, stackTrace) {
      _logger.e('Error getting category ($id): $e - \n$stackTrace');
      return null;
    }
  }

  /// edit an category. this does not edit in db
  void editCategory(ExpenseCategory editedCategory) {
    final index =
        _categories.indexWhere((category) => category.id == editedCategory.id);
    if (index != -1) {
      _categories[index] = editedCategory;
      notifyListeners();
    }
  }

  /// delete an category at index. this does not delete in db
  void deleteCategory(int id) {
    _categories.removeWhere((category) => category.id == id);
    notifyListeners();
  }

  /// refresh categories from db
  Future<void> refreshCategories({bool notify = true}) async {
    try {
      List<ExpenseCategory> categories = await _getCategories();
      categories.sort((a, b) => b.createdAt.compareTo(a.modifiedAt));
      _categories = categories;
      if (notify) notifyListeners();
    } catch (e, stackTrace) {
      _logger.e('Error refreshing categories: $e - \n$stackTrace');
    }
  }

  /// fetch updated categories from db
  Future<List<ExpenseCategory>> _getCategories() async {
    CategoryService categoryService = await _categoryService;
    return await categoryService.getCategories();
  }
}
