import 'package:flutter/material.dart';
import 'package:goipvc/main.dart';
import 'package:goipvc/services/notifications.dart';
import 'package:http/http.dart' as http;
import 'package:goipvc/ui/widgets/dropdown.dart';
import 'package:goipvc/ui/widgets/list_section.dart';
import 'package:goipvc/ui/widgets/containers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: ListView(
        children: <Widget>[
          ThemeSettings(),
          Divider(),
          NotificationSettings(),
          // Divider(),
          // PreferenceSettings(),
          // Divider(),
          // ExtraSettings(),
        ],
      ),
    );
  }
}

class ThemeSettings extends StatefulWidget {
  const ThemeSettings({super.key});

  @override
  ThemeSettingsState createState() => ThemeSettingsState();
}

class ThemeSettingsState extends State<ThemeSettings> {
  String _themeValue = "system";

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _themeValue = prefs.getString('theme') ?? 'system';
    });
  }

  Future<void> _saveTheme(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', value);
  }

  void _changeTheme(String? value) {
    if (value != null) {
      setState(() {
        _themeValue = value;
      });
      _saveTheme(value);
      if (value == 'dark') {
        App.of(context).changeTheme(ThemeMode.dark);
      } else if (value == 'light') {
        App.of(context).changeTheme(ThemeMode.light);
      } else {
        App.of(context).changeTheme(ThemeMode.system);
      }
    }
  }

  void showSchoolBottomSheet(BuildContext context) {
    List<Map<String, String>> schools = [
      {"IPVC": "0xFF000000"},
      {"ESTG": "0xFFf3ab1d"},
      {"ESS": "0xFFdca7ac"},
      {"ESE": "0xFF0054a4"},
      {"ESDL": "0xFF828181"},
      {"ESCE": "0xFFe51a2c"},
      {"ESA": "0xFF00a885"},
    ];

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(child: StatefulBuilder(
          builder: (context, setState) {
            String? selectedSchool = "IPVC";

            Widget buildSchoolButton(Map<String, String> school) {
              final name = school.keys.first;
              final color = Color(int.parse(school.values.first));
              final isSelected = selectedSchool == name;

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 4)
                          : null,
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      onTap: () => setState(() => selectedSchool = name),
                      child: Center(
                        child: Text(
                          name,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }

            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.outline,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Escolher Escola",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 24),
                  Column(
                    children: [
                      Row(
                        children: schools
                            .sublist(0, 4)
                            .map((school) => buildSchoolButton(school))
                            .toList(),
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: schools
                            .sublist(4)
                            .map((school) => buildSchoolButton(school))
                            .toList(),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                ],
              ),
            );
          },
        ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListSection(title: "Aparência", children: [
      ListTile(
        leading: Icon(Icons.brightness_medium),
        title: Text("Tema"),
        trailing: Dropdown<String>(
          value: _themeValue,
          items: [
            DropdownMenuItem<String>(
              value: "system",
              child: Text("Sistema"),
            ),
            DropdownMenuItem<String>(
              value: "dark",
              child: Text("Escuro"),
            ),
            DropdownMenuItem<String>(
              value: "light",
              child: Text("Claro"),
            ),
          ],
          onChanged: _changeTheme,
        ),
      ),
      /*ListTile(
        leading: Icon(Icons.palette),
        title: Text("Esquema de Cores"),
        trailing: Dropdown<String>(
          value: "system",
          items: [
            DropdownMenuItem<String>(
              value: "system",
              child: Text("Sistema"),
            ),
            DropdownMenuItem<String>(
              value: "school",
              child: Text("Escola"),
            ),
          ],
          onChanged: (String? value) {},
        ),
      ),
      ListTile(
        title: Text("Escolher Escola"),
        trailing: Icon(Icons.chevron_right),
        onTap: () {
          showSchoolBottomSheet(context);
        },
      ),*/
    ]);
  }
}

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({super.key});

  @override
  NotificationSettingsState createState() => NotificationSettingsState();
}

class NotificationSettingsState extends State<NotificationSettings> {
  bool lessonNotifsEnabled = false;
  String lessonNotifsTime = "5";

  Future<void> _loadNotificationSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final savedNotificationState = prefs.getInt('lesson_notifs') ?? 0;
    setState(() {
      lessonNotifsEnabled = savedNotificationState != 0;
      if (lessonNotifsEnabled) {
        lessonNotifsTime = savedNotificationState.toString();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
  }

  Future<void> _toggleLessonNotifs(bool value) async {
    await Notifications.init();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      await prefs.setInt('lesson_notifs', int.parse(lessonNotifsTime));
    } else {
      await prefs.setInt('lesson_notifs', 0);
    }
    setState(() {
      lessonNotifsEnabled = value;
    });
  }

  Future<void> _saveLessonNotifTime(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (lessonNotifsEnabled) {
      await prefs.setInt('lesson_notifs', int.parse(value));
      setState(() {
        lessonNotifsTime = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListSection(title: "Notificações", children: [
      ListTile(
        leading: Icon(Icons.notifications_on),
        title: Text("Notificações"),
        trailing: Switch(
          value: lessonNotifsEnabled,
          onChanged: (value) async {
            await _toggleLessonNotifs(value);
          },
        ),
      ),
      if (lessonNotifsEnabled)
        ListTile(
          leading: Icon(Icons.notification_important),
          title: Text("Aulas"),
          trailing: Dropdown<String>(
            value: lessonNotifsTime,
            items: [
              DropdownMenuItem<String>(
                value: "5",
                child: Text("5 minutos"),
              ),
              DropdownMenuItem<String>(
                value: "10",
                child: Text("10 minutos"),
              ),
              DropdownMenuItem<String>(
                value: "30",
                child: Text("30 minutos"),
              ),
            ],
            onChanged: (String? value) {
              if (value != null) {
                _saveLessonNotifTime(value);
              }
            },
          ),
        ),
      /*ListTile(
        leading: Icon(Icons.notification_important),
        title: Text("Tarefas"),
        trailing: Dropdown<String>(
          value: "5",
          items: [
            DropdownMenuItem<String>(
              value: "5",
              child: Text("5 minutos"),
            ),
            DropdownMenuItem<String>(
              value: "10",
              child: Text("10 minutos"),
            ),
            DropdownMenuItem<String>(
              value: "30",
              child: Text("30 minutos"),
            ),
          ],
          onChanged: (String? value) {},
        ),
      ),*/
    ]);
  }
}

class PreferenceSettings extends StatelessWidget {
  const PreferenceSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return ListSection(title: "Preferences", children: [
      ListTile(
        leading: Icon(Icons.language),
        title: Text("Lingua"),
        trailing: Dropdown<String>(
          value: "pt",
          items: [
            DropdownMenuItem<String>(
              value: "pt",
              child: Text("Portugues"),
            ),
            DropdownMenuItem<String>(
              value: "en",
              child: Text("English"),
            ),
          ],
          onChanged: (String? value) {},
        ),
      ),
    ]);
  }
}

class ExtraSettings extends StatefulWidget {
  const ExtraSettings({super.key});

  @override
  State<StatefulWidget> createState() => ExtraSettingsState();
}

class ExtraSettingsState extends State<ExtraSettings> {
  final TextEditingController _serverController =
      TextEditingController(text: 'https://api.goipvc.xyz');
  final FocusNode _serverFocusNode = FocusNode();
  Color _serverBorderColor = Colors.grey;

  Future<void> _pingServer() async {
    final String serverUrl = _serverController.text;

    try {
      final response =
          await http.get(Uri.parse(serverUrl)).timeout(Duration(seconds: 5));

      if (response.statusCode == 200) {
        setState(() {
          _serverBorderColor = Colors.green;
        });
      }
    } catch (e) {
      setState(() {
        _serverBorderColor = Colors.red;
      });
    }
  }

  void _showServerSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _serverController,
                focusNode: _serverFocusNode,
                decoration: InputDecoration(
                  labelText: "Server:",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: _serverBorderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: _serverBorderColor),
                  ),
                ),
                autocorrect: false,
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: _pingServer,
                  child: Text("Test"),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Save")),
              ],
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListSection(title: "Extra", children: [
      ListTile(
        leading: Icon(Icons.dns),
        title: Text("Server"),
        trailing: ValueListenableBuilder<TextEditingValue>(
          valueListenable: _serverController,
          builder: (context, value, child) {
            return TextContainer(text: value.text);
          },
        ),
        onTap: () {
          _showServerSettings(context);
        },
      ),
      ListTile(
        leading: Icon(
          Icons.delete_forever,
          color: Colors.red,
        ),
        title: Text(
          "Eliminar Dados",
          style: TextStyle(color: Colors.red),
        ),
        onTap: () {},
      ),
    ]);
  }
}
