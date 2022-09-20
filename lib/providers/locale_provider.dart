import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale locale;

  LocaleProvider({required this.locale});

  void updateLocale(Locale locale) {
    this.locale = locale;
    notifyListeners();
  }
}
