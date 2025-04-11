import 'package:flutter/material.dart';
import 'package:goipvc/models/summary.dart';
import 'package:goipvc/ui/widgets/dot.dart';

class SummaryScreen extends StatelessWidget {
  final Summary summary;

  const SummaryScreen({
    super.key,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sumário'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SummaryHeader(summary: summary),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        summary.summaryText,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SummarySheet(
            summary: summary,
          )
        ],
      ),
    );
  }
}

class SummaryHeader extends StatelessWidget {
  final Summary summary;

  const SummaryHeader({
    super.key,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    summary.classType,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Dot(),
                  Text(
                    summary.date,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                summary.time,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider()
        ],
      )
    );
  }
}

class SummarySheet extends StatelessWidget {
  final Summary summary;

  const SummarySheet({
    super.key,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.16,
      minChildSize: 0.16,
      snap: true,
      snapSizes: [0.16, 0.5],
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16),
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context)
                    .colorScheme
                    .shadow
                    .withValues(alpha: 0.1),
                blurRadius: 16,
              ),
            ],
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom,
          ),
          child: ListView(
            controller: scrollController,
            children: [
              Container(
                height: 24,
                alignment: Alignment.center,
                child: Container(
                  width: 48,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.person,
                              size: 12,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              summary.teacher,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        SizedBox(width: 16),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 12,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              summary.room,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        )
                      ],
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 6),
                      child: Text(
                        'Bibliografia',
                        style: TextStyle(
                          fontSize: 22,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    Text(
                      summary.bibliography.isEmpty
                          ? 'Não há bibliografia disponível para este sumário.'
                          : summary.bibliography,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}