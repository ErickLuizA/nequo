import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  AppLocalizations(
    this._locale, {
    this.isTest = false,
  });

  bool isTest;

  final Locale _locale;

  late Map<String, String> _sentences;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  Future<AppLocalizations> loadTest(Locale locale) async {
    return AppLocalizations(locale);
  }

  Future<AppLocalizations> load() async {
    String data = await rootBundle.loadString(
      'lang/${_locale.languageCode}.json',
    );

    Map<String, dynamic> _result = json.decode(data);

    _sentences = new Map();

    _result.forEach((String key, dynamic value) {
      _sentences[key] = value.toString();
    });

    return AppLocalizations(_locale);
  }

  String translate(String? key) {
    if (key == null) {
      return '...';
    }

    if (isTest) return key;

    return _sentences[key] ?? '...';
  }
}

class LocalizationDelegate extends LocalizationsDelegate<AppLocalizations> {
  const LocalizationDelegate({
    this.isTest = false,
  });

  final bool isTest;

  @override
  bool isSupported(Locale locale) => ['en', 'pt'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = new AppLocalizations(
      locale,
      isTest: isTest,
    );

    if (isTest) {
      await localizations.loadTest(locale);
    } else {
      await localizations.load();
    }

    return localizations;
  }

  @override
  bool shouldReload(LocalizationDelegate old) => false;
}
