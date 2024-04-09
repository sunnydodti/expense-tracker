import 'package:flutter/foundation.dart';

import '../models/tag.dart';
import '../service/tag_service.dart';

class TagProvider extends ChangeNotifier {
  late final Future<TagService> _tagService;

  TagProvider() {
    _init();
  }

  Future<void> _init() async {
    _tagService = TagService.create();
  }

  List<Tag> _tags = [];

  /// get list of all tags
  List<Tag> get tags => _tags;

  /// add an tag. this does not add in db
  void addTag(Tag tag) {
    _tags.add(tag);
    notifyListeners();
  }

  /// insert an tag. this does not insert in db
  void insertTag(int index, Tag tag) {
    _tags.insert(index, tag);
    notifyListeners();
  }

  /// get tag by id. this does not get from db
  Tag? getTag(int id) {
    try {
      return _tags.firstWhere((tag) => tag.id == id);
    } catch (e) {
      return null;
    }
  }

  /// edit an tag. this does not edit in db
  void editTag(Tag editedTag) {
    final index =
    _tags.indexWhere((tag) => tag.id == editedTag.id);
    if (index != -1) {
      _tags[index] = editedTag;
      notifyListeners();
    }
  }

  /// delete an tag at index. this does not delete in db
  void deleteTag(int id) {
    _tags.removeWhere((tag) => tag.id == id);
    notifyListeners();
  }

  /// refresh tags from db
  Future<void> refreshTags({bool notify = true}) async {
    try {
      List<Tag> tags = await _getTags();
      tags.sort((a, b) => b.createdAt.compareTo(a.modifiedAt));
      _tags = tags;
      if (notify) notifyListeners();
    } catch (e) {
      debugPrint('Error refreshing tags: $e');
    }
  }

  /// fetch updated tags from db
  Future<List<Tag>> _getTags() async {
    TagService tagService = await _tagService;
    return await tagService.getTags();
  }
}
