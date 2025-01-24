import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../models/expense.dart';
import '../models/profile.dart';
import '../models/search.dart';
import '../service/expense_service.dart';
import '../service/profile_service.dart';
import '../service/search_service.dart';
import '../service/shared_preferences_service.dart';

class SearchProvider extends ChangeNotifier {
  late final Future<ExpenseService> _expenseService;
  late final Future<ProfileService> _profileService;
  late final Future<SearchService> _searchService;

  late final SharedPreferencesService _sharedPreferencesService;

  static final Logger _logger =
      Logger(printer: SimplePrinter(), level: Level.info);

  SearchProvider() {
    _sharedPreferencesService = SharedPreferencesService();
    _init();
  }

  Future<void> _init() async {
    _expenseService = ExpenseService.create();
    _profileService = ProfileService.create();
    _searchService = SearchService.create();
  }

  List<Expense> _searchExpenses = [];
  List<Search> _searchHistory = [];

  List<Expense> get expenses => _searchExpenses;
  List<Search> get searchHistory => _searchHistory;

  String key = "";

  bool _isTyping = true;

  bool get isTyping => _isTyping;

  void setIsTyping(bool value, {bool notify = true}) {
    key = "";
    _isTyping = value;
    if (notify) notifyListeners();
  }

  Future<Profile?> _getProfile() async {
    ProfileService profileService = await _profileService;
    return await profileService.getSelectedProfile();
  }

  void search(String searchKey, {bool notify = true}) async {
    ExpenseService expenseService = await _expenseService;
    SearchService searchService = await _searchService;

    Profile? profile = await _getProfile();
    _searchExpenses = await expenseService.searchExpenses(searchKey, profile);
    notifyListeners();

    if (_searchExpenses.isNotEmpty) {
      searchService.addSearchKey(searchKey);
    }
  }

  void searchFromHistory(String searchKey, {bool notify = true}) async {
    key = searchKey;
    search(key);
  }

  Future<void> getSearchHistory({int limit = 10, bool notify = false}) async {
    SearchService searchService = await _searchService;
    List<Search> searches = await searchService.getLatestSearches(limit: limit);
    _searchHistory = searches;
    if (notify) notifyListeners();
  }

  void closeSearch() {
    _searchHistory.clear();
    _searchExpenses.clear();
    key = "";
    _isTyping = true;
  }

  void deleteSearch(Search searchHistory, {bool notify = true}) async {
    SearchService searchService = await _searchService;
    searchService.deleteSearch(searchHistory.id);
    if (notify) notifyListeners();
  }

  void clearSearch() {
    key = "";
    _searchHistory.clear();
    notifyListeners();
    _isTyping = true;
  }
}
