import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../data/helpers/color_helper.dart';
import '../../../models/enums/chart_range.dart';
import '../../../providers/ChartDataProvider.dart';
import '../../../service/chart_service.dart';

class ChartOptions extends StatelessWidget {
  const ChartOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChartDataProvider>(
      builder: (context, provider, child) {
        bool splitBarChart = provider.splitChart;

        Map<String, DateTime> dates = getStartAndEndDates(provider);

        return Container(
          color: ColorHelper.getTileColor(Theme.of(context)),
          padding: const EdgeInsets.only(top: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                      textScaleFactor: .9,
                      DateFormat('d MMM y').format(dates["start"]!)),
                  const Text(textScaleFactor: .9, "-"),
                  Text(
                      textScaleFactor: .9,
                      DateFormat('d MMM y').format(dates["end"]!)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () => decrementValue(provider),
                          icon: const Icon(Icons.chevron_left)),
                      Text(textScaleFactor: .9, _getSelectedValue(provider)),
                      IconButton(
                          onPressed: () => incrementValue(provider),
                          icon: const Icon(Icons.chevron_right)),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(textScaleFactor: .9, "Split"),
                      Checkbox(
                          value: splitBarChart,
                          onChanged: (value) => provider.toggleChartType(value))
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Map<String, DateTime> getStartAndEndDates(ChartDataProvider provider) {
    switch (provider.chartRange) {
      case ChartRange.weekly:
        return ChartService.getWeekStartAndEnd(provider.selectedWeek);
      case ChartRange.monthly:
        return ChartService.getMonthStartAndEnd(provider.selectedMonth);
      case ChartRange.yearly:
        return ChartService.getYearStartAndEnd(provider.selectedYear);
      case ChartRange.custom:
      // TODO: Handle this case.
        break;
    }

    return ChartService.getWeekStartAndEnd(provider.selectedWeek);
  }

  void decrementValue(ChartDataProvider provider) {
    switch (provider.chartRange) {
      case ChartRange.weekly:
        provider.decrementWeek();
        break;
      case ChartRange.monthly:
        provider.decrementMonth();
        break;
      case ChartRange.yearly:
        provider.decrementYear();
        break;
      case ChartRange.custom:
        // TODO: Handle this case.
        break;
    }
  }

  void incrementValue(ChartDataProvider provider) {
    switch (provider.chartRange) {
      case ChartRange.weekly:
        provider.incrementWeek();
        break;
      case ChartRange.monthly:
        provider.incrementMonth();
        break;
      case ChartRange.yearly:
        provider.incrementYear();
        break;
      case ChartRange.custom:
        // TODO: Handle this case.
        break;
    }
  }

  String _getSelectedValue(ChartDataProvider provider) {
    switch (provider.chartRange) {
      case ChartRange.weekly:
        {
          int week = provider.selectedWeek;
          return "Week $week";
        }
      case ChartRange.monthly:
        {
          int month = provider.selectedMonth;
          return DateFormat("MMMM").format(DateTime(0, month));
        }
      case ChartRange.yearly:
        {
          int year = provider.selectedYear;
          return DateFormat("yyyy").format(DateTime(year));
        }
      case ChartRange.custom:
        // TODO: Handle this case.
        break;
    }
    return "";
  }
}
