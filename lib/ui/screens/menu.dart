import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goipvc/providers/data_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:goipvc/ui/widgets/list_section.dart';
import 'package:goipvc/ui/widgets/card.dart';
import 'package:goipvc/ui/widgets/profile_picture.dart';

import 'menu/profile.dart';
import 'menu/curricular_units.dart';
import 'menu/calendar.dart';
import 'menu/teachers.dart';
import 'menu/tuition_fees.dart';
import 'menu/settings.dart';

class MenuScreen extends ConsumerWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      child: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            child: UserCard(),
          ),
          ListSection(title: S.of(context).general, children: [
            ListTile(
              leading: Icon(Icons.school),
              title: Text(S.of(context).classes),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CurricularUnitsScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_month),
              title: Text(S.of(context).academic_calendar),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CalendarScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text(S.of(context).teachers),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TeachersScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.watch_later),
              title: Text(S.of(context).services_schedule),
            )
          ]),
          ListSection(title: S.of(context).academics, children: [
            ListTile(
              leading: Image.asset(
                'assets/logos/services/academicos.png',
                width: 20,
                height: 20,
              ),
              title: Text(S.of(context).academics),
              trailing: Icon(Icons.launch),
            ),
            ListTile(
              leading: Icon(Icons.local_atm),
              title: Text(S.of(context).tuition_fees),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TuitionFeesScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text(S.of(context).exams),
            )
          ]),
          ListSection(title: "SASocial", children: [
            ListTile(
              leading: Image.asset(
                'assets/logos/services/sasocial.png',
                width: 20,
                height: 20,
              ),
              title: Text("SASocial"),
              trailing: Icon(Icons.launch),
            ),
            ListTile(
              leading: Icon(Icons.credit_card),
              title: Text(S.of(context).account),
            )
          ]),
          ListSection(title: "ON", children: [
            ListTile(
              leading: Image.asset(
                'assets/logos/services/on.png',
                width: 20,
                height: 20,
              ),
              title: Text("ON"),
              trailing: Icon(Icons.launch),
            )
          ]),
          ListSection(title: "Moodle", children: [
            ListTile(
              leading: Image.asset(
                'assets/logos/services/moodle.png',
                width: 20,
                height: 20,
              ),
              title: Text("Moodle"),
              trailing: Icon(Icons.launch),
            )
          ]),
          Divider(),
          ListSection(children: [
            ListTile(
              leading: Icon(Icons.info),
              title: Text(S.of(context).about),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text(S.of(context).settings),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text(S.of(context).logout),
              onTap: () async {
                ref.invalidate(prefsProvider);
                ref.invalidate(firstNameProvider);
                ref.invalidate(balanceProvider);
                ref.invalidate(studentIdProvider);
                ref.invalidate(studentInfoProvider);
                ref.invalidate(studentImageProvider);
                ref.invalidate(lessonsProvider);
                ref.invalidate(curricularUnitsProvider);
                ref.invalidate(tuitionsProvider);

                final prefs = await SharedPreferences.getInstance();
                final serverUrl = prefs.getString('server_url');
                await prefs.clear();
                if (serverUrl != null) {
                  await prefs.setString('server_url', serverUrl);
                }
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
            ),
            SizedBox(height: 60)
          ])
        ],
      ),
    );
  }
}

class UserCard extends ConsumerWidget {
  const UserCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentInfoAsync = ref.watch(studentInfoProvider);

    return FilledCard(
        icon: Icons.person,
        title: S.of(context).profile,
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ProfileScreen()));
        },
        children: [
          studentInfoAsync.when(
            data: (info) {
              return Row(
                children: [
                  ProfilePicture(),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          info.fullName,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text('${info.courseInitials} - ${info.schoolInitials}',
                            style: TextStyle(fontSize: 14)),
                        Text('Nº ${info.studentId}',
                            style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, color: Colors.grey),
                ],
              );
            },
            loading: () => Center(
              child: CircularProgressIndicator(),
            ),
            error: (_, __) => Wrap(
              spacing: 4,
              children: [
                Icon(Icons.error, color: Colors.red),
                Text(S.of(context).error_loading_data),
              ],
            ),
          ),
        ]);
  }
}
