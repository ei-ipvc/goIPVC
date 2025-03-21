import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goipvc/models/curricular_unit.dart';
import 'package:goipvc/models/lesson.dart';
import 'package:goipvc/models/student.dart';
import 'package:goipvc/models/tuition_fee.dart';
import 'package:goipvc/models/task.dart';
import 'package:goipvc/services/data_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

final providerContainer = ProviderContainer();

final dataServiceProvider = Provider<DataService>((ref) {
  return DataService(ref);
});

final prefsProvider = FutureProvider<Map<String, String?>>((ref) async {
  final prefs = await SharedPreferences.getInstance();

  return {
    'server_url': prefs.getString('server_url'),
    'username': prefs.getString('username'),
    'password': prefs.getString('password'),
    'on_token': prefs.getString('on_token'),
    'sas_authorization': prefs.getString('sas_authorization'),
    'sas_token': prefs.getString('sas_token'),
    'academicos_token': prefs.getString('academicos_token'),
    'moodle_sesskey': prefs.getString('moodle_sesskey'),
    'moodle_token': prefs.getString('moodle_token'),
  };
});

final firstNameProvider = FutureProvider<String>((ref) async {
  final dataService = ref.read(dataServiceProvider);
  return await dataService.getFirstName() ?? 'utilizador';
});

final balanceProvider = FutureProvider<String>((ref) async {
  final dataService = ref.read(dataServiceProvider);
  return (await dataService.getBalance()).toString();
});

final studentIdProvider = FutureProvider<int>((ref) async {
  final dataService = ref.read(dataServiceProvider);
  return await dataService.getStudentId();
});

final lessonsProvider = FutureProvider<List<Lesson>>((ref) async {
  final dataService = ref.read(dataServiceProvider);
  final studentId = await dataService.getStudentId();
  final lessons = await dataService.getLessons(studentId);
  return lessons;
});

final tasksProvider = FutureProvider<List<Task>>((ref) async {
  final dataService = ref.read(dataServiceProvider);
  return dataService.getTasks();
});

final combinedProvider =
    FutureProvider.autoDispose<(List<Lesson>, List<Task>)>((ref) async {
  final lessons = await ref.watch(lessonsProvider.future);
  final tasks = await ref.watch(tasksProvider.future);
  return (lessons, tasks);
});

final studentInfoProvider = FutureProvider<Student>((ref) async {
  final dataService = ref.read(dataServiceProvider);
  return dataService.getStudentInfo();
});

final studentImageProvider = FutureProvider<Uint8List>((ref) async {
  final dataService = ref.read(dataServiceProvider);
  final studentInfo = await ref.watch(studentInfoProvider.future);
  final studentId = studentInfo.studentId;
  return dataService.getStudentImage(studentId);
});

final curricularUnitProvider =
    FutureProvider.family<CurricularUnit, int>((ref, curricularUnitId) async {
  final dataService = ref.read(dataServiceProvider);
  return dataService.getCurricularUnit(curricularUnitId);
});

final curricularUnitsResponseProvider =
    FutureProvider<Map<String, dynamic>>((ref) async {
  final dataService = ref.read(dataServiceProvider);
  return dataService.getCurricularUnits();
});

final curricularUnitsProvider =
    FutureProvider<List<CurricularUnit>>((ref) async {
  final response = await ref.watch(curricularUnitsResponseProvider.future);
  return response['curricularUnits'] as List<CurricularUnit>;
});

final averageGradeProvider = FutureProvider<double>((ref) async {
  final response = await ref.watch(curricularUnitsResponseProvider.future);
  return response['avgGrade'] as double;
});

final tuitionsProvider = FutureProvider<List<TuitionFee>>((ref) async {
  final dataService = ref.read(dataServiceProvider);
  return dataService.getTuitionFees();
});
