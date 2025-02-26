import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String formatTimeToHours(String dateTime) {
  final date = DateTime.parse(dateTime);
  return DateFormat.Hm().format(date);
}

class LanguageSettings {
  static const String LANGUAGE_CODE_KEY = 'language_code';

  // Default language is Portuguese
  static const String DEFAULT_LANGUAGE = 'pt';

  // Get the saved locale or return default
  static Future<Locale> getSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(LANGUAGE_CODE_KEY) ?? DEFAULT_LANGUAGE;
    return Locale(languageCode);
  }

  // Save the selected locale
  static Future<void> saveLocale(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(LANGUAGE_CODE_KEY, languageCode);
  }
}