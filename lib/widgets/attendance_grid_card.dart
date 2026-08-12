import 'package:flutter/material.dart';
import 'package:my_app/models/attendance_record.dart';

import 'legend_item.dart';

class AttendanceGridCard extends StatelessWidget {
  const AttendanceGridCard({required this.records, super.key});

  final List<AttendanceRecord> records;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Grid Status Array mapping to HTML colors:
    // 1: Present (#2E7D32)
    // 0: Off (surfaceContainer)
    // 2: Leave (surfaceContainerHighest / surface-variant)
    final currentDate = DateTime.now();
    final lengthThisMonth = DateUtils.getDaysInMonth(
      currentDate.year,
      currentDate.month,
    );
    final daysInGrid = List.generate(
      lengthThisMonth,
      (index) => DateTime(
        currentDate.year,
        currentDate.month,
        1,
      ).add(Duration(days: index)),
    );

    final recordsByDate = Map.fromEntries(
      records.map((record) => MapEntry(record.date, record.status)).toList(),
    );

    final firstWeekDayOfMonth = DateUtils.firstDayOffset(
      currentDate.year,
      currentDate.month,
      MaterialLocalizations.of(context),
    );

    final List<int> dynamicGridData = daysInGrid.map((date) {
      final statusForCurrentDate = recordsByDate[date];
      if (statusForCurrentDate != null) {
        return statusForCurrentDate ? 1 : 0;
      } else {
        return 0;
      }
    }).toList()..insertAll(0, List.filled(firstWeekDayOfMonth - 1, 0));

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant.withAlpha(3)),
      ),
      child: Column(
        children: [
          // Days Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                .map(
                  (day) => Expanded(
                    child: Center(
                      child: Text(
                        day,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF45464D),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),

          // 7-Column Contribution Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: dynamicGridData.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
              childAspectRatio: 1.0,
            ),
            itemBuilder: (context, index) {
              final status = dynamicGridData[index];
              Color boxColor;

              switch (status) {
                case 1:
                  boxColor = const Color(0xFF2E7D32); // Present Green
                  break;
                case 2:
                  boxColor = colorScheme.surfaceContainerHighest; // Leave
                  break;
                case 0:
                default:
                  boxColor = colorScheme.surfaceContainer; // Off
                  break;
              }

              return Container(
                decoration: BoxDecoration(
                  color: boxColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // Legend
          Divider(height: 1, color: colorScheme.outlineVariant.withAlpha(2)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const LegendItem(color: Color(0xFF2E7D32), label: 'Present'),
              const SizedBox(width: 24),
              LegendItem(
                color: colorScheme.surfaceContainerHighest,
                label: 'Leave',
              ),
              const SizedBox(width: 24),
              LegendItem(color: colorScheme.surfaceContainer, label: 'Off'),
            ],
          ),
        ],
      ),
    );
  }
}
