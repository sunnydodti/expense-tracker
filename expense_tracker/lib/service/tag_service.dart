import 'package:logger/logger.dart';

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
    } catch (e) {
      _logger.e("Error getting tags: $e");
      return [];
    }
  }

  Future<Tag?> getTagByName(String tagName) async {
    try {
      final List<Map<String, dynamic>> tag =
          await _tagHelper.getTagByName(tagName);
      return Tag.fromMap(tag.first);
    } catch (e) {
      _logger.e("Error getting tag ($tagName): $e");
      return null;
    }
  }

  Future<int> addTag(TagFormModel tag) async {
    try {
      final result = await _tagHelper.addTag(tag.toMap());
      return result;
    } catch (e) {
      _logger.e("Error adding tag: $e");
      return -1;
    }
  }

  Future<int> updateTag(TagFormModel tag) async {
    try {
      final result = await _tagHelper.updateTag(tag);
      return result;
    } catch (e) {
      _logger.e("Error updating tag: $e");
      return -1;
    }
  }

  Future<int> deleteTag(int id) async {
    try {
      final result = await _tagHelper.deleteTag(id);
      return result;
    } catch (e) {
      _logger.e("Error deleting tag: $e");
      return -1;
    }
  }

  Tag? getMatchingTag(String name, List<Tag> tags) {
    try {
      if (name.isEmpty) return null;
      final matchingTags = tags.where((tag) => tag.name == name);
      return matchingTags.isNotEmpty ? matchingTags.first : null;
    } on Exception catch (e) {
      _logger.e("Error getting tag ($name): $e");
      return null;
    }
  }
}
