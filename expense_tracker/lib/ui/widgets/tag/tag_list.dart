import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/constants/ui_constants.dart';
import '../../../data/helpers/color_helper.dart';
import '../../../models/tag.dart';
import '../../../providers/tag_provider.dart';
import '../../../service/tag_service.dart';
import '../../forms/tag_form.dart';
import '../empty_list_widget.dart';
import 'tag_tile.dart';

class TagList extends StatelessWidget {
  const TagList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TagProvider>(
      builder: (context, tagProvider, child) => RefreshIndicator(
        onRefresh: () => tagProvider.refreshTags(),
        color: Colors.blue.shade500,
        child: Column(
          children: [
            getTagForm(tagProvider.tags, context),
            Expanded(
              child: tagProvider.tags.isEmpty
                  ? const EmptyListWidget(listName: 'Tag')
                  : Scrollbar(
                      interactive: true,
                      radius: const Radius.circular(uiScrollbarRadius),
                      child: ListView.builder(
                        itemCount: tagProvider.tags.length,
                        itemBuilder: (context, index) {
                          final tag = tagProvider.tags[index];
                          return TagTile(
                              tagName: tag.name,
                              onDelete: () => _deleteTag(context, tag),);
                        },
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }

  _deleteTag(BuildContext context, Tag tag) async {
    TagService tagService = await TagService.create();
    tagService.deleteTag(tag.id).then((value) {
      if (value > 0) {
        if (context.mounted) _refreshTags(context);
      }
    });
  }

  _refreshTags(BuildContext context) {
    final tagProvider = Provider.of<TagProvider>(context, listen: false);
    tagProvider.refreshTags();
  }

  Container getTagForm(List<Tag> tags, BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: ColorHelper.getTileColor(Theme.of(context)),
        ),
        padding: const EdgeInsets.symmetric(
            horizontal: uiPaddingHalf, vertical: uiPaddingHalf),
        margin: const EdgeInsets.only(
            top: uiMarginHalf, bottom: uiMarginQuarter),
        child: TagForm(tags: tags));
  }
}
