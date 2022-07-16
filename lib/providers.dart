import 'package:flutter/material.dart';
import 'package:jagdverband_scraper/request_methods.dart';
import 'package:jagdverband_scraper/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CookieProvider with ChangeNotifier {
  String _cookie = "";

  String _revier = "";
  String _passwort = "";

  String get getCookie => _cookie; // Getter function for user

  void setCookie(String cookie) {
    _cookie = cookie;
    notifyListeners();
  }

  Future<void> refreshCredentials(String revier, String passwort) async {
    if (revier.isNotEmpty && passwort.isNotEmpty) {
      await saveCredentialsToPrefs(revier, passwort);
      print('Provider read Credentials: `$revier` `$passwort`');

      _revier = revier;
      _passwort = passwort;
      notifyListeners();
    }
  }

  Future<void> readPrefsOrUpdate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String revierLogin = prefs.getString('revierLogin') ?? "";
    String revierPasswort = prefs.getString('revierPasswort') ?? "";
    String cookie = prefs.getString('cookie') ?? "";

    print('Prefs: `$revierLogin` `$revierPasswort` `$cookie`');

    if (revierLogin.isNotEmpty && revierPasswort.isNotEmpty) {
      _revier = revierLogin;
      _passwort = revierPasswort;
      if (cookie.isEmpty) {
        await refreshCookie();
      } else {
        _cookie = cookie;
      }
    } else {
      await refreshCookie();
    }

    notifyListeners();
  }

  Future<String> refreshCookie() async {
    print('Refreshing cookie provider..');

    if (_revier.isEmpty || _passwort.isEmpty) {
      // Map<String, String>? creds = await loadCredentialsFromPrefs();
      // if (creds == null ||
      //     !creds.containsKey('revierLogin') &&
      //         !creds.containsKey('revierPasswort')) {
      //   return "";
      // } else {
      //   _revier = creds['revierLogin']!;
      //   _passwort = creds['revierPasswort']!;
      //   print('Updated provider with new credentials.');
      // }
      print('Error! Revier & Pass not set in provider');
      return "";
    }

    String cookie = await RequestMethods.refreshCookie(_revier, _passwort);
    if (cookie.isNotEmpty && cookie != _cookie /* Should never happen */) {
      print('Saving to prefs.. New provider cookie: $cookie');
      _cookie = cookie;
      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString('cookie', cookie);
      notifyListeners(); // Notifies everyone using this provider to update their value
    }

    return cookie;
  }
}
