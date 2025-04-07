import 'package:flutter/material.dart';
import 'package:goipvc/models/search_schedule.dart';
import 'package:goipvc/services/data_service.dart';
import 'package:goipvc/ui/widgets/skeleton.dart';

import '../../models/name_value_pair.dart';
import '../screens/schedule_search.dart';

class ManualScheduleForm extends StatefulWidget {
  const ManualScheduleForm({super.key});

  @override
  State<ManualScheduleForm> createState() => _ManualScheduleFormState();
}

class _ManualScheduleFormState extends State<ManualScheduleForm> {
  final _formKey = GlobalKey<FormState>();

  String? selectedYear;
  String? selectedSemester;
  String? selectedSchool;
  String? selectedDegree;

  bool showCourseInput = false;
  String? selectedCourse;
  Key _courseRefreshKey = UniqueKey();

  bool showClassInput = false;
  String? selectedClass;
  Key _classRefreshKey = UniqueKey();

  bool allowSearch = false;

  void shouldContinue() {
    showCourseInput = false;
    showClassInput = false;
    allowSearch = false;
    selectedClass = null;
    selectedCourse = null;

    if(selectedYear != null
        && selectedSemester != null
        && selectedSchool != null
        && selectedDegree != null) {
      showCourseInput = true;
    }

    _classRefreshKey = UniqueKey();
    _courseRefreshKey = UniqueKey();
  }

  void shouldShowClassInput() {
    showClassInput = false;
    allowSearch = false;
    selectedClass = null;
    _classRefreshKey = UniqueKey();

    if(selectedCourse != null) {
      showClassInput = true;
    }
  }

  void shouldAllowSearch() {
    if(selectedClass != null) {
      allowSearch = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Pesquisar Horário"),
      content: FutureBuilder(
          future: ScheduleService.getInitialOptions(),
          builder: (BuildContext context,
              AsyncSnapshot<SearchScheduleInitialOptions> snapshot) {
            if (snapshot.hasData) {
              var options = snapshot.data!;

              return Form(
                key: _formKey,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  DropdownButtonFormField<String>(
                    value: selectedYear,
                    decoration: InputDecoration(labelText: "Ano"),
                    isExpanded: true,
                    items: options.years.map((year) {
                      return DropdownMenuItem<String>(
                        value: year.value,
                        child: Text(year.name, overflow: TextOverflow.ellipsis),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedYear = value;
                        shouldContinue();
                      });
                    }
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: selectedSemester,
                    decoration: InputDecoration(labelText: "Semestre"),
                    isExpanded: true,
                    items: options.semesters.map((semester) {
                      return DropdownMenuItem<String>(
                        value: semester.value,
                        child: Text(semester.name, overflow: TextOverflow.ellipsis),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedSemester = value;
                        shouldContinue();
                      });
                    }
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: selectedSchool,
                    decoration: InputDecoration(labelText: "Escola"),
                    isExpanded: true,
                    items: options.schools.map((school) {
                      return DropdownMenuItem<String>(
                        value: school.value,
                        child: Text(school.name, overflow: TextOverflow.ellipsis),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedSchool = value;
                        shouldContinue();
                      });
                    }
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: selectedDegree,
                    decoration: InputDecoration(labelText: "Grau"),
                    isExpanded: true,
                    items: options.degrees.map((degree) {
                      return DropdownMenuItem<String>(
                        value: degree.value,
                        child: Text(degree.name, overflow: TextOverflow.ellipsis),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDegree = value;
                        shouldContinue();
                      });
                    }
                  ),

                  if(showCourseInput)
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: FutureBuilder(
                          future: ScheduleService.getCourses(selectedYear!, selectedDegree!, selectedSchool!),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<NameValuePair>> courses) {
                            if(courses.hasData) {
                              return DropdownButtonFormField<String>(
                                  key: _courseRefreshKey,
                                  value: selectedCourse,
                                  decoration: InputDecoration(labelText: "Curso"),
                                  isExpanded: true,
                                  items: courses.data!.map((course) {
                                    return DropdownMenuItem<String>(
                                      value: course.value,
                                      child: Text(course.name, overflow: TextOverflow.ellipsis),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedCourse = value;
                                      shouldShowClassInput();
                                    });
                                  }
                              );
                            } else if(courses.hasError) {
                              return Text("Erro a obter cursos");
                            } else {
                              return Skeleton(height: 56, width: 283);
                            }
                          }
                      )
                    ),

                  if(showClassInput)
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: FutureBuilder(
                          future: ScheduleService.getClasses(selectedYear!, selectedSemester!, selectedCourse!),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<NameValuePair>> classes) {
                            if(classes.hasData) {
                              return DropdownButtonFormField<String>(
                                  key: _classRefreshKey,
                                  value: selectedClass,
                                  decoration: InputDecoration(labelText: "Turma"),
                                  isExpanded: true,
                                  items: classes.data!.map((classData) {
                                    return DropdownMenuItem<String>(
                                      value: classData.value,
                                      child: Text(classData.name, overflow: TextOverflow.ellipsis),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedClass = value;
                                      shouldAllowSearch();
                                    });
                                  }
                              );
                            } else if(classes.hasError) {
                              return Text("Erro a obter turmas");
                            } else {
                              return Skeleton(height: 56);
                            }
                          }
                      ),
                    )
                ]),
              );
            } else if (snapshot.hasError) {
              return SizedBox(
                  height: 100,
                  child: Text(snapshot.error.toString()));
            } else {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Skeleton(height: 56, width: 239),
                  SizedBox(height: 20),
                  Skeleton(height: 56, width: 239),
                  SizedBox(height: 20),
                  Skeleton(height: 56, width: 239),
                  SizedBox(height: 20),
                  Skeleton(height: 56, width: 239)
                ],
              );
            }
          }),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Fechar"),
        ),
        TextButton(
          onPressed: allowSearch
            ? () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context)
                  => ScheduleSearchView(
                    year: selectedYear!,
                    semester: selectedSemester!,
                    classId: selectedClass!,
                  ))
              );
            } : null,
          child: Text("Pesquisar"),
        ),
      ],
    );
  }
}
