import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveCredentialsToPrefs(
    String revierLogin, String revierPasswort) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  prefs.setString('revierLogin', revierLogin);
  prefs.setString('revierPasswort', revierPasswort);
}

Future<Map<String, String>?> loadCredentialsFromPrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String revierLogin = prefs.getString('revierLogin') ?? "";
  String revierPasswort = prefs.getString('revierPasswort') ?? "";
  String cookie = prefs.getString('cookie') ?? "";

  if (revierLogin.isNotEmpty && revierPasswort.isNotEmpty) {
    print('Loaded Credentials: `$revierLogin` `$revierPasswort`');
    return {
      'revierLogin': revierLogin,
      'revierPasswort': revierPasswort,
      'cookie': cookie,
    };
  } else {
    return null;
  }
}

Future<void> deletePrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Map<String, String>? creds = await loadCredentials();

  await prefs.remove('revierLogin');
  await prefs.remove('revierPasswort');
}

showSnackBar(String content, BuildContext context, {int duration = 1500}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: Duration(milliseconds: duration),
      content: Text(content),
    ),
  );
}
