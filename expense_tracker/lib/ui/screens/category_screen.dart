import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/helpers/color_helper.dart';
import '../../providers/category_provider.dart';
import '../widgets/category/category_list.dart';
import '../widgets/common/screen_app_bar.dart';
import 'widget_constants.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late Future<void> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _refreshCategories();
  }

  Future<void> _refreshCategories() async {
    final provider = Provider.of<CategoryProvider>(context, listen: false);
    await provider.refreshCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.getBackgroundColor(Theme.of(context)),
      appBar: const ScreenAppBar(title: 'Categories'),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<void>(
              future: _categoriesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return wcSpinnerDefault;
                }
                if (snapshot.hasError) {
                  return Center(child: wcSnapshotErrorText(snapshot.error));
                }
                return const CategoryList();
              },
            ),
          )
        ],
      ),
    );
  }
}
