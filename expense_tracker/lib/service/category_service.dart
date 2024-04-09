import 'package:logger/logger.dart';

import '../data/database/category_helper.dart';
import '../data/database/database_helper.dart';
import '../models/expense_category.dart';

class CategoryService {
  late final CategoryHelper _categoryHelper;
  static final Logger _logger =
      Logger(printer: SimplePrinter(), level: Level.info);

  CategoryService._(this._categoryHelper);

  static Future<CategoryService> create() async {
    final databaseHelper = DatabaseHelper();
    await databaseHelper.initializeDatabase();
    final categoryHelper = await databaseHelper.categoryHelper;
    return CategoryService._(categoryHelper);
  }

  Future<List<ExpenseCategory>> getCategories() async {
    try {
      final List<Map<String, dynamic>> categories =
          await _categoryHelper.getCategories();
      return categories
          .map((categoryMap) => ExpenseCategory.fromMap(categoryMap))
          .toList();
    } catch (e, stackTrace) {
      _logger.e("Error getting categories - $e - \n$stackTrace");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getCategoryMaps() async {
    try {
      return await _categoryHelper.getCategories();
    } on Exception catch (e, stackTrace) {
      _logger.e("Error getting categories: $e - \n$stackTrace");
      return [];
    }
  }

  Future<ExpenseCategory?> getCategoryByName(String categoryName) async {
    try {
      final List<Map<String, dynamic>> category =
          await _categoryHelper.getCategoryByName(categoryName);
      return ExpenseCategory.fromMap(category.first);
    } catch (e, stackTrace) {
      _logger.e("Error getting category ($categoryName) - $e - \n$stackTrace");
      return null;
    }
  }

  Future<int> addCategory(CategoryFormModel category) async {
    _logger.i("in service");
    try {
      final result = await _categoryHelper.addCategory(category.toMap());
      return result;
    } catch (e, stackTrace) {
      _logger.e("Error adding category - $e - \n$stackTrace");
      return -1;
    }
  }

  Future<int> updateCategory(CategoryFormModel category) async {
    try {
      final result = await _categoryHelper.updateCategory(category);
      return result;
    } catch (e, stackTrace) {
      _logger.e("Error updating category - $e - \n$stackTrace");
      return -1;
    }
  }

  Future<int> deleteCategory(int id) async {
    try {
      final result = await _categoryHelper.deleteCategory(id);
      return result;
    } catch (e, stackTrace) {
      _logger.e("Error deleting category - $e - \n$stackTrace");
      return -1;
    }
  }

  ExpenseCategory? getMatchingCategory(
      String name, List<ExpenseCategory> categories) {
    try {
      if (name.isEmpty) return null;
      final matchingCategories =
          categories.where((category) => category.name == name);
      return matchingCategories.isNotEmpty ? matchingCategories.first : null;
    } on Exception catch (e, stackTrace) {
      _logger.e("Error getting category ($name) - $e - \n$stackTrace");
      return null;
    }
  }
}
