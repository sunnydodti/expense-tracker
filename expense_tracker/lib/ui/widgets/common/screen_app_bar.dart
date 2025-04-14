import 'package:flutter/material.dart';

import '../../../data/helpers/color_helper.dart';
import '../../../data/helpers/navigation_helper.dart';

class ScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  const ScreenAppBar({super.key, this.title = '', this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: SafeArea(
          child: BackButton(
        onPressed: () => NavigationHelper.navigateBack(context),
      )),
      centerTitle: true,
      title: Text(
        title,
        textScaler: const TextScaler.linear(.9),
        overflow: TextOverflow.fade,
      ),
      actions: actions,
      backgroundColor: ColorHelper.getScreenAppBarColor(Theme.of(context)),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
