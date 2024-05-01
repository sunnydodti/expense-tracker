import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/helpers/navigation_helper.dart';
import '../../providers/category_provider.dart';
import '../widgets/category/category_list.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  final String title = "Categories";

  Future<void> _refreshCategories(BuildContext context) async {
    final provider = Provider.of<CategoryProvider>(context, listen: false);
    provider.refreshCategories();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _refreshCategories(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Scaffold(
            appBar: AppBar(
              leading: SafeArea(
                  child: BackButton(
                onPressed: () => NavigationHelper.navigateBack(context),
              )),
              centerTitle: true,
              title: Text(title, textScaleFactor: 0.9),
              backgroundColor: Colors.black,
            ),
            body: Column(
              children: const [
                Expanded(
                  child: CategoryList(),
                )
              ],
            ),
          );
        }
      },
    );
  }
}
