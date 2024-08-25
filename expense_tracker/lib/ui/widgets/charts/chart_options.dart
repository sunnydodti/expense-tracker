import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../data/helpers/color_helper.dart';
import '../../../providers/ChartDataProvider.dart';
import '../../../service/chart_service.dart';

class ChartOptions extends StatelessWidget {
  const ChartOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChartDataProvider>(
      builder: (context, provider, child) {
        int selectedWeek = provider.selectedWeek;
        int currentWeek = provider.currentWeek;
        bool splitBarChart = provider.splitChart;

        Map<String, DateTime> dates = ChartService.getWeekStartAndEnd(
            selectedWeek == 0 ? currentWeek : selectedWeek);

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
                          onPressed: provider.decrementWeek,
                          icon: const Icon(Icons.chevron_left)),
                      Text(
                          textScaleFactor: .9,
                          "Week ${selectedWeek == 0 ? currentWeek : selectedWeek}"),
                      IconButton(
                          onPressed: provider.incrementWeek,
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
}
