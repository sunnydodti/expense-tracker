import 'package:flutter/material.dart';

import '../data/database/category_helper.dart';
import '../data/database/database_helper.dart';
import '../models/category.dart';

class CategoryService {
  late final CategoryHelper _categoryHelper;

  CategoryService._(this._categoryHelper);

  static Future<CategoryService> create() async {
    final databaseHelper = DatabaseHelper();
    await databaseHelper.initializeDatabase();
    final categoryHelper = await databaseHelper.categoryHelper;
    return CategoryService._(categoryHelper);
  }

  Future<List<Category>> getCategories() async {
    try {
      final List<Map<String, dynamic>> categories = await _categoryHelper.getCategories();
      return categories.map((categoryMap) => Category.fromMap(categoryMap)).toList();
    } catch (e) {
      debugPrint("Error getting categories: $e");
      return [];
    }
  }
  Future<Category?> getCategoryByName(String categoryName) async {
    try {
      final List<Map<String, dynamic>> category = await _categoryHelper.getCategoryByName(categoryName);
      return Category.fromMap(category.first);
    } catch (e) {
      debugPrint("Error getting category ($categoryName): $e");
      return null;
    }
  }

  Future<int> addCategory(CategoryFormModel category) async {
    try {
      final result = await _categoryHelper.addCategory(category.toMap());
      return result;
    } catch (e) {
      debugPrint("Error adding category: $e");
      return -1;
    }
  }

  Future<int> updateCategory(CategoryFormModel category) async {
    try {
      final result = await _categoryHelper.updateCategory(category);
      return result;
    } catch (e) {
      debugPrint("Error updating category: $e");
      return -1;
    }
  }

  Future<int> deleteCategory(int id) async {
    try {
      final result = await _categoryHelper.deleteCategory(id);
      return result;
    } catch (e) {
      debugPrint("Error deleting category: $e");
      return -1;
    }
  }

  Category? getMatchingCategory(String name, List<Category> categories) {
    try {
      if (name.isEmpty) return null;
      final matchingCategories = categories.where((category) => category.name == name);
      return matchingCategories.isNotEmpty ? matchingCategories.first : null;
    } on Exception catch (e) {
      debugPrint("Error getting category ($name): $e");
      return null;
    }
  }
}