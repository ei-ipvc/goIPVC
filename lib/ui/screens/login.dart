import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:goipvc/ui/widgets/settings/language_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:goipvc/generated/l10n.dart';
import 'package:goipvc/providers/data_providers.dart';
import 'package:goipvc/ui/widgets/settings/server_tile.dart';
import '../init_view.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends ConsumerState<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoggingIn = false;
  String? _usernameError;
  String? _passwordError;

  Future<void> _login() async {
    setState(() {
      _usernameError = null;
      _passwordError = null;
    });

    if (_usernameController.text.isEmpty) {
      setState(() {
        _usernameError = "Username cannot be empty!";
      });
    }
    if (_passwordController.text.isEmpty) {
      setState(() {
        _passwordError = "Password cannot be empty!";
      });
    }

    if (_usernameError != null || _passwordError != null) {
      return;
    }

    setState(() {
      _isLoggingIn = true;
    });

    final String username = _usernameController.text;
    final String password = _passwordController.text;
    final String serverUrl = ref.read(serverUrlProvider).url;

    String? errorMessage;

    try {
      final response = await http
          .post(
        Uri.parse('$serverUrl/auth'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'password': password,
          'on': 'true',
          'sas': 'true',
        }),
      )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('is_logged_in', true);
        await prefs.setString('username', username);
        await prefs.setString('password', password);

        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        await prefs.setString('on_token', responseBody['on']);
        await prefs.setString('sas_token', responseBody['sas']['token']);
        await prefs.setString(
            'sas_refresh_token', responseBody['sas']['refreshToken']);

        if (mounted) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return InitView();
              },
              transitionDuration: const Duration(milliseconds: 500),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return SharedAxisTransition(
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  transitionType: SharedAxisTransitionType.vertical,
                  child: child,
                );
              },
            ),
          );
        }
      } else {
        errorMessage = 'Unknown error';
      }
    } on http.ClientException catch (e) {
      errorMessage = e.message;
    } on TimeoutException catch (_) {
      errorMessage = 'Request timed out';
    } finally {
      if (mounted) {
        setState(() {
          _isLoggingIn = false;
        });
      }
    }

    if (mounted && errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );
    }
  }


  void _showQuickSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(4),
          title: const Text("Settings"),
          content: const SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LanguageTile(),
                ServerTile(),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Close")),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              _showQuickSettings(context);
            },
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              'assets/logo.svg',
              height: 64,
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.onSurface,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            AutofillGroup(
              child: Column(
                children: [
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: S.of(context).username,
                      errorText: _usernameError,
                      errorStyle: const TextStyle(color: Colors.red),
                    ),
                    autofillHints: const [AutofillHints.username],
                    autocorrect: false,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: S.of(context).password,
                      errorText: _passwordError,
                      errorStyle: const TextStyle(color: Colors.red),
                    ),
                    obscureText: true,
                    autofillHints: const [AutofillHints.password],
                    autocorrect: false,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            FilledButton.icon(
              onPressed: _isLoggingIn ? null : _login,
              label: Text("Login"),
              icon: _isLoggingIn
                  ? Container(
                      width: 24,
                      height: 24,
                      padding: const EdgeInsets.all(2.0),
                      child: CircularProgressIndicator(),
                    )
                  : const Icon(Icons.login),
            ),
          ],
        ),
      )
    );
  }
}
