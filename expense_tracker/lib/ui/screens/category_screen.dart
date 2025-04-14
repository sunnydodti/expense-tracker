import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/helpers/color_helper.dart';
import '../../providers/category_provider.dart';
import '../widgets/category/category_list.dart';
import '../widgets/common/screen_app_bar.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  final String title = "Categories";

  Future<void> _refreshCategories(BuildContext context) async {
    final provider = Provider.of<CategoryProvider>(context, listen: false);
    provider.refreshCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.getBackgroundColor(Theme.of(context)),
      appBar: const ScreenAppBar(title: 'Catrgories'),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<void>(
              future: _refreshCategories(context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const CategoryList();
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
