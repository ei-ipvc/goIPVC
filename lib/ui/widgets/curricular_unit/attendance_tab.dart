import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goipvc/models/curricular_unit.dart';
import 'package:goipvc/providers/data_providers.dart';

import 'package:goipvc/ui/widgets/card.dart';
import 'package:goipvc/ui/widgets/curricular_unit/summary.dart';

class AttendanceTab extends ConsumerWidget {
  final CurricularUnit curricularUnit;

  const AttendanceTab({
    super.key,
    required this.curricularUnit
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summariesAsync = ref.watch(lessonSummariesProvider(curricularUnit.id));

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(lessonSummariesProvider(curricularUnit.id));
      },
      child: summariesAsync.when(
        data: (summaries) {
          if (summaries.isEmpty) {
            return Center(
              child: Text('No summaries available'),
            );
          }

          final reversedSummaries = summaries.reversed.toList();

          return SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6
                  ),
                  child: Row(
                    children: [
                      AttendanceCard(
                        type: "TP",
                        quantity: 7,
                        total: 10,
                        attendanceClass: "A",
                      ),
                      SizedBox(width: 10),
                      AttendanceCard(
                        type: "PL",
                        quantity: 7,
                        total: 10,
                        attendanceClass: "A",
                      ),
                      SizedBox(width: 10),
                      AttendanceCard(
                        type: "T",
                        quantity: 7,
                        total: 10,
                        attendanceClass: "A",
                      ),
                    ],
                  ),
                ),

                ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: reversedSummaries.length,
                  itemBuilder: (context, index) {
                    return SummaryCard(
                      summary: reversedSummaries[index],
                      presenceStatus: null,
                    );
                  },
                ),
              ],
            ),
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Error loading summaries: ${error.toString()}'),
        ),
      ),
    );
  }
}

class AttendanceCard extends StatelessWidget{
  final String type;
  final double quantity;
  final double total;
  final String attendanceClass;

  const AttendanceCard({
    super.key,
    required this.type,
    required this.quantity,
    required this.total,
    required this.attendanceClass,
  });

  @override
  Widget build(BuildContext context) {
    final double percentage = quantity / total;

    return Expanded(
      child: FilledCard(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                    type,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                    )
                ),
                SizedBox(height: 8),
                Stack(
                  children: [
                    SizedBox(
                      width: 54,
                      height: 54,
                      child: CircularProgressIndicator(
                        value: percentage,
                        backgroundColor: Theme.of(context).colorScheme.surfaceDim,
                        color: Theme.of(context).colorScheme.primary,
                        strokeWidth: 5,
                      ),
                    ),
                    SizedBox(
                      width: 54,
                      height: 54,
                      child: Center(
                        child: Text(
                          "${(percentage * 100).toInt()}%",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                    "$quantity/$total",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 16
                    )
                ),
                Text(
                    "Turma $attendanceClass",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 14
                    )
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

}
