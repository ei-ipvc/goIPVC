import 'package:flutter/material.dart';
import 'package:goipvc/models/summaries.dart';
import 'package:goipvc/ui/widgets/card.dart';
import 'package:goipvc/ui/widgets/dot.dart';

class SummaryCard extends StatelessWidget {
  final Summary summary;
  final bool? presenceStatus;

  const SummaryCard({
    super.key,
    required this.summary,
    this.presenceStatus,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;

    switch (presenceStatus) {
      case true:
        statusColor = Colors.green;
        statusText = 'Presente';
        break;
      case false:
        statusColor = Colors.red;
        statusText = 'Falta';
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'Sem Estado';
    }

    String getFirstAndLastName(String fullName) {
      final nameParts = fullName.split(' ');
      if (nameParts.length <= 2) return fullName;
      return '${nameParts.first} ${nameParts.last}';
    }

    return FilledCard(
      titleWidget: Row(
        children: [
          Text(
            summary.classType,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Dot(),
          Text(
            summary.date,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              statusText,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      footer: Row(
        children: [
          Icon(
            Icons.person,
            size: 20,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          SizedBox(width: 4),
          Text(
            getFirstAndLastName(summary.teacher),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          Dot(),
          Icon(
            Icons.location_on,
            size: 20,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          SizedBox(width: 4),
          Text(
            summary.room,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      children: [
        if (summary.summaryText.isNotEmpty)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Text(
                        summary.summaryText,
                        style: TextStyle(fontSize: 14),
                        maxLines: 3,
                        overflow: TextOverflow.fade,
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Theme.of(context).colorScheme.surfaceContainer
                                    .withAlpha(0),
                              Theme.of(context).colorScheme.surfaceContainer
                                  .withAlpha(128),
                                Theme.of(context).colorScheme.surfaceContainer,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward_ios_rounded)
              ],
            )
          ),
      ],
    );
  }
}