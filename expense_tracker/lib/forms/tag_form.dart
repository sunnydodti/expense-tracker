import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../models/tag.dart';
import '../providers/tag_provider.dart';
import '../service/tag_service.dart';

class TagForm extends StatefulWidget {
  final List<Tag> tags;

  const TagForm({Key? key, required this.tags}) : super(key: key);

  @override
  State<TagForm> createState() => _TagFormState();
}

class _TagFormState extends State<TagForm> {
  final _formKey = GlobalKey<FormState>();
  static final Logger _logger =
      Logger(printer: SimplePrinter(), level: Level.info);
  final _tagController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true, // Compact spacing
      title: Form(
        key: _formKey,
        child: TextFormField(
          controller: _tagController,
          decoration: InputDecoration(
              hintText: "Add Tag Name",
              labelStyle: TextStyle(
                color: Colors.green.shade300,
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                color: Colors.green.shade500,
              )),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                color: Colors.green.shade300,
              )),
              label: const Text("New Tag")),
          validator: _validateNewTag,
          onSaved: submitTag,
          onChanged: (value) {
            _logger.i("tag: $value");
          },
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.add, color: Colors.green),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
          }
        },
      ),
    );
  }

  void submitTag(newValue) async {
    if (_formKey.currentState?.validate() ?? false) {
      TagFormModel tag = TagFormModel(name: _tagController.text.trim());
      _addTag(tag).then((value) {
        if (value > 0) {
          _tagController.clear();
          _refreshTags();
        }
      });
    }
  }

  Future<int> _addTag(TagFormModel tag) async {
    TagService tagService = await TagService.create();
    return tagService.addTag(tag);
  }

  void _refreshTags() {
    final tagProvider = Provider.of<TagProvider>(context, listen: false);
    tagProvider.refreshTags();
  }

  String? _validateNewTag(value) {
    if (_tagController.text.isEmpty) {
      return 'Please enter a tag name.';
    }
    if (isDuplicateTag()) return "Tag must be unique";
    return null; // Valid input returns null
  }

  bool isDuplicateTag() {
    for (Tag tag in widget.tags) {
      if (tag.name == _tagController.text) return true;
    }
    return false;
  }
}
