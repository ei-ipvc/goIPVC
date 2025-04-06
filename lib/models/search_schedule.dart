import 'name_value_pair.dart';

class SearchScheduleInitialOptions {
  List<NameValuePair> years;
  List<NameValuePair> semesters;
  List<NameValuePair> schools;
  List<NameValuePair> degrees;

  SearchScheduleInitialOptions({
    required this.years,
    required this.semesters,
    required this.schools,
    required this.degrees,
  });

  factory SearchScheduleInitialOptions.fromJson(Map<String, dynamic> json) {
    return SearchScheduleInitialOptions(
      years: (json['years'] as List)
          .map((e) => NameValuePair.fromJson(e))
          .toList(),
      semesters: (json['semesters'] as List)
          .map((e) => NameValuePair.fromJson(e))
          .toList(),
      schools: (json['schools'] as List)
          .map((e) => NameValuePair.fromJson(e))
          .toList(),
      degrees: (json['degrees'] as List)
          .map((e) => NameValuePair.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'years': years.map((e) => e.toJson()).toList(),
      'semesters': semesters.map((e) => e.toJson()).toList(),
      'schools': schools.map((e) => e.toJson()).toList(),
      'degrees': degrees.map((e) => e.toJson()).toList(),
    };
  }
}