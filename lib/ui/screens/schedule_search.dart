import 'package:flutter/material.dart';
import 'package:goipvc/models/lesson.dart';
import 'package:goipvc/services/data_service.dart';
import 'package:goipvc/ui/screens/schedule.dart';

class ScheduleSearchView extends StatefulWidget {
  final String year;
  final String semester;
  final String classId;

  const ScheduleSearchView({
    super.key,
    required this.year,
    required this.semester,
    required this.classId
  });

  @override
  State<ScheduleSearchView> createState() => _ScheduleSearchViewState();
}

class _ScheduleSearchViewState extends State<ScheduleSearchView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Schedule for ${widget.classId}"),
      ),
      body: FutureBuilder(
          future: ScheduleService.search(widget.year, widget.semester, widget.classId),
          builder: (BuildContext context, AsyncSnapshot<List<Lesson>> snapshot) {
            if(snapshot.hasData) {
              return ScheduleScreen(customSchedule: snapshot.data);
            } else if (snapshot.hasError) {
              return Text("Failed to find schedule");
            } else {
              return Text("loading...");
            }
          }
      )
    );
  }
}