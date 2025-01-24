import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/search_provider.dart';

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
    return ListView.builder(
      itemCount: provider.expenses.length,
      itemBuilder: (context, index) {
        return ListTile(
          dense: true,
          title: Text(provider.expenses[index].title),
          subtitle: const Text("title"),
        );
    },);
  }

  Widget _buildRecentSearchHistory(SearchProvider provider) {
    return FutureBuilder<void>(
      future: _getSearchHistory(provider),
      builder: (context, snapshot) {
        if (provider.searchHistory.isEmpty) {
          return const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text("Recent Suggestions")],
          );
        }
        return ListView.builder(
          itemCount: provider.searchHistory.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text("${provider.searchHistory[index].title}"),
              subtitle: const Text("title"),
            );
          },
        );
        // return const Text("results");
      },
    );
  }

  _getSearchHistory(SearchProvider provider) async {
    await provider.getSearchHistory(limit: 10);
  }
}
