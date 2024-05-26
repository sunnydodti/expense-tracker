import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/expense_category.dart';
import '../../../providers/category_provider.dart';
import '../../../service/category_service.dart';
import '../../forms/category_form.dart';
import '../empty_list_widget.dart';
import 'category_tile.dart';

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
                          ? const EmptyListWidget(listName: 'Category')
                          : Scrollbar(
                              interactive: true,
                              radius: const Radius.circular(5),
                              child: ListView.builder(
                                itemCount: categoryProvider.categories.length,
                                itemBuilder: (context, index) {
                                  final category =
                                      categoryProvider.categories[index];
                                  return CategoryTile(
                                    categoryName: category.name,
                                    onDelete: () =>
                                        _deleteCategory(context, category),
                                  );
                                },
                              ),
                            ),
                    )
                  ],
                ),
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
