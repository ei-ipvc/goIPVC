import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ServerUrlState {
  final String url;
  final ServerStatus status;

  const ServerUrlState({
    required this.url,
    this.status = ServerStatus.unknown,
  });

  ServerUrlState copyWith({
    String? url,
    ServerStatus? status,
  }) {
    return ServerUrlState(
      url: url ?? this.url,
      status: status ?? this.status,
    );
  }
}

enum ServerStatus { unknown, online, offline }

class ServerUrlNotifier extends StateNotifier<ServerUrlState> {
  ServerUrlNotifier({required String initialUrl})
      : super(ServerUrlState(url: initialUrl)) {
    pingServer(initialUrl);
  }

  Future<void> saveServerUrl(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('server_url', url);
    state = state.copyWith(url: url);
    pingServer(url);
  }

  Future<bool> pingServer(String url) async {
    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 5));

      final isOnline = response.statusCode == 200;
      state = state.copyWith(
          status: isOnline ? ServerStatus.online : ServerStatus.offline);
      return isOnline;
    } catch (e) {
      state = state.copyWith(status: ServerStatus.offline);
      return false;
    }
  }

  Color getStatusColor() {
    switch (state.status) {
      case ServerStatus.online:
        return Colors.green;
      case ServerStatus.offline:
        return Colors.red;
      case ServerStatus.unknown:
      return Colors.grey;
    }
  }
}