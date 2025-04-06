import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goipvc/ui/widgets/skeleton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:goipvc/providers/data_providers.dart';
import 'package:goipvc/ui/widgets/list_section.dart';
import 'package:goipvc/ui/widgets/card.dart';
import 'package:goipvc/ui/widgets/profile_picture.dart';

import 'menu/profile.dart';
import 'menu/curricular_units.dart';
import 'menu/calendar.dart';
import 'menu/teachers.dart';
import 'menu/tuition_fees.dart';
import 'menu/about.dart';
import './privacy.dart';
import './terms.dart';
import 'menu/settings.dart';

class MenuScreen extends ConsumerWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
        child: RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(studentInfoProvider);
        ref.invalidate(studentImageProvider);
      },
      child: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            child: UserCard(),
          ),
          ListSection(title: "Geral", children: [
            ListTile(
              leading: Icon(Icons.school),
              title: Text("Unidades Curriculares"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CurricularUnitsScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_month),
              title: Text("Calendário Académico"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CalendarScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text("Corpo Docente"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TeachersScreen()));
              },
            ),
            // ListTile(
            //  leading: Icon(Icons.watch_later),
            //  title: Text("Horário de Serviços"),
            // )
          ]),
          ListSection(title: "Académicos", children: [
            ListTile(
              leading: Image.asset(
                'assets/logos/services/academicos.png',
                width: 20,
                height: 20,
              ),
              title: Text("Académicos"),
              trailing: Icon(Icons.launch),
              onTap: () async {
                final url = Uri.parse(
                    'https://academicos.ipvc.pt/netpa/page?stage=difhomestage');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.local_atm),
              title: Text("Propinas"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TuitionFeesScreen()));
              },
            ),
            // ListTile(
            //  leading: Icon(Icons.calendar_today),
            //  title: Text("Exames"),
            // )
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
              onTap: () async {
                final appUrl = Uri.parse('sasocial://job-fair');
                final webUrl =
                    Uri.parse('https://sasocial.sas.ipvc.pt/dashboard');

                try {
                  await launchUrl(appUrl);
                } catch (e) {
                  try {
                    await launchUrl(webUrl);
                  } catch (e) {
                    throw 'Could not launch $webUrl';
                  }
                }
              },
            ),
            // -------------------
            // Expected for later - SHOULD BE USED OR REMOVED
            // -------------------
            // ListTile(
            //   leading: Icon(Icons.credit_card),
            //   title: Text("Conta"),
            // )
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
              onTap: () async {
                final url = Uri.parse('https://on.ipvc.pt/dash.php');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
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
              onTap: () async {
                final appUrl = Uri.parse('moodlemobile://.MainActivity');
                final webUrl =
                    Uri.parse('https://elearning.ipvc.pt/ipvc2024/my/');

                try {
                  await launchUrl(appUrl);
                } catch (e) {
                  try {
                    await launchUrl(webUrl);
                  } catch (e) {
                    throw 'Could not launch $webUrl';
                  }
                }
              },
            )
          ]),
          Divider(),
          ListSection(children: [
            ListTile(
              leading: Icon(Icons.info),
              title: Text("Sobre"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AboutScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.gavel),
              title: Text("Termos de uso"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TermsScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.shield),
              title: Text("Política de privacidade"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PrivacyScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Definições"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: () async {
                ref.invalidate(prefsProvider);
                ref.invalidate(firstNameProvider);
                ref.invalidate(balanceProvider);
                ref.invalidate(studentIdProvider);
                ref.invalidate(lessonsProvider);
                ref.invalidate(studentInfoProvider);
                ref.invalidate(studentImageProvider);
                ref.invalidate(curricularUnitProvider);
                ref.invalidate(curricularUnitsResponseProvider);
                ref.invalidate(curricularUnitsProvider);
                ref.invalidate(averageGradeProvider);
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
    ));
  }
}

class UserCard extends ConsumerWidget {
  const UserCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentInfoAsync = ref.watch(studentInfoProvider);

    return FilledCard(
        icon: Icons.person,
        title: "Perfil",
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
            loading: () => Padding(
              padding: EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  CircleSkeleton(size: 48),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Skeleton(height: 52)
                      ],
                    ),
                  ),
                ],
              ),
            ),
            error: (_, __) => Wrap(
              spacing: 4,
              children: [
                Icon(Icons.error, color: Colors.red),
                Text('Erro ao carregar informações')
              ],
            ),
          ),
        ]);
  }
}
