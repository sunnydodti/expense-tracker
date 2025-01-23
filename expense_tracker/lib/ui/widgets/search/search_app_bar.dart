import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/helpers/color_helper.dart';
import '../../../data/helpers/navigation_helper.dart';
import '../../../providers/search_provider.dart';
import '../../screens/search_screen.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SearchAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (BuildContext context, provider, Widget? child) {
        return AppBar(
          backgroundColor: ColorHelper.getAppBarColor(Theme.of(context)),
          leading: _buildBackButton(context),
          actions: _buildActions(provider, context),
        );
      },
    );
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
        provider.search();
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

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
