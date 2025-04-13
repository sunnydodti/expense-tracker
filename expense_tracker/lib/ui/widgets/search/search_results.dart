import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/helpers/color_helper.dart';
import '../../../providers/search_provider.dart';
import '../expense/expense_tile.dart';

class SearchResults extends StatelessWidget {
  const SearchResults({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(
        builder: (BuildContext context, provider, Widget? child) {
          if (provider.isTyping) {
            return _buildRecentSearchHistory(provider);
          }
          return _buildSearchResults(provider);
        },
        child: const Placeholder());
  }

  Widget _buildSearchResults(SearchProvider provider) {
    if (provider.expenses.isEmpty) {
      return const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text("No matching results")],
      );
    }
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: ListView.builder(
        itemCount: provider.expenses.length,
        itemBuilder: (context, index) {
          if (index > provider.expenses.length) return null;
          return _buildSearchResultTile(context, provider, index);
        },
      ),
    );
  }

  Widget _buildSearchResultTile(
      BuildContext context, SearchProvider provider, int index) {
    return ExpenseTile(
        expense: provider.expenses[index],
        editCallBack: () {},
      deleteCallBack: () async => -1,
      isReadonly: true,
    );
  }

  Widget _buildRecentSearchHistory(SearchProvider provider) {
    return FutureBuilder<void>(
      future: _getSearchHistory(provider),
      builder: (context, snapshot) {
        if (provider.searchHistory.isEmpty) {
          return const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text("Start Typing")],
          );
        }
        return ListView.builder(
          itemCount: provider.searchHistory.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return _buildSearchHistoryTile(context, provider, index);
          },
        );
        // return const Text("results");
      },
    );
  }

  Card _buildSearchHistoryTile(
      BuildContext context, SearchProvider provider, int index) {
    return Card(
      color: ColorHelper.getTileColor(Theme.of(context)),
      child: ListTile(
        leading: const Icon(Icons.history_outlined),
        trailing: IconButton(
          onPressed: () {
            provider.deleteSearch(provider.searchHistory[index]);
          },
          icon: const Icon(Icons.delete_outline),
        ),
        title: Text("${provider.searchHistory[index].title}"),
        dense: true,
        onTap: () {
          provider.setIsTyping(false);
          provider.searchFromHistory(provider.searchHistory[index]);
        },
      ),
    );
  }

  _getSearchHistory(SearchProvider provider) async {
    await provider.getSearchHistory(limit: 10);
  }
}
