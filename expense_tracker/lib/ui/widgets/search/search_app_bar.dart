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
  TextEditingController searchController = TextEditingController();
  Timer? _debounce;

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
    return Form(
        key: _formKey,
        child: TextFormField(
          controller: searchController,
          onChanged: (value) => _triggerDebouncedSearch(value, provider),
        ));
  }

  void _triggerDebouncedSearch(String? searchKey, SearchProvider provider) {
    provider.setIsTyping(true);
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 1000), () {
      provider.setIsTyping(false);
      provider.search(searchKey);
    });
  }

  List<Widget> _buildActions(SearchProvider provider, BuildContext context) {
    List<Widget> actions = [];
    Widget searchIcon = IconButton(
      onPressed: () {
        provider.stopSearch();
      },
      icon: const Icon(Icons.close_outlined),
    );
    Widget clearIcon = IconButton(
      onPressed: () {
        provider.search(searchController.text);
      },
      icon: const Icon(Icons.search_outlined),
    );
    (provider.isSearching) ? actions.add(clearIcon) : searchIcon;
    return actions;
  }

  IconButton _buildBackButton(BuildContext context) {
    return IconButton(
      onPressed: () => NavigationHelper.navigateBack(context),
      icon: const Icon(Icons.arrow_back),
    );
  }
}
