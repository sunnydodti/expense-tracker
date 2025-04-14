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
  late final FocusNode _focusNode;

  SearchProvider get searchProvider =>
      Provider.of<SearchProvider>(context, listen: false);

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _focusNode = FocusNode();
    if (searchProvider.key.isNotEmpty) {
      _searchController.text = searchProvider.key;
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (BuildContext context, provider, Widget? child) {
        return AppBar(
          backgroundColor: ColorHelper.getScreenAppBarColor(Theme.of(context)),
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
          decoration: const InputDecoration(
            hintText: "Search",
          ),
          focusNode: _focusNode,
          controller: _searchController,
          onChanged: (value) => _triggerDebouncedSearch(value, provider),
        ));
  }

  void _focusTextField() {
    if (MediaQuery.of(context).viewInsets.bottom > 0) return;
    FocusScope.of(context).unfocus();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  void _triggerDebouncedSearch(String? searchKey, SearchProvider provider) {
    provider.setIsTyping(true);
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    if (_searchController.text.isEmpty) return;
    _debounce = Timer(const Duration(milliseconds: 500), () {
      provider.setIsTyping(false);
      provider.search(searchKey!);
    });
  }

  List<Widget> _buildActions(SearchProvider provider, BuildContext context) {
    List<Widget> actions = [];
    Widget clearIcon = IconButton(
      onPressed: () {
        _searchController.clear();
        provider.clearSearch();
        _focusTextField();
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
    actions.add(searchIcon);
    if (_searchController.text.isNotEmpty) actions.add(clearIcon);
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
    searchProvider.closeSearch();
  }
}
