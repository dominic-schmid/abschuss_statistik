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

const rehwildFarbe = Color.fromRGBO(73, 130, 5, 1);
const rotwildFarbe = Color.fromRGBO(230, 74, 25, 1);
const gamswildFarbe = Color.fromRGBO(0, 183, 195, 1);
const steinwildFarbe = Color.fromRGBO(55, 71, 79, 1);
const schwarzwildFarbe = Color.fromRGBO(35, 35, 35, 1);
const spielhahnFarbe = Color.fromRGBO(255, 235, 59, 1);
const steinhuhnFarbe = Color.fromRGBO(0, 137, 123, 1);
const schneehuhnFarbe = Color.fromRGBO(116, 77, 169, 1);
const murmeltierFarbe = Color.fromRGBO(136, 14, 79, 1);
const dachsFarbe = Color.fromRGBO(66, 66, 66, 1);
const fuchsFarbe = Color.fromRGBO(255, 140, 0, 1);
const schneehaseFarbe = Color.fromRGBO(107, 105, 214, 1);
const wildFarbe = Color.fromRGBO(16, 137, 62, 1);
