import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../forms/category_form.dart';
import '../../models/expense_category.dart';
import '../../providers/category_provider.dart';
import '../../service/category_service.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
        builder: (context, categoryProvider, child) => Scaffold(
              body: RefreshIndicator(
                onRefresh: () => categoryProvider.refreshCategories(),
                color: Colors.blue.shade500,
                child: Column(
                  children: [
                    getCategoryForm(categoryProvider.categories),
                    Expanded(
                        child: categoryProvider.categories.isEmpty
                            ? getNoCategoryView()
                            : ListView.builder(
                                itemCount: categoryProvider.categories.length,
                                itemBuilder: (context, index) {
                                  final category =
                                      categoryProvider.categories[index];
                                  return getCategoryTile(context, category);
                                },
                              ))
                  ],
                ),
              ),
            ));
  }

  Padding getNoCategoryView() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 100),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text(
              'Click',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(width: 8),
            Icon(
              Icons.add,
              color: Colors.grey,
            ),
            SizedBox(width: 8),
            Text(
              'icon to add a Category',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Container getCategoryTile(BuildContext context, ExpenseCategory category) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
        ),
        padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10),
        margin: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 5),
        child: ListTile(
          // tileColor: Colors.grey.shade900,
          dense: true,
          title: Text(
            category.name,
            textScaleFactor: 1,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // IconButton(
              //   icon: const Icon(Icons.edit),
              //   onPressed: () => {},
              // ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red.shade300),
                onPressed: () => _deleteCategory(context, category),
              ),
            ],
          ),
        ));
  }

  _deleteCategory(BuildContext context, ExpenseCategory category) async {
    CategoryService categoryService = await CategoryService.create();
    categoryService.deleteCategory(category.id).then((value) {
      if (value > 0) {
        _refreshCategories(context);
      }
    });
  }

  _refreshCategories(BuildContext context) {
    final categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    categoryProvider.refreshCategories();
  }

  Container getCategoryForm(List<ExpenseCategory> categories) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
        margin: const EdgeInsets.only(top: 5, bottom: 2.5),
        child: CategoryForm(categories: categories));
  }
}
