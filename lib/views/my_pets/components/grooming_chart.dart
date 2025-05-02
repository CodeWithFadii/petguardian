import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class GroomingChart extends StatefulWidget {
  const GroomingChart({super.key});

  @override
  State<GroomingChart> createState() => _GroomingChartState();
}

class _GroomingChartState extends State<GroomingChart> {
  List<double> healthValues = [0, 0, 0, 0]; // initially 0 for animation
  final List<double> targetValues = [3, 1, 0, 2]; // actual values

  @override
  void initState() {
    super.initState();
    // Delay to simulate animation on screen re-entry
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        healthValues = targetValues;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final weekLabels = ['Week 1', 'Week 2', 'Week 3', 'Week 4'];
    // Calculate the maximum value in targetValues, defaulting to 0 if empty
    final double maxValue = targetValues.fold(0.0, (prev, element) => element > prev ? element : prev);
    // Set maxY to ceiling of maxValue plus 1 for padding, or 1 if maxValue is 0
    final double maxY = maxValue > 0 ? (maxValue.ceil() + 1).toDouble() : 1.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Grooming Sessions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Text('This month'),
          ],
        ),
        SizedBox(height: 4.h),
        AspectRatio(
          aspectRatio: 1.5,
          child: BarChart(
            BarChartData(
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (value) {
                    return Colors.white;
                  },
                ),
              ),
              alignment: BarChartAlignment.spaceAround,
              maxY: maxY, // Use dynamic maxY
              minY: 0,
              titlesData: FlTitlesData(
                show: true,
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    interval: 1, // Show every integer on y-axis
                    getTitlesWidget: (value, meta) => Text('${value.toInt()}'),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      int index = value.toInt();
                      if (index >= 0 && index < weekLabels.length) {
                        return Padding(
                          padding: EdgeInsets.only(top: 1.h),
                          child: Text(weekLabels[index], style: const TextStyle(fontSize: 12)),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups: List.generate(healthValues.length, (index) {
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: healthValues[index],
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(4),
                      width: 16,
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        toY: maxY, // Use dynamic maxY for background bars
                        color: Colors.grey.shade200,
                      ),
                    ),
                  ],
                );
              }),
              gridData: FlGridData(show: false), // hide grid lines
            ),
            swapAnimationDuration: const Duration(milliseconds: 800),
            swapAnimationCurve: Curves.easeOutCubic,
          ),
        ),
      ],
    );
  }
}
