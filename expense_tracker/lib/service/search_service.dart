import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

import '../data/constants/db_constants.dart';
import '../data/helpers/database/database_helper.dart';
import '../data/helpers/database/search_helper.dart';
import '../models/search.dart';

class SearchService {
  late final SearchHelper _searchHelper;
  static final Logger _logger =
      Logger(printer: SimplePrinter(), level: Level.info);

  SearchService._(this._searchHelper);

  static Future<SearchService> create() async {
    final databaseHelper = DatabaseHelper();
    await databaseHelper.initializeDatabase();
    final searchHelper = await databaseHelper.searchHelper;
    return SearchService._(searchHelper);
  }

  Future<List<Search>> getSearches() async {
    try {
      final List<Map<String, dynamic>> searches = await _searchHelper.getSearches();
      List<Search> searchResults =
          searches.map((searchMap) => Search.fromMap(searchMap)).toList();
      return searchResults;
    } catch (e, stackTrace) {
      _logger.e("Error getting searches: $e - \n$stackTrace");
      return [];
    }
  }

  Future<List<Search>> getLatestSearches(
      {required int profileId, int limit = 10}) async {
    try {
      final List<Map<String, dynamic>> searches = await _searchHelper
          .getLatestSearches(profileId: profileId, limit: limit);
      List<Search> searchResults =
          searches.map((searchMap) => Search.fromMap(searchMap)).toList();
      return searchResults;
    } catch (e, stackTrace) {
      _logger.e("Error getting searches: $e - \n$stackTrace");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getSearchMaps() async {
    try {
      return await _searchHelper.getSearches();
    } on Exception catch (e, stackTrace) {
      _logger.e("Error getting searches: $e - \n$stackTrace");
      return [];
    }
  }

  Future<Search?> getSearchByTitle(String searchTitle) async {
    try {
      final List<Map<String, dynamic>> search =
          await _searchHelper.getSearchByTitle(searchTitle);
      return Search.fromMap(search.first);
    } catch (e, stackTrace) {
      _logger.e("Error getting search ($searchTitle): $e - \n$stackTrace");
      return null;
    }
  }

  Future<Search?> getSearchById(int id) async {
    try {
      final List<Map<String, dynamic>> search =
          await _searchHelper.getSearchById(id);
      return Search.fromMap(search.first);
    } catch (e, stackTrace) {
      _logger.e("Error getting search by id ($id): $e - \n$stackTrace");
      return null;
    }
  }

  Future<int> addSearch(SearchFormModel search) async {
    try {
      final result = await _searchHelper.addSearch(search.toMap());
      return result;
    } catch (e, stackTrace) {
      _logger.e("Error adding search: $e - \n$stackTrace");
      return -1;
    }
  }

  Future<int> addSearchKey(String key, {required int profileId}) async {
    try {
      SearchFormModel searchFormModel =
          SearchFormModel(title: key, profileId: profileId);
      final result = await _searchHelper.addSearch(searchFormModel.toMap());
      return result;
    } catch (e, stackTrace) {
      _logger.e("Error adding search: $e - \n$stackTrace");
      return -1;
    }
  }

  Future<int> updateSearch(SearchFormModel search) async {
    try {
      final result = await _searchHelper.updateSearch(search);
      return result;
    } catch (e, stackTrace) {
      _logger.e("Error updating search: $e - \n$stackTrace");
      return -1;
    }
  }

  Future<int> deleteSearch(int id) async {
    try {
      final result = await _searchHelper.deleteSearch(id);
      return result;
    } catch (e, stackTrace) {
      _logger.e("Error deleting search: $e - \n$stackTrace");
      return -1;
    }
  }

  Future<int> deleteAllSearches() async {
    try {
      final result = await _searchHelper.deleteAllSearches();
      return result;
    } catch (e, stackTrace) {
      _logger.e("Error deleting searches - $e - \n$stackTrace");
      return -1;
    }
  }

  Search? getMatchingSearch(String title, List<Search> searches) {
    try {
      if (title.isEmpty) return null;
      final matchingSearches = searches.where((search) => search.title == title);
      return matchingSearches.isNotEmpty ? matchingSearches.first : null;
    } on Exception catch (e, stackTrace) {
      _logger.e("Error getting search ($title): $e - \n$stackTrace");
      return null;
    }
  }

  Future<bool> importSearch(Map<String, dynamic> search, {safeImport = true}) async {
    _logger.i(
        "importing search ${search[DBConstants.search.id]} - ${search[DBConstants.search.title]}");
    try {
      if (await isDuplicateSearch(search[DBConstants.search.title])) {
        _logger.i("found duplicate search: ${search[DBConstants.search.title]}");
        if (safeImport) return false;
        _logger.i("safeImport: $safeImport - discarding existing search");
        await _searchHelper.deleteSearchByTitle(search[DBConstants.search.title]);
      }
      if (await _searchHelper.addSearch(search) > 0) {
        _logger.i("imported search ${search[DBConstants.search.title]}");
        return true;
      }
    } on Exception catch (e, stackTrace) {
      _logger.e(
          "Error importing search (${search[DBConstants.search.title]}): $e - \n$stackTrace");
    }
    return false;
  }

  Future<bool> isDuplicateSearch(String searchTitle) async {
    int count = await getSearchCount(searchTitle);
    if (count > 0) return true;
    return false;
  }

  Future<int> getSearchCount(String searchTitle) async {
    _logger.i("checking if search exists $searchTitle");
    final List<Map<String, dynamic>> result =
        await _searchHelper.getSearchCountByTitle(searchTitle);
    int? count = Sqflite.firstIntValue(result);
    if (count == null) return 0;
    return count;
  }

  void addOrUpdateSearchKey(Search previousSearch) async {
    try {
      Search? search = await getSearchById(previousSearch.id);
      if (search == null) {
        addSearch(SearchFormModel.fromSearch(previousSearch));
        return;
      }
      updateSearch(SearchFormModel.fromSearch(previousSearch));
    } on Exception catch (e, stackTrace) {
      _logger.e(
          "Error at addOrUpdateSearchKey (${previousSearch.title}): $e - \n$stackTrace");
    }
  }
}
