import 'package:flutter/material.dart';
import 'package:jagdverband_scraper/request_methods.dart';
import 'package:jagdverband_scraper/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/kill_entry.dart';

class CookieProvider with ChangeNotifier {
  String _cookie = "";

  String _revier = "";
  String _passwort = "";

  String get getCookie => _cookie; // Getter function for user

  Future<void> writeCredentials(String revier, String passwort) async {
    await saveCredentialsToPrefs(revier, passwort);
    print('Provider read Credentials: `$revier` `$passwort`');

    _revier = revier;
    _passwort = passwort;
    notifyListeners();
  }

  // Returns the new cookie if success, empty means wrong credentials or no prefs found
  // Should either return a valid cookie or null if you need to be logged out
  Future<String?> readPrefsOrUpdate() async {
    bool shouldRefresh = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Case when everything is set up and cookie is valid, return the cookie
    if (_revier.isNotEmpty && _passwort.isNotEmpty) {
      String tmpCookie =
          _cookie.isNotEmpty ? _cookie : prefs.getString('cookie') ?? "";
      if (tmpCookie.isNotEmpty &&
          await RequestMethods.isCookieValid(tmpCookie)) {
        _cookie = tmpCookie;
        return _cookie;
      } else {
        shouldRefresh = true;
      }
    } else if (_revier.isEmpty || _passwort.isEmpty) {
      // Otherwise read prefs and check if that cookie is valid
      String revierLogin = prefs.getString('revierLogin') ?? "";
      String revierPasswort = prefs.getString('revierPasswort') ?? "";
      String cookie = prefs.getString('cookie') ?? "";
      print('Prefs: `$revierLogin` `$revierPasswort` `$cookie`');

      if (revierLogin.isNotEmpty && revierPasswort.isNotEmpty) {
        _revier = revierLogin;
        _passwort = revierPasswort;
        if (cookie.isNotEmpty && await RequestMethods.isCookieValid(cookie)) {
          _cookie = cookie;
        } else {
          shouldRefresh = true;
        }
      } else {
        print('Fatal error occured! Revier & Pass not set in provider');
        // If preferences are empty - Here you should really be logged out?
        return null;
      }
    }

    if (shouldRefresh) {
      _cookie = await refreshCookie();
      notifyListeners();
      return _cookie;
    }

    return ""; // This means error occured
  }

  // Future<List<KillEntry>> getKills() async {
  //   String cookie = await readPrefsOrUpdate();

  //   return [];
  // }

  Future<String> refreshCookie() async {
    print('Refreshing cookie provider..');

    if (_revier.isEmpty || _passwort.isEmpty) {
      print('Fatal error! Revier & Pass not set in provider');
      return "";
    }

    //String cookie = await RequestMethods.getCookieFromLogin(_revier, _passwort);
    String cookie = 'd3eb45567f24feb21551f6c171f8fb8a'; // TODO REMOVE COOKIE
    if (cookie.isNotEmpty) {
      _cookie = cookie;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print('Wrote new cookie $_cookie to storage');
      await prefs.setString('cookie', cookie);
      notifyListeners(); // Notifies everyone using this provider to update their value
    }
    // Else login failed, maybe wrong credentials

    return cookie;
  }
}
