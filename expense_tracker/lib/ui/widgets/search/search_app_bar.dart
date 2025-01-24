import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/helpers/color_helper.dart';
import '../../../data/helpers/navigation_helper.dart';
import '../../../providers/search_provider.dart';

class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  const SearchAppBar({
    super.key,
  });

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SearchAppBarState extends State<SearchAppBar> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _searchController;

  SearchProvider get searchProvider =>
      Provider.of<SearchProvider>(context, listen: false);

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    if (searchProvider.key.isNotEmpty) {
      _searchController.text = searchProvider.key;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (BuildContext context, provider, Widget? child) {
        return AppBar(
          backgroundColor: ColorHelper.getAppBarColor(Theme.of(context)),
          title: buildSearchField(provider),
          leading: _buildBackButton(context),
          actions: _buildActions(provider, context),
        );
      },
    );
  }

  Widget buildSearchField(SearchProvider provider) {
    if (provider.key.isNotEmpty) _searchController.text = searchProvider.key;

    return Form(
        key: _formKey,
        child: TextFormField(
          controller: _searchController,
          onChanged: (value) => _triggerDebouncedSearch(value, provider),
        ));
  }

  void _triggerDebouncedSearch(String? searchKey, SearchProvider provider) {
    provider.setIsTyping(true);
    if (_searchController.text.isEmpty) return;
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      provider.setIsTyping(false);
      provider.search(searchKey!);
    });
  }

  List<Widget> _buildActions(SearchProvider provider, BuildContext context) {
    List<Widget> actions = [];
    Widget clearIcon = IconButton(
      onPressed: () {
        provider.stopSearch();
      },
      icon: const Icon(Icons.close_outlined),
    );
    Widget searchIcon = IconButton(
      onPressed: () {
        if (_searchController.text.isNotEmpty) {
          provider.search(_searchController.text);
        }
      },
      icon: const Icon(Icons.search_outlined),
    );
    (provider.isSearching) ? actions.add(searchIcon) : clearIcon;
    return actions;
  }

  IconButton _buildBackButton(BuildContext context) {
    return IconButton(
      onPressed: _exitSearch,
      icon: const Icon(Icons.arrow_back),
    );
  }

  void _exitSearch() async {
    NavigationHelper.navigateBack(context);
    _searchController.clear();
    searchProvider.clear();
  }
}
