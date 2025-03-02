import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goipvc/ui/widgets/error_message.dart';
import 'package:goipvc/ui/widgets/profile_picture.dart';
import 'package:goipvc/providers/data_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentInfoAsync = ref.watch(studentInfoProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).profile),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(studentInfoProvider);
          ref.invalidate(studentImageProvider);
        },
        child: studentInfoAsync.when(
          data: (info) => ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    ProfilePicture(
                      size: 100,
                    ),
                    Text(
                      info.fullName,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '#${info.studentId}',
                      style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.onSurfaceVariant
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Divider(),
              ),
              ListTile(
                leading: Icon(Icons.email),
                title: Text(S.of(context).email),
                subtitle: Text(info.email),
              ),
              ListTile(
                leading: Icon(Icons.school),
                title: Text(S.of(context).course),
                subtitle: Text(info.course),
              ),
              ListTile(
                leading: Icon(Icons.apartment),
                title: Text(S.of(context).school),
                subtitle: Text(info.schoolName),
              ),
            ],
          ),
          loading: () => Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stackTrace) => ErrorMessage(
            error: error.toString(),
            stackTrace: stackTrace.toString(),
            callback: () async {
              ref.invalidate(studentInfoProvider);
              ref.invalidate(studentImageProvider);
            }
          )
        ),
      )
    );
  }
}