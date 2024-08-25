import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../data/helpers/color_helper.dart';

class ChartWidgets {

  static Widget getTitles(BuildContext context, double value, TitleMeta meta) {
    TextStyle style = TextStyle(
      color: ColorHelper.getIconColor(Theme.of(context)),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = Text('M', style: style);
        break;
      case 2:
        text = Text('T', style: style);
        break;
      case 3:
        text = Text('W', style: style);
        break;
      case 4:
        text = Text('T', style: style);
        break;
      case 5:
        text = Text('F', style: style);
        break;
      case 6:
        text = Text('S', style: style);
        break;
      case 7:
        text = Text('S', style: style);
        break;
      default:
        text = Text('', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }

  static Widget leftTitleWidgets(double value, TitleMeta meta) {
    String text = meta.formattedValue;
    if (value % meta.appliedInterval != 0) text = "";
    return Text(text, textScaleFactor: .85, textAlign: TextAlign.center);
  }
}