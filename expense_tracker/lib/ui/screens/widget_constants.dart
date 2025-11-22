import 'package:flutter/material.dart';

import '../../data/constants/ui_constants.dart';

const Widget wcSpinnerDefault = Center(child: CircularProgressIndicator());

Widget wcErrorText(String text) => Text('Error: $text');

Widget wcSnapshotErrorText(Object? errorObject) => Text('Error: $errorObject');

const Divider wcDivider = Divider(thickness: uiDividerThicknessX2);
const Divider wcDividerIndented = Divider(
    thickness: uiDividerThicknessX2, indent: uiPadding, endIndent: uiPadding);
