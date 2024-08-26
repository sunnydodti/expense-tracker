import 'dart:io';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../data/helpers/color_helper.dart';

class ChartWidgets {

  static Widget getDayTitles(BuildContext context, double value, TitleMeta meta) {
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

  static Widget getWeekTitlesForMonth(BuildContext context, double value, TitleMeta meta) {
    final week = value.toInt();

    Widget text = Text(
      'Week $week',
      style: TextStyle(
        color: ColorHelper.getIconColor(Theme.of(context)),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }

  static Widget getMonthTitles(
      BuildContext context, double value, TitleMeta meta) {
    final int monthIndex = value.toInt();
    String monthName;

    switch (monthIndex) {
      case 1:
        monthName = 'Jan';
        break;
      case 2:
        monthName = 'Feb';
        break;
      case 3:
        monthName = 'Mar';
        break;
      case 4:
        monthName = 'Apr';
        break;
      case 5:
        monthName = 'May';
        break;
      case 6:
        monthName = 'Jun';
        break;
      case 7:
        monthName = 'Jul';
        break;
      case 8:
        monthName = 'Aug';
        break;
      case 9:
        monthName = 'Sep';
        break;
      case 10:
        monthName = 'Oct';
        break;
      case 11:
        monthName = 'Nov';
        break;
      case 12:
        monthName = 'Dec';
        break;
      default:
        monthName = '';
    }
    if (Platform.isAndroid || Platform.isIOS) {
      monthName = monthName.substring(0, 1);
    }

    Widget text = Text(
      monthName,
      style: TextStyle(
        color: ColorHelper.getIconColor(Theme.of(context)),
        fontWeight: FontWeight.bold,
        fontSize: 10,
      ),
    );

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