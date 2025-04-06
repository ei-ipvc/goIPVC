part of '../data_service.dart';

extension ScheduleService on DataService {
  static Future<SearchScheduleInitialOptions> getInitialOptions() async {
    final prefs = await SharedPreferences.getInstance();
    final serverUrl = prefs.getString('server_url') ?? '';
    final onToken = prefs.getString('on_token') ?? '';

    final response = await http.get(
      Uri.parse('$serverUrl/on/schedule/search-options'),
      headers: {
        'x-auth-on': onToken,
      },
    );

    return SearchScheduleInitialOptions.fromJson(jsonDecode(response.body));
  }

  static Future<List<NameValuePair>> getCourses(String year, String degree, String school) async {
    final prefs = await SharedPreferences.getInstance();
    final serverUrl = prefs.getString('server_url') ?? '';
    final onToken = prefs.getString('on_token') ?? '';

    final uri = Uri.parse("$serverUrl/on/schedule/course-list").replace(
      queryParameters: {
        'year': year,
        'degree': degree,
        'school': school,
      }
    );

    final response = await http.get(
      uri,
      headers: {
        'x-auth-on': onToken,
      },
    );

    return (jsonDecode(response.body) as List<dynamic>).map((lesson) {
      return NameValuePair.fromJson(lesson);
    }).toList();
  }

  static Future<List<NameValuePair>> getClasses(String year, String semester, String course) async {
    final prefs = await SharedPreferences.getInstance();
    final serverUrl = prefs.getString('server_url') ?? '';
    final onToken = prefs.getString('on_token') ?? '';

    final uri = Uri.parse("$serverUrl/on/schedule/class-list").replace(
        queryParameters: {
          'year': year,
          'semester': semester,
          'course': course,
        }
    );

    final response = await http.get(
      uri,
      headers: {
        'x-auth-on': onToken,
      },
    );

    return (jsonDecode(response.body) as List<dynamic>).map((lesson) {
      return NameValuePair.fromJson(lesson);
    }).toList();
  }

  static Future<List<Lesson>> search(String year, String semester, String classId) async {
    final prefs = await SharedPreferences.getInstance();
    final serverUrl = prefs.getString('server_url') ?? '';
    final onToken = prefs.getString('on_token') ?? '';

    final uri = Uri.parse("$serverUrl/on/schedule/search").replace(
        queryParameters: {
          'year': year,
          'semester': semester,
          'classId': classId,
        }
    );

    final response = await http.get(
      uri,
      headers: {
        'x-auth-on': onToken,
      },
    );

    return (jsonDecode(response.body) as List<dynamic>).map((lesson) {
      return Lesson.fromJson(lesson);
    }).toList();
  }
}