import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../data/constants/ui_constants.dart';
import '../../models/expense_category.dart';
import '../../providers/category_provider.dart';
import '../../service/category_service.dart';

class CategoryForm extends StatefulWidget {
  final List<ExpenseCategory> categories;

  const CategoryForm({Key? key, required this.categories}) : super(key: key);

  @override
  State<CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  final _formKey = GlobalKey<FormState>();

  static final Logger _logger =
      Logger(printer: SimplePrinter(), level: Level.info);

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
    final color = _getColor(context);
    return ListTile(
        visualDensity: const VisualDensity(vertical: 4),
        title: Form(
          key: _formKey,
          child: TextFormField(
            controller: _categoryController,
            decoration: InputDecoration(
              hintText: "Add Category Name",
              labelStyle: TextStyle(
                color: color,
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                color: color,
              )),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                color: color,
              )),
              label: const Text(
                "New Category",
                textScaler: TextScaler.linear(uiTextScaler),
              ),
            ),
            validator: _validateNewCategory,
            onSaved: submitCategory,
            onChanged: (value) {
              _logger.i("category: $value");
            },
          ),
        ),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.add, color: color),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                }
              },
              tooltip: "Save Category",
            ),
            const Expanded(child: Text("Add"))
          ],
        ));
  }

  Color _getColor(BuildContext context) {
    Brightness brightness = Theme.of(context).brightness;
    return (brightness == Brightness.dark
        ? Colors.green.shade300
        : Colors.green.shade700);
  }

  void submitCategory(newValue) async {
    if (_formKey.currentState?.validate() ?? false) {
      CategoryFormModel category =
          CategoryFormModel(name: _categoryController.text.trim());
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
    return null;
  }

  bool isDuplicateCategory() {
    for (ExpenseCategory category in widget.categories) {
      if (category.name == _categoryController.text) return true;
    }
    return false;
  }
}
