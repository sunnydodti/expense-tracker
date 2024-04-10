import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

import '../data/constants/db_constants.dart';
import '../data/database/database_helper.dart';
import '../data/database/tag_helper.dart';
import '../models/tag.dart';

class TagService {
  late final TagHelper _tagHelper;
  static final Logger _logger =
      Logger(printer: SimplePrinter(), level: Level.info);

  TagService._(this._tagHelper);

  static Future<TagService> create() async {
    final databaseHelper = DatabaseHelper();
    await databaseHelper.initializeDatabase();
    final tagHelper = await databaseHelper.tagHelper;
    return TagService._(tagHelper);
  }

  Future<List<Tag>> getTags() async {
    try {
      final List<Map<String, dynamic>> tags = await _tagHelper.getTags();
      List<Tag> tgs = tags.map((tagMap) => Tag.fromMap(tagMap)).toList();
      return tgs;
    } catch (e, stackTrace) {
      _logger.e("Error getting tags: $e - \n$stackTrace");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getTagMaps() async {
    try {
      return await _tagHelper.getTags();
    } on Exception catch (e, stackTrace) {
      _logger.e("Error getting tags: $e - \n$stackTrace");
      return [];
    }
  }

  Future<Tag?> getTagByName(String tagName) async {
    try {
      final List<Map<String, dynamic>> tag =
          await _tagHelper.getTagByName(tagName);
      return Tag.fromMap(tag.first);
    } catch (e, stackTrace) {
      _logger.e("Error getting tag ($tagName): $e - \n$stackTrace");
      return null;
    }
  }

  Future<int> addTag(TagFormModel tag) async {
    try {
      final result = await _tagHelper.addTag(tag.toMap());
      return result;
    } catch (e, stackTrace) {
      _logger.e("Error adding tag: $e - \n$stackTrace");
      return -1;
    }
  }

  Future<int> updateTag(TagFormModel tag) async {
    try {
      final result = await _tagHelper.updateTag(tag);
      return result;
    } catch (e, stackTrace) {
      _logger.e("Error updating tag: $e - \n$stackTrace");
      return -1;
    }
  }

  Future<int> deleteTag(int id) async {
    try {
      final result = await _tagHelper.deleteTag(id);
      return result;
    } catch (e, stackTrace) {
      _logger.e("Error deleting tag: $e - \n$stackTrace");
      return -1;
    }
  }

  Future<int> deleteAllTags() async {
    try {
      final result = await _tagHelper.deleteAllTags();
      return result;
    } catch (e, stackTrace) {
      _logger.e("Error deleting tags - $e - \n$stackTrace");
      return -1;
    }
  }

  Tag? getMatchingTag(String name, List<Tag> tags) {
    try {
      if (name.isEmpty) return null;
      final matchingTags = tags.where((tag) => tag.name == name);
      return matchingTags.isNotEmpty ? matchingTags.first : null;
    } on Exception catch (e, stackTrace) {
      _logger.e("Error getting tag ($name): $e - \n$stackTrace");
      return null;
    }
  }

  Future<bool> importTag(Map<String, dynamic> tag, {safeImport = true}) async {
    _logger.i(
        "importing tag ${tag[DBConstants.tag.id]} - ${tag[DBConstants.tag.name]}");
    try {
      if (await isDuplicateTag(tag[DBConstants.tag.name])) {
        _logger.i("found duplicate tag: ${tag[DBConstants.tag.name]}");
        if (safeImport) return false;
        _logger.i("safeImport: $safeImport - discarding existing tag");
        await _tagHelper.deleteTagByName(tag[DBConstants.tag.name]);
      }
      if (await _tagHelper.addTag(tag) > 0) {
        _logger.i("imported tag ${tag[DBConstants.tag.name]}");
        return true;
      }
    } on Exception catch (e, stackTrace) {
      _logger.e(
          "Error importing tag (${tag[DBConstants.tag.name]}): $e - \n$stackTrace");
    }
    return false;
  }

  Future<bool> isDuplicateTag(String tagName) async {
    int count = await getTagCount(tagName);
    if (count > 0) return true;
    return false;
  }

  Future<int> getTagCount(String tagName) async {
    _logger.i("checking if tag exists $tagName");
    final List<Map<String, dynamic>> result =
        await _tagHelper.getTagCountByName(tagName);
    int? count = Sqflite.firstIntValue(result);
    if (count == null) return 0;
    return count;
  }
}
