import 'dart:convert';
import 'dart:io';
import 'package:goipvc/main.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateService {
  static const String _githubApiUrl =
      'https://api.github.com/repos/ei-ipvc/goipvc/releases/latest';
  String key = 'last_updt_check';

  Future<void> _downloadAndInstallApk(String url) async {
    try {
      final status = await Permission.manageExternalStorage.request();
      if (!status.isGranted) {
        logger.d('storage perm denied');
        if (status.isPermanentlyDenied) {
          openAppSettings();
        }
        return;
      }

      logger.d('starting apk download');
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        logger.d('failed to download apk: ${response.statusCode}');
        return;
      }

      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/goipvc_updt.apk';
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      logger.d('apk downloaded to $filePath');

      final result = await OpenFilex.open(filePath);
      logger.d('openfilex res: ${result.type}, msg: ${result.message}');
    } catch (e, stackTrace) {
      logger.e('error during apk download or installation',
          error: e, stackTrace: stackTrace);
    }
  }

  Future<void> checkForUpdate(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final lastUpdtCheck = prefs.getInt(key);
    final now = DateTime.now().millisecondsSinceEpoch;

    if (lastUpdtCheck != null &&
        now - lastUpdtCheck < Duration(minutes: 15).inMilliseconds) {
      logger.d('update check skipped, last check was less than 15 minutes ago');
      return;
    }

    try {
      final response = await http.get(Uri.parse(_githubApiUrl));
      if (response.statusCode != 200) {
        logger.d('failed to fetch latest release: ${response.statusCode}');
        return;
      }

      final latestRelease = json.decode(response.body);
      logger.d('latest release info: $latestRelease');

      final lastVer = latestRelease['tag_name'];
      final assets = latestRelease['assets'] as List?;

      final apk = assets?.firstWhere(
        (asset) => asset['name'] == 'app-release.apk',
        orElse: () => null,
      );
      final apkUrl = apk['browser_download_url'];

      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      logger.d('curr ver: $currentVersion');
      logger.d('last ver: $lastVer');
      if (currentVersion != lastVer) {
        logger.d('updt available');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Nova versão disponível: $lastVer'), // @TODO: localize
            action: SnackBarAction(
              label: 'Atualizar', // @TODO: localize
              onPressed: () {
                _downloadAndInstallApk(apkUrl);
              },
            ),
            duration: Duration(seconds: 120),
          ),
        );
      } else {
        logger.d('up-to-date');
      }
      await prefs.setInt(key, now);
    } catch (e, stackTrace) {
      logger.e('error updting', error: e, stackTrace: stackTrace);
    }
  }
}
