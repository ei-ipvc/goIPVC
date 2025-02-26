import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageState {
  final String languageCode;

  const LanguageState({
    this.languageCode = 'pt',
  });

  LanguageState copyWith({
    String? languageCode,
  }) {
    return LanguageState(
      languageCode: languageCode ?? this.languageCode,
    );
  }

  Locale get locale => Locale(languageCode);
}

// Notifier to manage language state
class LanguageNotifier extends StateNotifier<LanguageState> {
  LanguageNotifier() : super(const LanguageState()) {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedLanguage = prefs.getString('language_code');
    if (savedLanguage != null) {
      state = state.copyWith(languageCode: savedLanguage);
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', languageCode);
    state = state.copyWith(languageCode: languageCode);
  }

  String getLanguageName() {
    switch (state.languageCode) {
      case 'pt':
        return 'Português';
      case 'en':
        return 'English';
      default:
        return 'Unknown';
    }
  }
}