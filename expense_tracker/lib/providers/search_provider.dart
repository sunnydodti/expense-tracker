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

  bool isSearching = true;
  bool _isTyping = true;

  bool get isTyping => _isTyping;

  void setIsTyping(bool value, {bool notify = true}) {
    _isTyping = value;
    if (notify) notifyListeners();
  }

  /// get expense by id. this does not get from db
  Expense? getExpense(int id) {
    try {
      return _searchExpenses.firstWhere((expense) => expense.id == id);
    } catch (e, stackTrace) {
      _logger.e('Error getting expense ($id): $e - \n$stackTrace');
      return null;
    }
  }

  /// refresh expenses from db
  Future<void> refreshExpenses({bool notify = true}) async {
    try {
      Profile? profile = await _getProfile();
      _searchExpenses = await _fetchExpenses(profile);

      if (notify) notifyListeners();
    } catch (e, stackTrace) {
      _logger.e('Error refreshing expenses: $e - \n$stackTrace');
    }
  }

  /// fetch updated expenses from db
  Future<List<Expense>> _fetchExpenses(Profile? profile) async {
    ExpenseService expenseService = await _expenseService;
    // return await expenseService.getExpenses();
    return await expenseService.getSortedAndFilteredExpenses(profile);
  }

  Future<List<Expense>> fetchAllExpenses() async {
    ExpenseService expenseService = await _expenseService;
    return await expenseService.getExpenses();
  }

  Future<List<Expense>> fetchAllExpensesForProfile() async {
    ExpenseService expenseService = await _expenseService;
    return await expenseService.getExpensesForProfile();
  }

  bool _showPopup = false;

  bool get showPopup => _showPopup;

  Expense? _popUpExpense;

  Expense? get popUpExpense => _popUpExpense;

  void showExpensePopup(Expense expense) {
    _showPopup = true;
    _popUpExpense = expense;
    notifyListeners();
  }

  void hideExpensePopup() {
    _showPopup = false;
    _popUpExpense = null;
    notifyListeners();
  }

  Future<Profile?> _getProfile() async {
    ProfileService profileService = await _profileService;
    return await profileService.getSelectedProfile();
  }

  void initializeSearch({bool notify = true}) {
    isSearching = true;
    if (notify) notifyListeners();
  }

  void stopSearch({bool notify = true}) {
    isSearching = false;
    if (notify) notifyListeners();
  }

  void search(String searchKey, {bool notify = true}) async {
    ExpenseService expenseService = await _expenseService;
    ProfileService profileService = await _profileService;
    SearchService searchService = await _searchService;

    Profile? profile = await profileService.getSelectedProfile();
    _searchExpenses = await expenseService.searchExpenses(searchKey, profile);
    notifyListeners();

    if (_searchExpenses.isNotEmpty) {
      searchService.addSearchKey(searchKey!);
    }
  }

  Future<void> getSearchHistory({int limit = 10, bool notify = false}) async {
    SearchService searchService = await _searchService;
    List<Search> searches = await searchService.getLatestSearches(limit: limit);
    _searchHistory = searches;
    if (notify) notifyListeners();
  }
}
