import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:petguardian/resources/constants/app_colors.dart';
import 'package:petguardian/resources/constants/constants.dart';
import 'package:sizer/sizer.dart';

class HealthChart extends StatefulWidget {
  final String petId;
  const HealthChart({super.key, required this.petId});

  @override
  State<HealthChart> createState() => _HealthChartState();
}

class _HealthChartState extends State<HealthChart> {
  List<double> HealthValues = [0, 0, 0, 0, 0, 0, 0];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchHealthHistory();
  }

  Future<void> fetchHealthHistory() async {
    try {
      final now = DateTime.now();
      // Set time to start of day for Monday
      final monday = DateTime(now.year, now.month, now.day).subtract(Duration(days: now.weekday - 1));
      // Set time to end of day for Sunday
      final sunday = DateTime(
        now.year,
        now.month,
        now.day,
      ).add(Duration(days: 7 - now.weekday)).add(const Duration(hours: 23, minutes: 59, seconds: 59));

      log('Fetching Health history for week: ${monday.toString()} to ${sunday.toString()}');

      // Initialize counts for each day of the week
      List<int> dailyCounts = List.filled(7, 0);

      // Fetch Health history for the current week
      final snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('pets')
              .doc(widget.petId)
              .collection('health_history')
              .where('completedAt', isGreaterThanOrEqualTo: Timestamp.fromDate(monday))
              .where('completedAt', isLessThanOrEqualTo: Timestamp.fromDate(sunday))
              .get();

      log('Found ${snapshot.docs.length} Health records');

      // Count Health sessions for each day
      for (var doc in snapshot.docs) {
        final completedAt = (doc.data()['completedAt'] as Timestamp).toDate();
        final dayIndex = completedAt.weekday - 1; // Convert to 0-based index
        log('Health on ${completedAt.toString()}, day index: $dayIndex');
        if (dayIndex >= 0 && dayIndex < 7) {
          dailyCounts[dayIndex]++;
        }
      }

      log('Daily counts: $dailyCounts');

      // Update the chart values
      setState(() {
        HealthValues = dailyCounts.map((count) => count.toDouble()).toList();
        isLoading = false;
      });
    } catch (e) {
      log('Error fetching Health history: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  List<DateTime> getCurrentWeekDates() {
    DateTime now = DateTime.now();
    int currentWeekday = now.weekday;
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
            const Text('Health', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Text('This week'),
          ],
        ),
        SizedBox(height: 4.h),
        if (isLoading)
          Center(child: CircularProgressIndicator())
        else
          AspectRatio(
            aspectRatio: 1.5,
            child: BarChart(
              BarChartData(
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    tooltipRoundedRadius: 8,
                    tooltipPadding: const EdgeInsets.all(8),
                    tooltipMargin: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${rod.toY.toInt()} sessions',
                        const TextStyle(color: Colors.white),
                      );
                    },
                  ),
                ),
                alignment: BarChartAlignment.spaceAround,
                maxY: HealthValues.isEmpty ? 5 : HealthValues.reduce((a, b) => a > b ? a : b) + 1,
                minY: 0,
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        if (value == 0) return const Text('0');
                        if (value == 1) return const Text('1');
                        if (value == 2) return const Text('2');
                        if (value == 3) return const Text('3');
                        if (value == 4) return const Text('4');
                        if (value == 5) return const Text('5');
                        return const Text('');
                      },
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
                barGroups: List.generate(HealthValues.length, (index) {
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: HealthValues[index],
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(4),
                        width: 16,
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: HealthValues.isEmpty ? 5 : HealthValues.reduce((a, b) => a > b ? a : b) + 1,
                          color: Colors.grey.shade200,
                        ),
                      ),
                    ],
                  );
                }),
                gridData: FlGridData(show: false),
              ),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
            ),
          ),
      ],
    );
  }
}
