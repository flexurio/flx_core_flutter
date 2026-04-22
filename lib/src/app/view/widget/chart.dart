import 'package:flutter/material.dart';
import 'f_card.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class FlxDonutChart extends StatelessWidget {
  const FlxDonutChart({required this.title, super.key, this.dataSource});

  final List<ChartData>? dataSource;
  final String title;

  @override
  Widget build(BuildContext context) {
    return FCard(
      padding: const EdgeInsets.only(top: 12),
      child: SfCircularChart(
        title: ChartTitle(text: title),
        legend: const Legend(
          isVisible: true,
          overflowMode: LegendItemOverflowMode.wrap,
          position: LegendPosition.bottom,
        ),
        series: <DoughnutSeries<ChartData, String>>[
          DoughnutSeries<ChartData, String>(
            dataSource: dataSource,
            xValueMapper: (data, _) => data.label,
            yValueMapper: (data, _) => data.value,
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelPosition: ChartDataLabelPosition.outside,
              useSeriesColor: true,
            ),
            pointColorMapper: (data, _) => data.color,
          ),
        ],
      ),
    );
  }
}

class FlxPieChart extends StatelessWidget {
  const FlxPieChart({required this.title, super.key, this.dataSource});

  final List<ChartData>? dataSource;
  final String title;

  @override
  Widget build(BuildContext context) {
    return FCard(
      padding: const EdgeInsets.only(top: 12),
      child: SfCircularChart(
        title: ChartTitle(text: title),
        legend: const Legend(
          isVisible: true,
          overflowMode: LegendItemOverflowMode.wrap,
          position: LegendPosition.bottom,
        ),
        series: <PieSeries<ChartData, String>>[
          PieSeries<ChartData, String>(
            dataSource: dataSource,
            xValueMapper: (data, _) => data.label,
            yValueMapper: (data, _) => data.value,
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelPosition: ChartDataLabelPosition.outside,
              useSeriesColor: true,
            ),
            pointColorMapper: (data, _) => data.color,
          ),
        ],
      ),
    );
  }
}

class FlxBarChart extends StatelessWidget {
  const FlxBarChart({required this.title, super.key, this.dataSource});

  final List<ChartData>? dataSource;
  final String title;

  @override
  Widget build(BuildContext context) {
    return FCard(
      padding: const EdgeInsets.only(top: 12),
      child: SfCartesianChart(
        title: ChartTitle(text: title),
        primaryXAxis: const CategoryAxis(),
        legend: const Legend(
          isVisible: true,
          position: LegendPosition.bottom,
        ),
        series: <CartesianSeries<ChartData, String>>[
          ColumnSeries<ChartData, String>(
            dataSource: dataSource,
            xValueMapper: (data, _) => data.label,
            yValueMapper: (data, _) => data.value,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
            pointColorMapper: (data, _) => data.color,
          ),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData({
    required this.label,
    required this.value,
    required this.color,
  });
  final String label;
  final double value;
  final Color color;
}
