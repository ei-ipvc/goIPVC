class Summary {
  Summary({
    required this.id,
    required this.date,
    required this.time,
    required this.classType,
    required this.room,
    required this.teacher,
    required this.summaryText,
    required this.bibliography,
  });

  int id;
  String date;
  String time;
  String classType;
  String room;
  String teacher;
  String summaryText;
  String bibliography;

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      id: json['id'] as int,
      date: json['date'] as String,
      time: json['time'] as String,
      classType: json['class'] as String,
      room: json['room'] as String,
      teacher: json['teacher'] as String,
      summaryText: json['summary'] as String,
      bibliography: json['bibliography'] as String,
    );
  }
}
