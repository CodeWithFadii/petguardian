import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class FeedingChart extends StatefulWidget {
  const FeedingChart({super.key});

  @override
  State<FeedingChart> createState() => _FeedingChartState();
}

class _FeedingChartState extends State<FeedingChart> {
  List<double> feedingValues = [0, 0, 0, 0, 0, 0, 0]; // initially 0 for animation
  final List<double> targetValues = [2, 3, 1, 4, 3.5, 2, 1]; // actual values

  @override
  void initState() {
    super.initState();
    // Delay to simulate animation on screen re-entry
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        feedingValues = targetValues;
      });
    });
  }

  List<DateTime> getCurrentWeekDates() {
    DateTime now = DateTime.now();
    int currentWeekday = now.weekday; // 1 = Monday
    DateTime monday = now.subtract(Duration(days: currentWeekday - 1));
    return List.generate(7, (index) => monday.add(Duration(days: index)));
  }

  List<String> getCurrentWeekDayNames() {
    return getCurrentWeekDates().map((date) => DateFormat('EEE').format(date)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final weekDays = getCurrentWeekDayNames();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Feeding', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Text('This week'),
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
              maxY: 5,
              minY: 0,
              titlesData: FlTitlesData(
                show: true,
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    getTitlesWidget: (value, meta) => Text('${value.toInt()}'),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      int index = value.toInt();
                      if (index >= 0 && index < weekDays.length) {
                        return Padding(
                          padding: EdgeInsets.only(top: 1.h),
                          child: Text(weekDays[index], style: const TextStyle(fontSize: 12)),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups: List.generate(feedingValues.length, (index) {
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: feedingValues[index],
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(4),
                      width: 16,
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        toY: 5,
                        color: Colors.grey.shade200,
                      ),
                    ),
                  ],
                );
              }),
              gridData: FlGridData(show: false), // hide grid lines
            ),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
          ),
        ),
      ],
    );
  }
}
