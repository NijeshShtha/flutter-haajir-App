import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/bloc/attendance_cubit.dart';
import 'package:my_app/models/attendance_record.dart';
import 'package:my_app/widgets/attendance_grid_card.dart';
import 'package:my_app/widgets/stats_card.dart';

class AttendanceHistoryScreen extends StatelessWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.surface.withAlpha(85),
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 20,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Divider(
            height: 1,
            color: colorScheme.outlineVariant.withAlpha(20),
          ),
        ),
        title: Row(
          children: [
            Icon(Icons.history, color: colorScheme.secondary),
            const SizedBox(width: 8),
            Text(
              'Attendance History',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: colorScheme.secondary),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocConsumer<AttendanceCubit, AttendanceState>(
        listener: (context, state) {
          if (state is AttendanceError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.red,
              )
            );
          }
        },
        builder: (context, state) {

          if (state is AttendanceLoading) {
            return Center(child: CircularProgressIndicator());
          } 

          late List<AttendanceRecord> records;

          if (state is AttendanceLoaded) {
            records = state.records;
          } else if (state is AttendanceError) {
            records =state.previousRecords;
          } else {
            records = [];
          }

          return RefreshIndicator(
              onRefresh: () async {
                context.read<AttendanceCubit>().loadAttendance();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stats Card
                    StatsCard(record: records),
                    const SizedBox(height: 16),
      
                    // Activity Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Activity',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                            letterSpacing: -0.24,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              DateTime.now().year.toString(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
      
                    // Contribution Grid Card
                    AttendanceGridCard(records: records),
                    const SizedBox(height: 16),
      
                    // Actions Section
                    Text(
                      'ACTIONS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.6,
                        color: colorScheme.onSurfaceVariant.withAlpha(7),
                      ),
                    ),
                    const SizedBox(height: 12),
      
                    // Primary Action Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          context.read<AttendanceCubit>().logAttendance();
                        },
                        icon: const Icon(Icons.check_circle, color: Colors.white),
                        label: const Text(
                          'Log Attendance Today',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.secondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
        },
      ),
    );
  }
}