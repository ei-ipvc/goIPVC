import 'package:flutter/material.dart';
import 'package:goipvc/ui/widgets/containers.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class ServerTile extends StatefulWidget {
  final Function(String)? onServerChange;

  const ServerTile({this.onServerChange, super.key});

  @override
  ServerTileState createState() => ServerTileState();
}

class ServerTileState extends State<ServerTile> {
  final TextEditingController _serverController = TextEditingController();
  final FocusNode _serverFocusNode = FocusNode();
  Color _serverBorderColor = Colors.grey;
  String _displayServerUrl = 'https://api.goipvc.xyz'; // Default URL

  @override
  void initState() {
    super.initState();
    _loadServerUrl();
  }

  @override
  void dispose() {
    _serverController.dispose();
    _serverFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadServerUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedServerUrl = prefs.getString('server_url');
    if (savedServerUrl != null) {
      setState(() {
        _displayServerUrl = savedServerUrl;
      });
    }
  }

  Future<void> _saveServerUrl() async {
    final serverUrl = _serverController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('server_url', serverUrl);

    setState(() {
      _displayServerUrl = serverUrl;
    });

    if (widget.onServerChange != null) {
      widget.onServerChange!(serverUrl);
    }
  }

  Future<void> _pingServer() async {
    final String serverUrl = _serverController.text;

    try {
      final response = await http
          .get(Uri.parse(serverUrl))
          .timeout(const Duration(seconds: 5));

      setState(() {
        _serverBorderColor = response.statusCode == 200 ? Colors.green : Colors.red;
      });
    } catch (e) {
      setState(() {
        _serverBorderColor = Colors.red;
      });
    }
  }

  void _showServerSettings(BuildContext context) {
    // Set controller text to current display URL before showing dialog
    _serverController.text = _displayServerUrl;

    // Reset border color to grey when dialog opens
    setState(() {
      _serverBorderColor = Colors.grey;
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (context, setDialogState) {
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
                        onPressed: () async {
                          await _pingServer();
                          // Update the dialog state to show the border color change
                          setDialogState(() {});
                        },
                        child: Text("Test"),
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              // Just close the dialog without saving
                              Navigator.pop(context);
                            },
                            child: Text("Cancel"),
                          ),
                          SizedBox(width: 10),
                          FilledButton(
                            onPressed: () {
                              _saveServerUrl();
                              Navigator.pop(context);
                            },
                            child: Text("Save"),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              );
            }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.dns),
      title: Text("Server"),
      trailing: TextContainer(text: _displayServerUrl),
      onTap: () {
        _showServerSettings(context);
      },
    );
  }
}