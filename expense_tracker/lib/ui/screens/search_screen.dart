import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/helpers/color_helper.dart';
import '../../providers/search_provider.dart';
import '../widgets/search/search_app_bar.dart';
import '../widgets/search/search_results.dart';
import 'widget_constants.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late Future<void> _searchFuture;

  SearchProvider get searchProvider =>
      Provider.of<SearchProvider>(context, listen: false);

  @override
  void initState() {
    super.initState();
    _searchFuture = _initializeSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.getBackgroundColor(Theme.of(context)),
      appBar: const SearchAppBar(),
      body: FutureBuilder<void>(
        future: _searchFuture,
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return wcSpinnerDefault;
          }
          if (snapshot.hasError) {
            return Center(child: wcSnapshotErrorText(snapshot.error));
          }
          return const SearchResults();
        },
      ),
    );
  }

  Future<void> _initializeSearch() async {
    // searchProvider.initializeSearch( notify: false);
    return;
  }
}
