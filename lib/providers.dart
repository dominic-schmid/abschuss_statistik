import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

//---This to switch theme from Switch button----
class ThemeProvider extends ChangeNotifier {
  //-----Store the theme of our app--
  ThemeMode themeMode;

  //----If theme mode is equal to dark then we return True----
  //-----isDarkMode--is the field we will use in our switch---
  bool get isDarkMode => themeMode == ThemeMode.dark;

  ThemeProvider({required this.themeMode});

  //---implement ToggleTheme function----
  void toggleTheme(bool isDarkTheme) {
    themeMode = isDarkTheme ? ThemeMode.light : ThemeMode.dark;

    //---notify material app to update UI----
    notifyListeners();
    savePrefs();
  }

  void savePrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
    print('Set dark mode $isDarkMode');
  }
}
