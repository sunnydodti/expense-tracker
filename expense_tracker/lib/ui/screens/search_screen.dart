import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/search_provider.dart';
import '../widgets/search/search_app_bar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  SearchProvider get searchProvider =>
      Provider.of<SearchProvider>(context, listen: false);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeSearch(),
      builder: (BuildContext context, snapshot) {
        return const Scaffold(
          appBar: SearchAppBar(),
        );
      },
    );
  }

  Future<void> _initializeSearch() async {
    searchProvider.initializeSearch( notify: false);
    return;
  }
}
