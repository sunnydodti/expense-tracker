import 'package:expense_tracker/models/expense_category.dart';
import 'package:expense_tracker/service/category_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/category_provider.dart';

class CategoryForm extends StatefulWidget {
  final List<ExpenseCategory> categories;

  const CategoryForm({Key? key, required this.categories}) : super(key: key);

  @override
  State<CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  final _formKey = GlobalKey<FormState>();
  final _categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true, // Compact spacing
      title: Form(
        key: _formKey,
        child: TextFormField(
          controller: _categoryController,
          decoration: InputDecoration(
              hintText: "Add Category Name",
              labelStyle: TextStyle(
                color: Colors.green.shade300,
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                color: Colors.green.shade500,
              )),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                color: Colors.green.shade300,
              )),
              label: const Text("New Category")),
          validator: _validateNewCategory,
          onSaved: submitCategory,
          onChanged: (value) {
            _categoryController.text = value;
          },
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.add, color: Colors.green),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
          }
        },
      ),
    );
  }

  void submitCategory(newValue) async {
    if (_formKey.currentState?.validate() ?? false) {
      CategoryFormModel category =
          CategoryFormModel(name: _categoryController.text);
      _addCategory(category).then((value) {
        if (value > 0) {
          _categoryController.clear();
          _refreshCategories();
        }
      });
    }
  }

  Future<int> _addCategory(CategoryFormModel category) async {
    CategoryService categoryService = await CategoryService.create();
    return categoryService.addCategory(category);
  }

  void _refreshCategories() {
    final categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    categoryProvider.refreshCategories();
  }

  String? _validateNewCategory(value) {
    if (_categoryController.text.isEmpty) {
      return 'Please enter a category name.';
    }
    if (isDuplicateCategory()) return "Category must be unique";
    return null; // Valid input returns null
  }

  bool isDuplicateCategory() {
    for (ExpenseCategory category in widget.categories) {
      if (category.name == _categoryController.text) return true;
    }
    return false;
  }
}
