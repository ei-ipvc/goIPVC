import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../containers.dart';

class ServerSettings extends StatefulWidget {
  const ServerSettings({super.key});

  @override
  State<ServerSettings> createState() => _ServerSettingsState();
}

class _ServerSettingsState extends State<ServerSettings> {
  final TextEditingController _serverController = TextEditingController();
  final FocusNode _serverFocusNode = FocusNode();
  Color _serverBorderColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    _loadServerUrl();
  }

  Future<void> _loadServerUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedServerUrl = prefs.getString('server_url');
    _serverController.text = savedServerUrl ?? 'https://api.goipvc.xyz';
  }

  Future<void> _pingServer() async {
    final String serverUrl = _serverController.text;

    try {
      final response = await http
          .get(Uri.parse(serverUrl))
          .timeout(const Duration(seconds: 5));

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
                      SharedPreferences.getInstance().then((prefs) {
                        prefs.setString(
                            'server_url', _serverController.text);
                      });
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
    return ListTile(
      leading: const Icon(Icons.dns),
      title: const Text("Server"),
      trailing: ValueListenableBuilder<TextEditingValue>(
        valueListenable: _serverController,
        builder: (context, value, child) {
          return TextContainer(text: value.text);
        },
      ),
      onTap: () {
        _showServerSettings(context);
      },
    );
  }
}