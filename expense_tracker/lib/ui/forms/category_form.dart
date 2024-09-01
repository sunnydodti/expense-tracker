import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

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
    return ListTile(
        title: Form(
          key: _formKey,
          child: TextFormField(
            controller: _categoryController,
            decoration: InputDecoration(
                hintText: "Add Category Name",
                labelStyle: TextStyle(
                  color: getColor(context),
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                  color: getColor(context),
                )),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                  color: getColor(context),
                )),
                label: const Text("New Category", textScaleFactor: .9)),
            validator: _validateNewCategory,
            onSaved: submitCategory,
            onChanged: (value) {
              _logger.i("category: $value");
            },
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.add, color: getColor(context)),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
            }
          },
        ));
  }

  Color getColor(BuildContext context) {
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
